import 'package:flutter/material.dart';
import 'package:higea_app/helpers/helpers.dart';
import 'package:higea_app/models/doctor_model.dart';
import 'package:higea_app/providers/doctor_provider.dart';
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

    if(doctorProvider.doctors.isEmpty){
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [

        PaginatedDataTable(
          header: const Text('Lista de médicos de la fundación'),
          actions: _actionDoctorDataTable(),
          source: _DoctorsDataTableSource(doctorProvider.doctors, selectedRows, onSelectRow),
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

  List<Widget> _actionDoctorDataTable() {
    return [

          if(selectedRows.isEmpty)
            TextButton(
              onPressed: (){
                showDialog(context: context, builder: (_) => const AlertDoctorWidget());
              },
              child: const Text('Agregar médico')
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