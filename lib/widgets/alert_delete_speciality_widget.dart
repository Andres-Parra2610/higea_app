import 'package:flutter/material.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:provider/provider.dart';

class AlertDeleteSpecialityWidget extends StatelessWidget {
const AlertDeleteSpecialityWidget({ Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context){


    return ChangeNotifierProvider(
      create: (_) => SpecialityProvider(Speciality(idespecialidad: 0, nombreEspecialidad: '')),
      child:  _CancelDialogBody(id),
    );
  }
}

class _CancelDialogBody extends StatelessWidget {
  const _CancelDialogBody(this.id);

  final int id;

  @override
  Widget build(BuildContext context) {

    final specialityProvider = Provider.of<SpecialityProvider>(context);
    final bool isLoading = specialityProvider.isLoading;

    return AlertDialog(  
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: Color(AppTheme.secondaryColor))),
        ),
        TextButton(
          onPressed: isLoading ? null : ()async {
            final navigator = Navigator.of(context);

            final res = await specialityProvider.deleteSpeciality(id);

            res ? navigator.pop(true) : navigator.pop(false);
          },  
          child: const Text('Aceptar')
        ),
      ],
      title: const Text('Eliminar especialidad especialidad'),
      content: const Text('¿Está seguro que desea eliminar la especialidad?'),
    
    );
  }
}