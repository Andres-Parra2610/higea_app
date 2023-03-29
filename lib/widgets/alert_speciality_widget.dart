import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:provider/provider.dart';

class AlertSpecialityWidget extends StatelessWidget {
  const AlertSpecialityWidget({
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

    final specialityProvider = Provider.of<SpecialityProvider>(context);
    final bool isLoading = specialityProvider.isLoading;

    return AlertDialog(
      actions: [
        TextButton(
          onPressed: isLoading ? null : ()async {
            if(!specialityProvider.formKey.currentState!.validate()) return;
            final navigator = Navigator.of(context);
            var res;

            if(specialityProvider.currentSpeciality.idespecialidad !=0){

              res = await specialityProvider.updateSpeciality();

            }else{

              res = await specialityProvider.insertSpeciality();

            }

            res ? navigator.pop(true) : navigator.pop(false);
          }, 
          child: const Text('Guardar especialidad')
        )
      ],
      scrollable: true,
      title: specialityProvider.currentSpeciality.idespecialidad == 0 
        ? const Text('Agregar especialidad') 
        :  const Text('Editar especialidad'),
      content: _AddSpecialityBody(specialityProvider),
    );
  }
}

class _AddSpecialityBody extends StatelessWidget {
  const _AddSpecialityBody(this.specialityProvider);

  final SpecialityProvider specialityProvider;

  @override
  Widget build(BuildContext context) {

    final Speciality speciality = specialityProvider.currentSpeciality;
    final bool isLoading = specialityProvider.isLoading;

    return SizedBox(
      width: 500,
      child: Column(
        children: [
          Form(
            key: specialityProvider.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: speciality.nombreEspecialidad,
                  readOnly: isLoading,
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
    
                const SizedBox(height: 20),


                if(speciality.imagenEspecialidad != '' && specialityProvider.pickedImage == null)
                  Image(
                    image: NetworkImage(speciality.imagenEspecialidad!),
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  )
                else if(specialityProvider.pickedImage != null)
                  Image.memory(
                    specialityProvider.pickedImage!.bytes!,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  )
                else const Center(child: Text('No hay imagen seleccionada')),
                  
            
                
                const SizedBox(height: 20),
    
                ElevatedButton(
                  onPressed: isLoading ? null : (){
                    Provider.of<SpecialityProvider>(context, listen: false).pickImage();
                  }, 
                  child: const Text('Agregar imagen')
                )
              ],
            ),
          ),

          if(isLoading) Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: const Center(
              child: CircularProgressIndicator()
            )
          ),
        ],
      ),
    );
  }
}