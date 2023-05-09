import 'package:flutter/material.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:provider/provider.dart';

class CancelAppoimentDoctorWidget extends StatefulWidget {
const CancelAppoimentDoctorWidget({ Key? key, required this.appoimentId }) : super(key: key);

  final int appoimentId;

  @override
  State<CancelAppoimentDoctorWidget> createState() => _CancelAppoimentDoctorWidgetState();
}

class _CancelAppoimentDoctorWidgetState extends State<CancelAppoimentDoctorWidget> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context){


    final historyProvider = Provider.of<HistoryProvider>(context, listen: false);

    return AbsorbPointer(
      absorbing: isLoading,
      child: AlertDialog(
        scrollable: false,
        title: const Text('Marcar como inasistente'),
        insetPadding: const EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Color(AppTheme.secondaryColor), fontSize: 14),),
          ),
    
          TextButton(
            onPressed: () async{
              setState(() => isLoading = true);
              final navigator = Navigator.of(context);
              final Response res = await historyProvider.inattentiveAppoiment(widget.appoimentId);
              navigator.pop(res);
              setState(() => isLoading = true);
            }, 
            child: const Text('Aceptar', style: TextStyle(fontSize: 14),),
          )
        ],
    
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const Text('Posterior a marcarla como inasistente no podrá editar la cita'),
        ),
      ),
    );
  }
}