
import 'package:flutter/material.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/styles/app_theme.dart';

class HistoryDetailsWidget extends StatelessWidget {
const HistoryDetailsWidget({ 
  Key? key, 
  required this.history, 
  required this.isDoctor 
}) : super(key: key);


  final History history;
  final bool isDoctor;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: AppTheme.horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Center(child: Text('Información de la historia médica')),
              const SizedBox(height: 20,),

              _SpanText(mainText: '#Número de cita: ', secondText: '${history.idhistorial}',),
              const Divider(),

              _SpanText(mainText: 'Nombre del paciente: ', secondText: '${history.nombrePaciente} ${history.apellidoPaciente}'),
              const Divider(),

              _SpanText(mainText: 'Especialidad atendida: ', secondText: '${history.nombreEspecialidad}'),
              const Divider(),

              _SpanText(mainText: 'Nombre del médico: ', secondText: '${history.nombreMedico} ${history.apellidoMedico}'),
              const Divider(),

              _SpanText(mainText: 'Hora y fecha de la cita: ', secondText: '${history.fechaCitaStr} - ${history.horaCitaStr}'),
              const SizedBox(height: 20,),


              Visibility(
                visible: isDoctor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Nota médica: '),
                    const SizedBox(height: 10,),

                    TextFormField(
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.normal),
                      readOnly: true,
                      initialValue: history.notaMedica,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      minLines: 2,
                    ),

                    const SizedBox(height: 20,),
                  ]
                )
              ),

              const Text('Observaciones de la cita: '),
              const SizedBox(height: 10,),

              TextFormField(
                style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.normal),
                readOnly: true,
                initialValue: history.observaciones,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                minLines: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpanText extends StatelessWidget {
  const _SpanText({
    required this.mainText,
    required this.secondText
  });

  final String mainText;
  final String secondText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: RichText(
        text:  TextSpan(
            text: mainText,
            style: const TextStyle( fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
            children: <TextSpan>[
              TextSpan(text: secondText, style: const TextStyle(fontWeight: FontWeight.normal))
            ]
        ),
      ),
    );
  }
}