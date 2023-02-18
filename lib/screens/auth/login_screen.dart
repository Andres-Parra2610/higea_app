import 'package:flutter/material.dart';
import 'package:higea_app/styles/app_theme.dart';

class LoginScreen extends StatelessWidget {
const LoginScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){

    final textTheme = Theme.of(context).textTheme;

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
                onTap: () => Navigator.pushNamed(context, 'register'),
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

    final textTheme = Theme.of(context).textTheme;

    return Form(
      child: Padding(
        padding:  const EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Cédula de identidad'
              ),
            ),

            const SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Contraseña',
                suffixIcon: IconButton(
                  onPressed: (){}, 
                  icon: const Icon(Icons.visibility_off_outlined)
                )
              ),
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
                onPressed: () => Navigator.pushReplacementNamed(context, 'home-client'), 
                child: const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Text('Ingresar'),),
              ),
            )
          ],
        ),
      )
    );
  }
}