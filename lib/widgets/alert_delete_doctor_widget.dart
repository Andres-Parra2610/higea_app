
import 'package:flutter/material.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:provider/provider.dart';

class AlertDeleteDoctorWidget extends StatelessWidget {
const AlertDeleteDoctorWidget({ Key? key, required this.doctorCi }) : super(key: key);

  final int doctorCi; 

  @override
  Widget build(BuildContext context){

    final doctorProvider = Provider.of<DoctorProvider>(context);

     return AlertDialog(  
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: Color(AppTheme.secondaryColor))),
        ),
        TextButton(
          onPressed: doctorProvider.isLoading ? null : ()async {
            final navigator = Navigator.of(context);
            
            final res = await doctorProvider.deleteDoctor(doctorCi);

            res ? navigator.pop(true) : navigator.pop(false);
          },  
          child: const Text('Aceptar')
        ),
      ],
      title: const Text('Eliminar doctor'),
      content: const Text('¿Está seguro que desea eliminar el doctor?'),
    
    );
  }
}