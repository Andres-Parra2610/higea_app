import 'package:flutter/material.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:higea_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SpecialitiesListAdminScreen extends StatelessWidget {

  const SpecialitiesListAdminScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){

    final doctorProvider = Provider.of<DoctorProvider>(context);

    return FutureBuilder(
      future: doctorProvider.showSpecialities(),
      builder: (context, AsyncSnapshot<List<Speciality>> snapshot) {

        if(!snapshot.hasData){
          return const Center(child: CircularProgressIndicator());
        }

        List<Speciality>? specialities = snapshot.data; 

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            _SpecialitiesDataTable(specialities: specialities),
          ],
        );
      }
    );
  }
}

class _SpecialitiesDataTable extends StatefulWidget {


  const _SpecialitiesDataTable({
    required this.specialities,
  });

  final List<Speciality>? specialities;

  @override
  State<_SpecialitiesDataTable> createState() => _SpecialitiesDataTableState();
}

class _SpecialitiesDataTableState extends State<_SpecialitiesDataTable> {

  List<int> selectedRows = [];

  void onSelectRow(value, index){
    setState(() {
      value ? selectedRows.add(index) : selectedRows.remove(index);
    });
  }


  @override
  Widget build(BuildContext context) {

    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);

    return PaginatedDataTable(
      header: const Text('Especialidades'),
      dataRowHeight: 98.0,
      actions: _specialityActions(context, doctorProvider),
      source: _SpecialityDataTableSource(widget.specialities!, selectedRows, onSelectRow),
      columns: const <DataColumn>[
        DataColumn(
          label: Expanded(
            child: Text('ID'),
          )
        ),
        DataColumn(
          label: Expanded(
            child: Text('Nombre de la especialidad'),
          )
        ),
        DataColumn(
          label: Expanded(
            child: Text('Imagen'),
          )
        ),
      ], 
    );
  }



  List<Widget> _specialityActions(BuildContext context, DoctorProvider doctorProvider) {
    final List<Speciality> specialities = doctorProvider.specialities;
    return [
      if(selectedRows.isEmpty)
         _AddSpecialityButton(doctorProvider) 
      
      else if(selectedRows.length == 1)
        _ActionButtons(specialities: specialities, selectedRows: selectedRows, doctorProvider: doctorProvider,)

    ];
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.specialities,
    required this.selectedRows,
    required this.doctorProvider
  });

  final List<Speciality> specialities;
  final List<int> selectedRows;
  final DoctorProvider doctorProvider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () async{
            final Speciality speciality = specialities.firstWhere((spe) => selectedRows[0] == spe.idespecialidad);

            final res = await showDialog(context: context, builder: (_) => AlertSpecialityWidget(
              speciality: speciality)
            );

            if(res == null) return;
            
            if(res){
              doctorProvider.render = true;
              SnackBarWidget.showSnackBar('La especialidad se ha editado correctamente');
            }else{
              SnackBarWidget.showSnackBar('Ocurrió un error al editar la especialidad', false);
            }

          }, 
          icon: const Icon(Icons.edit),
          tooltip: 'Editar especialidad',
        ),
        IconButton(
          onPressed: () async{
            final int id = selectedRows[0];
            final res = await showDialog(context: context, builder: (_) => AlertDeleteSpecialityWidget(id: id));

            if(res == null) return;

            if(res){
              selectedRows.remove(selectedRows[0]);
              doctorProvider.render = true;
              SnackBarWidget.showSnackBar('La especialidad se ha eliminado correctamente');
            }else{
              SnackBarWidget.showSnackBar('Ocurrió un error al eliminar la especialidad', false);
            }
          }, 
          icon: const Icon(Icons.delete),
          tooltip: 'Eliminar especialidad',
        )
      ],
    );
  }
}

class _AddSpecialityButton extends StatelessWidget {
  const _AddSpecialityButton(this.doctorProvider);

  final DoctorProvider doctorProvider;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async{
        final  res = await showDialog(context: context, builder: (_) => AlertSpecialityWidget(
          speciality:Speciality(idespecialidad: 0, nombreEspecialidad: '', imagenEspecialidad: ''))
        );

        if(res == null) return;
        
        if(res){
          doctorProvider.render = true;
          SnackBarWidget.showSnackBar('La especialidad se ha agregado correctamente');
        }else{
          SnackBarWidget.showSnackBar('La especialidad ya existe', false);
        }


      }, 
      child: const Text('Agregar especialidad')
    );
  }
}



class _SpecialityDataTableSource extends DataTableSource{  

  _SpecialityDataTableSource(this.data, this.selected, this.onSelectedRow);

  final List<Speciality> data;
  final List<int> selected;
  final Function onSelectedRow;

  @override
  DataRow? getRow(int index) {

    final Speciality speciality = data[index];
    final isSelected = selected.contains(speciality.idespecialidad);

    return DataRow.byIndex(
      selected:  isSelected,
      onSelectChanged: (value) {
        if(value == null) return;
        onSelectedRow(value, speciality.idespecialidad);
        notifyListeners();
      },
      index: index,
      cells: <DataCell>[
        DataCell(Text(speciality.idespecialidad.toString())),
        DataCell(Text(speciality.nombreEspecialidad)),
        DataCell(
          _SpecialityImage(image: speciality.imagenEspecialidad)
        ),
      ]
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;

}

class _SpecialityImage extends StatelessWidget {
  const _SpecialityImage({
    required this.image,
  });

  final String? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8)
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child:  Image(
          image: image!.isNotEmpty && image!.startsWith('https') 
            ? NetworkImage(image!) 
            : const AssetImage('assets/no-image.jpg') as ImageProvider,
          width: 150,
          height: 200,
          fit: BoxFit.cover,
        ), 
      ),
    );
  }
}