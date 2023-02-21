import 'package:flutter/material.dart';
import 'package:higea_app/styles/app_theme.dart';

class ShowDialogWidget extends StatelessWidget {
const ShowDialogWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    var textStyle = const TextStyle(fontSize: 18);
    return AlertDialog(
      scrollable: true,
      buttonPadding: const EdgeInsets.all(25),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: Color(AppTheme.secondaryColor), fontSize: 16),),
        ),
        TextButton(
          onPressed: (){
            
          },
          child: const Text('Aceptar', style: TextStyle(fontSize: 16),),
        ),
      ],
      title: Text('Detalles de la cita médica', style: Theme.of(context).textTheme.headline6,),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.55,
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text('Paciente', style: textStyle,),
              TextFormField(
                initialValue: 'Andrés Parra',
                decoration: const InputDecoration(
                  helperText: 'Nota: Si el paciente es menor o de tercera edad debe dirigirse a la fundación con un representante',
                  helperMaxLines: 2,
                ),
              ),

              const SizedBox(height: 20),

              Text('Email', style: textStyle,),
              TextFormField(
                initialValue: 'andresparra261000@gmail.com',
              ),

              const SizedBox(height: 20),

              Text('Fecha', style: textStyle,),
              TextFormField(
                initialValue: '21/02/2023',
                readOnly: true,
              ),

              const SizedBox(height: 20),

              Text('Hora', style: textStyle,),
              TextFormField(
                initialValue: '8:00 am',
                readOnly: true,
              ),
            ],
          ),
        ),
      )
    );
  }
}