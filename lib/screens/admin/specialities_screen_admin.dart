import 'package:flutter/material.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:higea_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SpecialitiesScreenAdmin extends StatelessWidget {



  const SpecialitiesScreenAdmin({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){

    final doctorProvider = Provider.of<DoctorProvider>(context);



    return FutureBuilder(
      future: doctorProvider.showSpecialities(),
      builder: (context, AsyncSnapshot<List<Speciality>> snapshot) {

        print('Me render');

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
      actions: [
        selectedRows.isEmpty ? TextButton(
          onPressed: () async{
            final  res = await showDialog(context: context, builder: (_) => AddSpecialityWidget(
              speciality:Speciality(idespecialidad: 0, nombreEspecialidad: '', imagenEspecialidad: ''))
            );
           
            res ? await doctorProvider.showSpecialities() : null; 
          }, 
          child: const Text('Agregar especialidad')
        ) : Container()
      ],
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
          Image(
            image: NetworkImage(speciality.imagenEspecialidad!),
            width: 300,
            height: 300,
            fit: BoxFit.cover,
          )
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