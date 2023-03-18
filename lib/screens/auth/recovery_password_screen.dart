import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:higea_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:higea_app/styles/app_theme.dart';

class RecoveryPasswordScreen extends StatelessWidget {
const RecoveryPasswordScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 30,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(AppTheme.primaryColor)),
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20),
              Text('Recuperar contraseña', style: TextStyle(
                fontSize: textTheme.headlineSmall!.fontSize, 
                color: const Color(AppTheme.primaryColor
                )
              )),
        
              const SizedBox(height: 20),
        
              const _FormInputCi(),

             
            ],
          ),
        ),
      ),
    );
  }
}

class _FormInputCi extends StatelessWidget {
  const _FormInputCi();



  @override
  Widget build(BuildContext context) {
    final recoveryPorovider = Provider.of<RecoveryPasswordProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Form(
          key: recoveryPorovider.userCiKey,
          child: TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [ FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$')) ],
            decoration: const InputDecoration(
              labelText: 'Ingesa la cédula',
              helperText: 'Al ingresar su cédula se le estará enviando un código por correo electrónico asociado a esa cédula',
              helperMaxLines: 3
            ),
            onChanged: (value) => recoveryPorovider.userCi = value,
            validator: (value) {
              if(value!.length < 7 || value.length > 8) return 'Debe ser una cédula válida';
              return null;
            },
          ),
        ),

        const SizedBox(height: 10),

        ElevatedButton(
          onPressed: recoveryPorovider.isLoading ? null : () async{
            if(!recoveryPorovider.userCiKey.currentState!.validate()) return;

            final res = await recoveryPorovider.getPatientByCi();

            if(!res){
              SnackBarWidget.showSnackBar('El usuario es inexistente');
              return;
            }

            Future.microtask((){
              showDialog(
                context: context, 
                barrierDismissible: false, 
                builder: (context) => const RecoveryPasswordWidget()
              );
            });

          }, 
          child: const Text('Enviar código')
        ),

        const SizedBox(height: 40),

        recoveryPorovider.isLoading 
          ? const Center( child: CircularProgressIndicator.adaptive())
          : Container()
       
      ],


    );
  }
}