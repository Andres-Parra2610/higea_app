
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:provider/provider.dart';

class AddSpecialityWidget extends StatelessWidget {
  const AddSpecialityWidget({
    Key? key, 
    required this.speciality
  }) : super(key: key);

  final Speciality speciality;

  @override
  Widget build(BuildContext context){

    return ChangeNotifierProvider(
      create: (_) => SpecialityProvider(speciality),
      child: const _AddSpecialityDialog(),
    );
  }
}

class _AddSpecialityDialog extends StatelessWidget {
  const _AddSpecialityDialog();

  
  @override
  Widget build(BuildContext context) {

    final specialityProvider = Provider.of<SpecialityProvider>(context, listen: false);


    return AlertDialog(
      actions: [
        TextButton(
          onPressed: ()async {
            if(!specialityProvider.formKey.currentState!.validate()) return;
            final navigator = Navigator.of(context);

            await specialityProvider.insertSpeciality();
            navigator.pop(true);
          }, 
          child: const Text('Guardar especialidad')
        )
      ],
      scrollable: true,
      title: const Text('Agregar especialidad'),
      content: const _AddSpecialityBody(),
    );
  }
}

class _AddSpecialityBody extends StatelessWidget {
  const _AddSpecialityBody();

  

  @override
  Widget build(BuildContext context) {

    final specialityProvider = Provider.of<SpecialityProvider>(context);
    final Speciality speciality = specialityProvider.currentSpeciality;

    return SizedBox(
      width: 500,
      child: Form(
        key: specialityProvider.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: speciality.nombreEspecialidad,
              inputFormatters: [ FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$'))],
              onChanged: (value) => speciality.nombreEspecialidad = value,
              decoration: const InputDecoration(
                labelText: 'Nombre de la especialidad'
              ),
              validator: (value){
                if(value!.trim().isEmpty) return 'La especialidad no puede estar vacia';
                if(value.trim().length < 4) return 'La especialidad es muy corta';
    
                return null;
              },
            ),
    
            const SizedBox(height: 30),


            specialityProvider.pickedImage == null 
              ? const Center(child: Text('No hay imagen seleccionada'))
              : Image.memory(
                  specialityProvider.pickedImage!.bytes!,
              ),
    
            ElevatedButton(
              onPressed: (){
                Provider.of<SpecialityProvider>(context, listen: false).pickImage();
              }, 
              child: const Text('Agregar imagen')
            )
          ],
        ),
      ),
    );
  }
}