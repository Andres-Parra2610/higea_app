import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:higea_app/providers/appoiment_provider.dart';
import 'package:higea_app/services/services.dart';
import 'package:higea_app/helpers/helpers.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:higea_app/models/models.dart';

class ConfirmAppoimentWidget extends StatefulWidget {
  const ConfirmAppoimentWidget({ 
    Key? key,
    required this.appoiment
  }) : super(key: key);

  final Appoiment appoiment;

  @override
  State<ConfirmAppoimentWidget> createState() => _ConfirmAppoimentWidgetState();
}

class _ConfirmAppoimentWidgetState extends State<ConfirmAppoimentWidget> {

  bool isLoading = false;



  @override
  Widget build(BuildContext context){

    final appoimetnProvider = Provider.of<AppoimentProvider>(context, listen: false);

    var textStyle = const TextStyle(fontSize: 18);
    final String appoimentHour = Helpers.transformHour(widget.appoiment.horaCita);
    final String appoimentDate = DateFormat('dd-MM-yyyy').format(widget.appoiment.fechaCita);
    final User user = User.fromRawJson(UserPreferences.user);
    final Appoiment currentAppoiment = widget.appoiment;
    final String appoimentToBd = currentAppoiment.fechaCita.toString().split(' ')[0];
  
    return AlertDialog(
      scrollable: true,
      buttonPadding: const EdgeInsets.all(25),
      insetPadding: const EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding),
      actions: [
        TextButton(
          onPressed:  isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: Color(AppTheme.secondaryColor), fontSize: 16)),
        ),
        TextButton(
          onPressed: isLoading 
            ? null 
            : () async{
                setState(() => isLoading = true);
                final navigator = Navigator.of(context);
                widget.appoiment.cedulaPaciente = user.cedula;
                final res = currentAppoiment.idCita == 0 
                  ? await appoimetnProvider.newApoiment(widget.appoiment)
                  : await appoimetnProvider.updateAppoiment(currentAppoiment.idCita, user.cedula);
                setState(() => isLoading = false);
                await appoimetnProvider.showAppoiment(currentAppoiment.cedulaMedico, appoimentToBd, appoimetnProvider.date);
                res == false ? navigator.pop(false) : navigator.pop(true);
              },
          child: const Text('Aceptar', style: TextStyle(fontSize: 16),),
        ),
      ],
      title: Text('Detalles de la cita médica', style: Theme.of(context).textTheme.titleLarge,),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.55,
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text('Paciente', style: textStyle,),

              
              TextFormField(
                initialValue: '${user.nombrePaciente} ${user.apellidoPaciente}',
                readOnly: true,
              ),

              const SizedBox(height: 20),

              Text('Email', style: textStyle,),
              TextFormField(
                initialValue: user.correo,
                readOnly: true,
              ),

              const SizedBox(height: 20),

              Text('Fecha', style: textStyle,),
              TextFormField(
                initialValue: appoimentDate,
                readOnly: true,
              ),

              const SizedBox(height: 20),

              Text('Hora', style: textStyle,),
              TextFormField(
                initialValue: appoimentHour,
                readOnly: true,
              ),

              const SizedBox(height: 30),

              isLoading
                ? const Center(child: CircularProgressIndicator.adaptive())
                : Container()
            ],
          ),
        ),
      )
    );
  }
}