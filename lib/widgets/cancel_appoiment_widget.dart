

import 'package:flutter/material.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:provider/provider.dart';

class CancelAppoimentWidget extends StatefulWidget {
const CancelAppoimentWidget({ 
  Key? key,
  required this.appoiment 
  }) : super(key: key);

  final Appoiment appoiment;

  @override
  State<CancelAppoimentWidget> createState() => _CancelAppoimentWidgetState();
}

class _CancelAppoimentWidgetState extends State<CancelAppoimentWidget> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context){

    final appoimentProvider = Provider.of<AppoimentProvider>(context, listen: false);
    final Appoiment currentAppoiment = widget.appoiment;
    final String appoimentToBd = currentAppoiment.fechaCita.toString().split(' ')[0];

    return AlertDialog(
      scrollable: false,
      title: const Text('¿Deseas cancelar la cita?'),
      insetPadding: const EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: Color(AppTheme.secondaryColor), fontSize: 16),),
        ),

        TextButton(
          onPressed: isLoading ? null : () async{
            final navigator = Navigator.of(context);
            setState(() => isLoading = true);
            final Response res = await appoimentProvider.cancelAppoiment(widget.appoiment.idCita);
            setState(() => isLoading = false);
            await appoimentProvider.showAppoiment(currentAppoiment.cedulaMedico, appoimentToBd, appoimentProvider.date);
            navigator.pop(res);
          }, 
          child: const Text('Aceptar', style: TextStyle(fontSize: 16),),
        )
      ],

      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Text('Posterior a la cancelación de la cita, no podrá reservarla de nuevo'),
      ),
    );
  }
}