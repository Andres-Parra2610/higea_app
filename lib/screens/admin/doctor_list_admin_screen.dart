import 'package:flutter/material.dart';
import 'package:higea_app/helpers/helpers.dart';
import 'package:higea_app/models/doctor_model.dart';
import 'package:higea_app/providers/doctor_provider.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:higea_app/widgets/widgets.dart';
import 'package:provider/provider.dart';



class DoctorListAdminScreen extends StatefulWidget {
const DoctorListAdminScreen({ Key? key }) : super(key: key);

  @override
  State<DoctorListAdminScreen> createState() => _DoctorListAdminScreenState();
}

class _DoctorListAdminScreenState extends State<DoctorListAdminScreen> {

  List<int> selectedRows = [];

  void onSelectRow(value, index){
    setState(() {
      value ? selectedRows.add(index) : selectedRows.remove(index);
    });
  }

  @override
  Widget build(BuildContext context){

    final doctorProvider = Provider.of<DoctorProvider>(context);

    return Column(
      children: [
        
        FutureBuilder(
          future: doctorProvider.showAllDoctors(),
          builder: (context, AsyncSnapshot<List<Doctor>> snapshot) {

            if(!snapshot.hasData){
              return const Center(child: CircularProgressIndicator());
            }

            final List<Doctor> doctors = snapshot.data!; 

            return PaginatedDataTable(
              header: const Text('Lista de médicos de la fundación'),
              actions: _actionDoctorDataTable(doctorProvider),
              source: _DoctorsDataTableSource(doctors, selectedRows, onSelectRow),
              columns: const <DataColumn>[
                DataColumn(
                  label: Expanded(
                    child: Text('Cédula del doctor'),
                  )
                ),
                DataColumn(
                  label: Expanded(
                    child: Text('Nombre del doctor'),
                  )
                ),
                DataColumn(
                  label: Expanded(
                    child: Text('Fechas laborales'),
                  )
                ),
                DataColumn(
                  label: Expanded(
                    child: Text('Horas laborales'),
                  )
                ),
              ], 
            );
          }
        )
      ],
    );
  }

  List<Widget> _actionDoctorDataTable(DoctorProvider doctorProvider) {
    return [

          if(selectedRows.isEmpty)
            TextButton(
              onPressed: () async{
                final res = await showDialog(context: context, builder: (_) => AlertDoctorWidget(doctor: Doctor.empty(), title: 'Agregar médico',));

                if(res == null) return;

                if(res){
                  doctorProvider.showAllDoctors();
                  SnackBarWidget.showSnackBar('El doctor se ha agregado correctamente');
                }else{
                  SnackBarWidget.showSnackBar('Error al agregar el doctor', false);
                }
              },
              child: const Text('Agregar médico')
            )

          else if(selectedRows.length == 1)
            Row(
              children: [
                IconButton(
                  onPressed: () async{
                    final Doctor doctor = doctorProvider.doctors.firstWhere((doc) => selectedRows[0] == doc.cedula);
                    final res = await showDialog(context: context, builder: (_) => AlertDoctorWidget(doctor: doctor, title: 'Editar médico', isEdit: true,));

                    if(res == null) return;

                    if(res){
                      doctorProvider.showAllDoctors();
                      SnackBarWidget.showSnackBar('El doctor se ha editado correctamente');
                    }else{
                      SnackBarWidget.showSnackBar('Error al editar el doctor', false);
                    }

                  }, 
                  icon: const Icon(Icons.edit),
                  tooltip: 'Editar doctor',
                ),
                IconButton(
                  onPressed: () async{
                    final int doctorCi = doctorProvider.doctors.firstWhere((doc) => selectedRows[0] == doc.cedula).cedula;
                    final res = await showDialog(context: context, builder: (_) => AlertDeleteDoctorWidget(doctorCi: doctorCi,));

                    if(res == null) return;

                    if(res){
                      selectedRows.remove(selectedRows[0]);
                      doctorProvider.showAllDoctors();
                      SnackBarWidget.showSnackBar('El doctor se ha eliminado correctamente');
                    }else{
                      SnackBarWidget.showSnackBar('Error al eliminar el doctor', false);
                    }
                  }, 
                  icon: const Icon(Icons.delete),
                  tooltip: 'Eliminar doctor',
                )
              ],
            )
        ];
  }
}


class _DoctorsDataTableSource extends DataTableSource{  

  _DoctorsDataTableSource(this.data, this.selected, this.onSelectedRow);

  final List<Doctor> data;
  final List<int> selected;
  final Function onSelectedRow;

  @override
  DataRow? getRow(int index) {

    final Doctor doctor = data[index];
    final bool isSelected = selected.contains(doctor.cedula);
    final startHour = Helpers.transformHour(doctor.horaInicio!);
    final endHour = Helpers.transformHour(doctor.horaFin!);

    return DataRow.byIndex(
      selected: isSelected,
      onSelectChanged: (value) {
        if(value == null) return;
        onSelectedRow(value, doctor.cedula);
        notifyListeners();
      },
      index: index,
      cells: <DataCell>[
        DataCell(Text(doctor.cedula.toString())),
        DataCell(Text('${doctor.nombreMedico.split(' ')[0]} ${doctor.apellidoMedico.split(' ')[0]}')),
        DataCell(Row(
          children: [
            ...doctor.fechas!.map((date) => Text('$date ')).toList()
          ],
        )),
        DataCell(Text('$startHour - $endHour')),
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