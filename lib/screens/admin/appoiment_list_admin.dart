import 'package:flutter/material.dart';
import 'package:higea_app/helpers/helpers.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AppoimentListAdmin extends StatefulWidget {
const AppoimentListAdmin({ Key? key }) : super(key: key);

  @override
  State<AppoimentListAdmin> createState() => _AppoimentListAdminState();
}

class _AppoimentListAdminState extends State<AppoimentListAdmin> {

  @override
  void initState() {
    super.initState();
    Provider.of<AppoimentProvider>(context, listen: false).getAllAppoiments();
  }

  @override
  Widget build(BuildContext context){

    final appoimentProvider = Provider.of<AppoimentProvider>(context);


    if(appoimentProvider.appoiments.isEmpty){
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      
        PaginatedDataTable(
          header: const _HeaderDataTable(),
          source: _AppoimentDataTableSource(appoimentProvider.filterAppoiments),
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
                child: Text('Nombre del doctor'),
              )
            ),
            DataColumn(
              label: Expanded(
                child: Text('Fecha de la cita'),
              )
            ),
            DataColumn(
              label: Expanded(
                child: Text('Hora de la cita'),
              )
            ),
          ], 
        )
      ],
    );
  }
}

class _HeaderDataTable extends StatelessWidget {
  const _HeaderDataTable();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: Text('Lista de citas médicas')),
        Expanded(child: _SearchAppoimentByDate())
      ],
    );
  }
}

class _SearchAppoimentByDate extends StatefulWidget {
  const _SearchAppoimentByDate();

  @override
  State<_SearchAppoimentByDate> createState() => _SearchAppoimentByDateState();
}

class _SearchAppoimentByDateState extends State<_SearchAppoimentByDate> {

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final appoimentProvider = Provider.of<AppoimentProvider>(context, listen: false);

    return TextField(
      controller: _controller,
      readOnly: true,
      decoration: const InputDecoration(
        hintText: 'Selecciona una fecha para buscar por cita',
        suffixIcon: Icon(Icons.date_range)
      ),
      onTap: () async{
        DateTime? dateTime = await showDatePicker(
          context: context, 
          initialDate: DateTime.now(), 
          firstDate: DateTime(1900), 
          lastDate: DateTime(2150),
        );

        if(dateTime == null) return;

        String dateFormat = DateFormat('dd/MM/yyyy').format(dateTime);

        _controller.text = dateFormat;
        appoimentProvider.searchAppoimentByDate(dateFormat);
      },
      
    );
  }
}



class _AppoimentDataTableSource extends DataTableSource{  

  _AppoimentDataTableSource(this.data);

  final List<Appoiment> data;

  @override
  DataRow? getRow(int index) {

    final Appoiment appoiment = data[index];
    final User user = data[index].user!;
    final Doctor doctor = data[index].doctor!;
    final date = Helpers.completeDateFromDateTime(appoiment.fechaCita);
    final hour = Helpers.transformHour(appoiment.horaCita);

    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Text(appoiment.cedulaPaciente.toString())),
        DataCell(Text('${user.nombrePaciente.split(' ')[0]} ${user.apellidoPaciente.split(' ')[0]}')),
        DataCell(Text('${doctor.nombreMedico.split(' ')[0]} ${doctor.apellidoMedico.split(' ')[0]}')),
        DataCell(Text(date)),
        DataCell(Text(hour)),
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