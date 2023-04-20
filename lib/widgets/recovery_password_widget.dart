import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:higea_app/screens/screens.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:provider/provider.dart';

class RecoveryPasswordWidget extends StatelessWidget {
const RecoveryPasswordWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    final recoveryPorovider = Provider.of<RecoveryPasswordProvider>(context, listen: false);

    return AlertDialog(
      title: const Text('Ingresar código'),
      insetPadding: const EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding),
      actions: [

        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar', style: TextStyle(fontSize: 16, color: Color(AppTheme.secondaryColor)))
        ),

        TextButton(
          onPressed: () async{
            if(!recoveryPorovider.codeVerificationKey.currentState!.validate()) return;
            final navigator = Navigator.of(context);
            final response = await recoveryPorovider.sendCode();

            response 
              ? navigator.push(MaterialPageRoute(builder: (context)=> const UpdatePasswordScreen()))
              : null;
          }, 
          child: const Text('Continuar', style: TextStyle(fontSize: 16),)
        )
      ],

      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const _FormInputCodeVerification(),
      ),
    );
  }
}

class _FormInputCodeVerification extends StatelessWidget {
  const _FormInputCodeVerification();

  @override
  Widget build(BuildContext context) {

    final recoveryPorovider = Provider.of<RecoveryPasswordProvider>(context);
    return IntrinsicHeight(
      child: Column(
        children: [
          Text('Por favor, ingrese el código enviado a ${recoveryPorovider.user.correo}'),

          const SizedBox(height: 20),

          Form(
            key: recoveryPorovider.codeVerificationKey,
            child: TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [ FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$')) ],
              decoration: const InputDecoration(
                labelText: 'Ingesa el código de verificación',
              ),
              onChanged: (value) => recoveryPorovider.codeVerification = value,
              validator: (value) {
                if(value!.trim().isEmpty || value.length < 5) return 'Debes colocar un código';
                return null;
              },
            ),
          ),


          const _ShowLoadingOrError(),
        ],
      ),
    );
  }
}

class _ShowLoadingOrError extends StatelessWidget {
  const _ShowLoadingOrError();

  @override
  Widget build(BuildContext context) {
    final recoveryPorovider = Provider.of<RecoveryPasswordProvider>(context);

    if(recoveryPorovider.isLoading){
      return Container(
        margin: const EdgeInsets.only(top: 30),
        child: const CircularProgressIndicator.adaptive()
      );
    }


    if(recoveryPorovider.isError){
      return Container(
        margin: const EdgeInsets.only(top: 30),
        child: const Text(
          'Códivo de verificación inválido',
          style: TextStyle(fontSize: 14, color: Color(AppTheme.secondaryColor))
        )
      );
    }

    return Container();
  }
}