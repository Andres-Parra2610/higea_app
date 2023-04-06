import 'package:flutter/material.dart';

class PatientListAdminScreen extends StatelessWidget {
  const PatientListAdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      source: _PatientDataTable(),
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
      ], 
    );
  }
}


class _PatientDataTable extends DataTableSource{

  @override
  DataRow? getRow(int index) {
    return DataRow.byIndex(
      index: index,
      cells: const <DataCell> [
        DataCell(Text('27539771')),
        DataCell(Text('Andrés Parra')),
        DataCell(Text('correo@gmail.com')),
        DataCell(Text('04169268819'))
      ]
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => 15;

  @override
  int get selectedRowCount => 0;

}
