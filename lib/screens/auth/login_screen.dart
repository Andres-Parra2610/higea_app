import 'package:flutter/material.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:higea_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
const LoginScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){

    final textTheme = Theme.of(context).textTheme;
    final loginProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body:  Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(image: AssetImage('assets/logo-higea.png')),
          
              const SizedBox(height: 30),
          
              Text('Iniciar sesión', style: textTheme.headline5),
          
              const SizedBox(height: 30),
          
              const _LoginForm(),
          
              const SizedBox(height: 20),
          
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, 'register');
                  loginProvider.formLoginKey.currentState!.reset();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('¿No posees cuenta? ', style: textTheme.subtitle2,),
                    Text('Regístrate', style: TextStyle(
                      fontSize: textTheme.subtitle2!.fontSize,
                      fontWeight: textTheme.subtitle2!.fontWeight,
                      color: const Color(AppTheme.secondaryColor)
                    ))
                  ],
                ),
              )
          
            ],
          ),
        )
      )
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

    print('Este es el login y me estoy renderizando');

    return Form(
      key: loginProvider.formLoginKey,
      child: Padding(
        padding:  const EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding),
        child: Column(
          children: [
            TextFormField(
              toolbarOptions: const ToolbarOptions(
                paste: false,
                copy: true
              ),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cédula de identidad'
              ),
              onChanged: (value) => formValues['ci'] = value,
              validator: (value){
                if(value!.length < 7 || value.length > 8) return 'Debe ser una cédula válida';
                
                return null;
              },
            ),

            const SizedBox(height: 20),
            TextFormField(
              obscureText: !loginProvider.showPassword,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                suffixIcon: IconButton(
                  onPressed: () => loginProvider.showPassword = !loginProvider.showPassword, 
                  icon: loginProvider.showPassword 
                    ? const Icon(Icons.visibility_off_outlined)
                    : const Icon(Icons.visibility)
                )
              ),
              onChanged: (value) => formValues['password'] = value,
              validator: (value){
                if(value!.trim().isEmpty) return 'Debe colocar una contraseña';
                return null;
              },
            ),

            const SizedBox(height: 20),

            Text(
              '¿Olvidó su contraseña?',
              style: TextStyle(
                color: const Color(AppTheme.secondaryColor),
                fontSize: textTheme.subtitle2!.fontSize,
                fontWeight: textTheme.subtitle2!.fontWeight,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loginProvider.loadingLogin
                  ? null 
                  : () async{
                    if(loginProvider.formLoginKey.currentState!.validate() == false) return;
                    FocusScope.of(context).unfocus();
                    final res = await loginProvider.loginUser();

                    if(!res){
                      SnackBarWidget.showSnackBar('Usuario o contraseña incorrectos');
                    }
                  }, 
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15), 
                  child: loginProvider.loadingLogin
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