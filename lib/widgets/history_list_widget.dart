import 'package:flutter/material.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:higea_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HistoryListWidget extends StatelessWidget {
const HistoryListWidget({ 
  Key? key, 
  required this.patient, 
  this.isDoctor = false
}) : super(key: key);


  final User patient;
  final bool? isDoctor;

  @override
  Widget build(BuildContext context){

    final historyProvider = Provider.of<HistoryProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(AppTheme.primaryColor),
        title: const Text('Historial de citas médicas', style: TextStyle(color: Colors.white),),
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: FutureBuilder(
          future: historyProvider.showHistoryByPatient(patient.cedula),
          builder: (context, AsyncSnapshot<List<History>> snapshot) {
      
            if(!snapshot.hasData){
              return const Center(child: CircularProgressIndicator());
            }
            
            if(snapshot.data!.isEmpty){
              return const Center(child: NotFoundWidget(text: 'Sin historias médicas', icon: Icons.history_edu));
            }

            return  _PatientHistoryList(snapshot.data!, isDoctor!);
          }
        ),
      ),
    );
  }
}

class _PatientHistoryList extends StatelessWidget {
  const _PatientHistoryList(this.histories, this.isDoctor);

  final List<History> histories;
  final bool isDoctor;

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: histories.length,
      itemBuilder: (context, index){

        final History history = histories[index];
        
        return Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => HistoryDetailsWidget(history: history, isDoctor: isDoctor,)));
              },
              title: Text(
                history.nombreEspecialidad!, 
                style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.normal)
              ),
              subtitle: Text(
                '${history.fechaCitaStr} - ${history.horaCitaStr}',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black45),
              ),
              trailing: const Icon(Icons.keyboard_arrow_right_outlined),
            ),
            const Divider()
          ],
        );
      }
    );
  }
}