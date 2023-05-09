import 'package:flutter/material.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:higea_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class AlertViewUserList extends StatelessWidget {
const AlertViewUserList({
   Key? key,
   this.patient,
   this.patientCi,
   required this.title
   }) : super(key: key);

  final User? patient;
  final int? patientCi;
  final String title;

  @override
  Widget build(BuildContext context){
    return AlertDialog(
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white 
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar', style: TextStyle(color: Color(AppTheme.secondaryColor), fontSize: 14)),
        )
      ],
      title: Text(title),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 900, 
          child: patient != null 
            ? _OneUser(patient: patient!)
            : _ListUser(patientCi!)
        )
      ),
    );
  }



  
}

class _ListUser extends StatelessWidget {
  const _ListUser(this.patientCi);

  final int patientCi;

  @override
  Widget build(BuildContext context) {

    final guestProvider = Provider.of<GuestProvider>(context, listen: false);

    return FutureBuilder(
      future: guestProvider.showGuestByPaTient(patientCi),
      builder:(context, AsyncSnapshot<List<Guest>> snapshot) {
        
        if(!snapshot.hasData) return const CircularProgressIndicator();

        final List<Guest> guests = snapshot.data!;

        if(guests.isEmpty) return const NotFoundWidget(text: 'Sin inviados', icon: Icons.people);

        return DataTable(
          columns: _header, 
          rows: [
            ...guests.map((Guest guest){
              return DataRow(cells: [
                DataCell(Text(guest.cedula!)),
                DataCell(Text(guest.nombreInvitado!)),
                DataCell(Text(guest.apellidoInvitado!)),
              ]);
            })
          ]
        );
        
      },
    );
  }


   List<DataColumn> get _header {
    return const [
      DataColumn(
        label: Expanded(
          child: Text('Cédula'),
        )
      ),
      DataColumn(
        label: Expanded(
          child: Text('Nombre'),
        )
      ),
      DataColumn(
        label: Expanded(
          child: Text('Apellido'),
        )
      ),
    ];
  }
}

class _OneUser extends StatelessWidget {
  const _OneUser({
    required this.patient,
  });

  final User patient;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns:  _header, 
      rows: [
        DataRow(cells: [
          DataCell(Text('${patient.cedula}')),
          DataCell(Text(patient.nombrePaciente)),
          DataCell(Text(patient.apellidoPaciente)),
          DataCell(Text(patient.correo)),
        ])
      ],
    );
  }


  List<DataColumn> get _header {
    return const [
      DataColumn(
        label: Expanded(
          child: Text('Cédula'),
        )
      ),
      DataColumn(
        label: Expanded(
          child: Text('Nombre'),
        )
      ),
      DataColumn(
        label: Expanded(
          child: Text('Apellido'),
        )
      ),
      DataColumn(
        label: Expanded(
          child: Text('Correo'),
        )
      ),
    ];
  }
}



