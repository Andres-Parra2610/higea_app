import 'package:flutter/material.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:provider/provider.dart';

class PendingAppoimentsScreen extends StatelessWidget {
const PendingAppoimentsScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){

    final appoimentProvider = Provider.of<AppoimentProvider>(context);
    final currentUser = Provider.of<AuthProvider>(context, listen: false).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Citas médicas pendientes', style: TextStyle(fontWeight: FontWeight.normal),),
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: FutureBuilder(
          future: appoimentProvider.showAppoimentByPatient(currentUser.cedulaPaciente),
          builder: (context, AsyncSnapshot<List<Appoiment>> snapshot){

            if(!snapshot.hasData){
              return const Center(child: CircularProgressIndicator(),);
            }

            return _PendingAppoimentList(snapshot.data!);
          }
        ),        
      ),
    );
  }
}

class _PendingAppoimentList extends StatelessWidget {
  const _PendingAppoimentList(this.appoiments);

  final List<Appoiment> appoiments;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: appoiments.length,
      itemBuilder: (context, index){

        final Appoiment appoiment = appoiments[index];
        final Doctor doctor = appoiment.doctor!;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding),
          title: Text(
            'Doctor(a): ${doctor.nombreMedico} ${doctor.apellidoMedico}',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              fontWeight: FontWeight.normal,
            ),
          ),
          subtitle: Text(
            '${appoiment.fechaCitaStr}',
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: Colors.black45
            ),
          ),
          trailing: Text(
            '${appoiment.horaCitaStr}',
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: Colors.black45
            ),
          ),
        );
      }
    );
  }
}