import 'package:flutter/material.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:higea_app/services/platform_device.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:higea_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class UpdatePasswordScreen extends StatelessWidget {
const UpdatePasswordScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    final textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: (){
        Navigator.popUntil(context, (route) => route.isFirst);
        return Future.value(false);
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
    
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: PlatformDevice.isMobile ? 900 : 500
              ),
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
        ),
      ),
    );
  }
}

class _UpdatePasswordForm extends StatefulWidget {
  const _UpdatePasswordForm();

  @override
  State<_UpdatePasswordForm> createState() => _UpdatePasswordFormState();
}

class _UpdatePasswordFormState extends State<_UpdatePasswordForm> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    final recoveryProvider = Provider.of<RecoveryPasswordProvider>(context, listen: false);

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
              onPressed: isLoading ? null : () async{
                if(!recoveryProvider.updatePasswordKey.currentState!.validate()) return;
                final navigator = Navigator.of(context);
                setState(()=> isLoading = true);

                final res = await recoveryProvider.newPassword();

                if(res){
                  SnackBarWidget.showSnackBar('La contraseña fué cambiada con éxito', AppTheme.primaryColor);
                  await Future.delayed(const Duration(seconds: 3));
                  navigator.popUntil((route) => route.isFirst);
                }else{
                  SnackBarWidget.showSnackBar('Un error ha ocurrido al cambiar la contraseña');
                }

                setState(()=> isLoading = false);
              }, 
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10), 
                child: Text('Cambiar contraseña'),
              )
            ),
          ),

          const SizedBox(height: 50),

          !isLoading ? Container() : const Center(
            child: CircularProgressIndicator.adaptive(),
          )
        ],
      )
    );
  }
}