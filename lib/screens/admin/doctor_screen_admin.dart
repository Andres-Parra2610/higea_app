import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:higea_app/helpers/helpers.dart';
import 'package:higea_app/models/doctor_model.dart';
import 'package:higea_app/providers/doctor_provider.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:higea_app/widgets/widgets.dart';
import 'package:provider/provider.dart';



class DoctorScreenAdmin extends StatefulWidget {
const DoctorScreenAdmin({ Key? key }) : super(key: key);

  @override
  State<DoctorScreenAdmin> createState() => _DoctorScreenAdminState();
}

class _DoctorScreenAdminState extends State<DoctorScreenAdmin> {

  List<int> selectedRows = [];

  void onSelectRow(value, index){
    setState(() {
      value ? selectedRows.add(index) : selectedRows.remove(index);
    });
  }

  @override
  void initState() {
    Provider.of<DoctorProvider>(context, listen: false).showAllDoctors();
    super.initState();
  }

  @override
  Widget build(BuildContext context){

    final doctorProvider = Provider.of<DoctorProvider>(context);
    final List<Doctor> doctors = doctorProvider.doctors;

    if(doctorProvider.doctors.isEmpty){
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [

        PaginatedDataTable(
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
                  SnackBarWidget.showSnackBar('El doctor se ha agregado correctamente', AppTheme.primaryColor);
                }else{
                  SnackBarWidget.showSnackBar('Error al agregar el doctor');
                }
              },
              child: const Text('Agregar médico')
            )

          else if(selectedRows.length == 1)
            Row(
              children: [
                IconButton(
                  onPressed: () async{
                    final Doctor doctor = doctorProvider.doctors.firstWhere((doc) => selectedRows[0] == doc.cedulaMedico);
                    final res = await showDialog(context: context, builder: (_) => AlertDoctorWidget(doctor: doctor, title: 'Editar médico', isEdit: true,));

                    if(res == null) return;

                    if(res){
                      doctorProvider.showAllDoctors();
                      SnackBarWidget.showSnackBar('El doctor se ha editado correctamente', AppTheme.primaryColor);
                    }else{
                      SnackBarWidget.showSnackBar('Error al editar el doctor');
                    }

                  }, 
                  icon: const Icon(Icons.edit),
                  tooltip: 'Editar doctor',
                ),
                IconButton(
                  onPressed: () async{
                    final int doctorCi = doctorProvider.doctors.firstWhere((doc) => selectedRows[0] == doc.cedulaMedico).cedulaMedico;
                    final res = await showDialog(context: context, builder: (_) => AlertDeleteDoctorWidget(doctorCi: doctorCi,));

                    if(res == null) return;

                    if(res){
                      selectedRows.remove(selectedRows[0]);
                      doctorProvider.showAllDoctors();
                      SnackBarWidget.showSnackBar('El doctor se ha eliminado correctamente', AppTheme.primaryColor);
                    }else{
                      SnackBarWidget.showSnackBar('Error al eliminar el doctor');
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
    final bool isSelected = selected.contains(doctor.cedulaMedico);
    final startHour = Helpers.transformHour(doctor.horaInicio);
    final endHour = Helpers.transformHour(doctor.horaFin);

    return DataRow.byIndex(
      selected: isSelected,
      onSelectChanged: (value) {
        if(value == null) return;
        onSelectedRow(value, doctor.cedulaMedico);
        notifyListeners();
      },
      index: index,
      cells: <DataCell>[
        DataCell(Text(doctor.cedulaMedico.toString())),
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