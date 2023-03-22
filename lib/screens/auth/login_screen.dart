import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:higea_app/screens/screens.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:higea_app/widgets/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
const LoginScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){

    final textTheme = Theme.of(context).textTheme;
    final loginProvider = Provider.of<AuthProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return Future.value(true);
      },
      child: Scaffold(
        body:  Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
    
                SvgPicture.asset(
                  'assets/logo-higea.svg',
                  width: 110,
                ),
                
            
                const SizedBox(height: 30),
            
                Text('Iniciar sesión', style: textTheme.headlineSmall),
            
                const SizedBox(height: 30),
            
                const _LoginForm(),
            
                const SizedBox(height: 20),
            
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const RegisterScreen(), maintainState: false)
                    );
                    FocusScope.of(context).unfocus();
                    loginProvider.formLoginKey.currentState!.reset();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('¿No posees cuenta? ', style: textTheme.titleSmall,),
                      Text('Regístrate', style: TextStyle(
                        fontSize: textTheme.titleSmall!.fontSize,
                        fontWeight: textTheme.titleSmall!.fontWeight,
                        color: const Color(AppTheme.secondaryColor)
                      ))
                    ],
                  ),
                )
            
              ],
            ),
          )
        )
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final loginProvider = Provider.of<AuthProvider>(context);
    final formValues = loginProvider.formLoginValues;
    final textTheme = Theme.of(context).textTheme;
  
    return Form(
      key: loginProvider.formLoginKey,
      child: Padding(
        padding:  const EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding),
        child: Column(
          children: [

            HigeaTextField(
              keyboardType: TextInputType.number,
              formValues: formValues, 
              labelText: 'Cédula', 
              mapKey: 'ci', 
              formatter: [ FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$')) ],
              validate: (value){
                if(value!.length < 7 || value.length > 8) return 'Debe ser una cédula válida';
                return null;
              },
            ),

            const SizedBox(height: 20),

            HigeaTextFieldPassword(
              onchanged: (value) => formValues['password'] = value,
              validate: (value){
                if (value!.trim().isEmpty) return 'Debe colocar una contraseña';
                if(value.trim().length < 7) return 'La contraseña debe tener mínimo 7 caracteres';
                return null;
              },
            ),

            const SizedBox(height: 20),

            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black12
              ),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RecoveryPasswordScreen())),
              child: Text(
                '¿Olvidó su contraseña?',
                style: TextStyle(
                  color: const Color(AppTheme.secondaryColor),
                  fontSize: textTheme.titleSmall!.fontSize,
                  fontWeight: textTheme.titleSmall!.fontWeight,
                ),
              )
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loginProvider.loading
                  ? null 
                  : () async{
                    if(!loginProvider.formLoginKey.currentState!.validate()) return;
                    FocusScope.of(context).unfocus();
                    final navigator = Navigator.of(context);
                    loginProvider.loading = true;

                    final res = await loginProvider.loginUser();

                    loginProvider.loading = false;

                    if(!res){
                      SnackBarWidget.showSnackBar('Usuario o contraseña incorrectos');
                    }else{

                      Widget screen = const IndexScreen();

                      if(loginProvider.idRol != 3) screen = const HomeDoctorScreen();
                      
                      navigator.pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => screen), 
                        (route) => false
                      );
                    }

                  }, 
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10), 
                  child: loginProvider.loading
                    ? const CircularProgressIndicator.adaptive(strokeWidth: 2)
                    : const Text('Ingresar')
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}