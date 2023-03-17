import 'package:flutter/material.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:higea_app/widgets/text_inputs_widgets.dart';
import 'package:provider/provider.dart';

class UpdatePasswordScreen extends StatelessWidget {
const UpdatePasswordScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    final textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: (){
        Navigator.popUntil(context, (route) => route.isFirst);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 30,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Color(AppTheme.primaryColor)),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ),
    
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
    
                const SizedBox(height: 20),
                Text('Coloca la nueva contraseña', style: TextStyle(
                  fontSize: textTheme.headlineSmall!.fontSize, 
                  color: const Color(AppTheme.primaryColor
                  )
                )),
          
                const SizedBox(height: 20),

                const _UpdatePasswordForm()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UpdatePasswordForm extends StatelessWidget {
  const _UpdatePasswordForm({
    super.key,
   
  });


  @override
  Widget build(BuildContext context) {

    final recoveryProvider = Provider.of<RecoveryPasswordProvider>(context);

    return Form(
      key: recoveryProvider.updatePasswordKey,
      child: Column(
        children: [
          HigeaTextFieldPassword(
            onchanged: (value) => recoveryProvider.userPassword = value,
            validate: (value){
              if (value!.trim().isEmpty) return 'Debe colocar una contraseña';
              if(value.trim().length < 7) return 'La contraseña debe tener mínimo 7 caracteres';
              return null;
            },
          ),
          const SizedBox(height: 20),

          HigeaTextFieldPassword(
            validate: (value){
              if (value!.trim().isEmpty) return 'Debe colocar una contraseña';
              if(value.trim().length < 7) return 'La contraseña debe tener mínimo 7 caracteres';
              if(value.trim() != recoveryProvider.userPassword.trim()) return 'Las contraseñas deben ser iguales';

              return null;
            },
          ),
         

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (){
                if(!recoveryProvider.updatePasswordKey.currentState!.validate()) return;
                
              }, 
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10), 
                child: Text('Recuperar contraseña'),
              )
            ),
          )
        ],
      )
    );
  }
}