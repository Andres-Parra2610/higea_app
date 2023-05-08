import 'package:flutter/material.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:higea_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class PatientListAdminScreen extends StatelessWidget {
  const PatientListAdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final patientProvider = Provider.of<PatientProvider>(context);

    return FutureBuilder(
      future: patientProvider.showPatient(),
      builder: (context, AsyncSnapshot<List<User>> snapshot) {

        if(!snapshot.hasData){
          return const Center(child: CircularProgressIndicator());
        }

        return PaginatedDataTable(
          source: _PatientDataTable(snapshot.data!, context),
          columns: const <DataColumn>[
            DataColumn(
              label: Expanded(
                child: Text('Cédula del paciente'),
              )
            ),
            DataColumn(
              label: Expanded(
                child: Text('Nombre del paciente'),
              )
            ),
            DataColumn(
              label: Expanded(
                child: Text('Correo del paciente'),
              )
            ),
            DataColumn(
              label: Expanded(
                child: Text('Teléfono del paciente'),
              )
            ),
            DataColumn(
              label: Expanded(
                child: Text(''),
              )
            ),
          ], 
        );
      }
    );
  }
}


class _PatientDataTable extends DataTableSource{

  _PatientDataTable( this.user, this.context);

  final List<User> user;
  final BuildContext context;

  @override
  DataRow? getRow(int index) {

    final User data = user[index];

    return DataRow.byIndex(
      index: index,
      cells: <DataCell> [
        DataCell(Text(data.cedula.toString())),
        DataCell(Text('${data.nombrePaciente.split(' ')[0]} ${data.apellidoPaciente.split(' ')[0]}')),
        DataCell(Text(data.correo)),
        DataCell(Text(data.telefonoPaciente)),
        DataCell(TextButton(
          onPressed: (){
            showDialog(context: context, builder: (_)=> AlertViewUserList(patientCi: data.cedula, title: 'Lista de invitados de ${data.nombrePaciente}',));
          },
          child: const Text('Invitados'),
        ))
      ]
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => user.length;

  @override
  int get selectedRowCount => 0;

}
