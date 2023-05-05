import 'package:flutter/material.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:higea_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class AppoimentsDetails extends StatelessWidget {
  const AppoimentsDetails({ 
    Key? key ,
    required this.patient, 
    required this.appoiment,
    required this.guest
  }) : super(key: key);

  final User patient;
  final Appoiment appoiment;
  final Guest? guest;

  @override
  Widget build(BuildContext context){

    final Doctor currentDoctor = Provider.of<AuthProvider>(context, listen: false).currentDoctor;
    const TextStyle textStyle = TextStyle(color: Colors.black45);

    return WillPopScope(
      onWillPop: ()async {
        Provider.of<HistoryProvider>(context, listen: false).clearProvider();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(currentDoctor.nombreMedico),
          titleTextStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Color(AppTheme.primaryColor)),
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(icon: const Icon(Icons.arrow_back), color: const Color(AppTheme.primaryColor), onPressed: (){
            Provider.of<HistoryProvider>(context, listen: false).clearProvider();
            Navigator.pop(context);
          }),
        ),
    
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const _LoadingWidget(),

                const SizedBox(height: 30),

                const Center(child: Text('Información de la cita', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
    
                const SizedBox(height: 30),

                Visibility(
                  visible: guest != null,
                  child: _InfoList(title: 'Cédula del usuario o representante', info: '${patient.cedula}'),
                ),

                guest != null ? const Divider() : Container(),

                _InfoList(title: 'Cédula del paciente', info: guest != null ? '${guest!.cedula}' : '${patient.cedula}'),
    
                const Divider(),
    
                _InfoList(title: 'Fecha y hora de la cita', info: '${appoiment.fechaCitaStr} ${appoiment.horaCitaStr}'),
                
    
                const SizedBox(height: 30),
    
                _NavigateToHistory(patient: patient, textStyle: textStyle, guest: guest,),
    
                const SizedBox(height: 30),
    
                Text( guest != null ? 'Correo del representante' : 'Correo'),
                Text(patient.correo,  style: textStyle),

                const SizedBox(height: 30),

                Text( guest != null ? 'Teléfono del representante' : 'Correo'),
                Text('0${patient.telefonoPaciente}',  style: textStyle),
    
                const SizedBox(height: 30),
    
                _FormAppoimentsDetalis(appoiment.idCita!),
    
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigateToHistory extends StatelessWidget {
  const _NavigateToHistory({
    required this.patient,
    required this.guest,
    required this.textStyle,
  });

  final User patient;
  final Guest? guest;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (_)=> HistoryListWidget(patient: patient, isDoctor: true, guest: guest,))
        );
      },
      contentPadding: const EdgeInsets.all(0),
      title: const Text('Nombre', style: TextStyle(fontSize: 14)),
      subtitle: Text(
        guest != null 
          ? '${guest!.nombreInvitado} ${guest!.apellidoInvitado}'
          : '${patient.nombrePaciente} ${patient.apellidoPaciente}',
        style: textStyle,
      ),
      trailing: const Text('Ver historial >', style: TextStyle(fontSize: 12)),
    );
  }
}

class _InfoList extends StatelessWidget {
  const _InfoList({
    required this.title,
    required this.info,
  });

  final String title;
  final String info;

  @override
  Widget build(BuildContext context) {
    const TextStyle textStyle = TextStyle(color: Colors.black45);

    return Row(
      children: [
        Expanded(child: Text(title)),
        Text(info, style: textStyle,)
      ],
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {

    final histoyProvider = Provider.of<HistoryProvider>(context);
    
    if(histoyProvider.loading){
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    return Container();
  }
}




class _FormAppoimentsDetalis extends StatelessWidget {
  const _FormAppoimentsDetalis(this.id);

  final int id;

  @override
  Widget build(BuildContext context) {

    final historyProvider = Provider.of<HistoryProvider>(context, listen: false);

    return  FutureBuilder(
      future: historyProvider.showHistory(id),
      builder: (context, AsyncSnapshot<History> snapshot) {

        if(!snapshot.hasData){
          return Column(children: const[CircularProgressIndicator.adaptive()]);
        }

        final History history = snapshot.data!;

        return Form(
          key: historyProvider.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              _SwitchFinish(history: history),
        
              const SizedBox(height: 30),
        
              const Text('Nota médica'),
        
              const SizedBox(height: 15),
              TextFormField(
                style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.normal),
                initialValue: historyProvider.currentHistory.notaMedica,
                decoration: const InputDecoration(
                  hintText: 'Ejemplo: paciente gripe'
                ),
                onChanged: (value) {
                  historyProvider.currentHistory.notaMedica = value;
                  historyProvider.writing = true;
                },
                maxLines: null,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if(value!.trim().isNotEmpty) return null;
                  return 'Debe colocar una nota médica';
                },
              ),
        
              const SizedBox(height: 30),
              
              const Text('Escriba observaciones y/o medicamentos para el paciente'),
        
              const SizedBox(height: 15),
        
              TextFormField(
                style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.normal),
                initialValue: historyProvider.currentHistory.observaciones,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                minLines: 8,
                onChanged: (value) {
                  historyProvider.currentHistory.observaciones = value;
                  historyProvider.writing = true;
                },
                validator: (value) {
                  if(value!.trim().isNotEmpty) return null;
                  return 'El campo no puede estar vacio';
                },
              ),
        
              const SizedBox(height: 30),
        
        
              const SizedBox(height: 15),
        
              _SavedButton(history: history, id: id),

              const SizedBox(height: 30),
            ],
          ),
        );
      }
    );
  }
}

class _SavedButton extends StatelessWidget {
  const _SavedButton({
    required this.history,
    required this.id,
  });

  final History history;
  final int id;

  @override
  Widget build(BuildContext context) {

    final historyProvider = Provider.of<HistoryProvider>(context);
    
    return ElevatedButton(
      onPressed: historyProvider.writing == false ? null : () async{
        if(!historyProvider.formKey.currentState!.validate() || (!historyProvider.switchValue && history.idhistorial == 0)){
          historyProvider.switchError = 'Debe marcar la cita como finalizada';
          return;
        }
        
        if(historyProvider.switchError.trim().isNotEmpty){
          historyProvider.switchError = '';
        }

        final String msg = await historyProvider.finishAppoiment(id);

        SnackBarWidget.showSnackBar(msg);
        
      }, 
      child: const Text('Guardar')
    );
  }
}




class _SwitchFinish extends StatelessWidget {
  const _SwitchFinish({
    required this.history,
  });

  final History history;

  @override
  Widget build(BuildContext context) {

    final historyProvider = Provider.of<HistoryProvider>(context);

    return Column(
      children: [
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          value: history.idhistorial != null || historyProvider.saved ? true : historyProvider.switchValue, 
          onChanged:  (value) => historyProvider.switchValue = value,
          title: const Text('¿Finalizar cita?', style: TextStyle(fontSize: 15)),
          activeColor: const Color(AppTheme.primaryColor),
          subtitle: const Text('Nota: Una vez finalizada la cita ya no podrá editarla'),
        ),

        Text(historyProvider.switchError, style: const TextStyle(color: Color.fromARGB(255, 184, 34, 24), fontSize: 12)),
      ],
    );
  }
}