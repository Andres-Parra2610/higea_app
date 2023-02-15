
import 'package:flutter/material.dart';
import 'package:higea_app/styles/app_theme.dart';

class RegisterScreen extends StatelessWidget {
const RegisterScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(AppTheme.primaryColor)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.formPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text('Regístrate', style: textTheme.headline5)),
        
              const SizedBox(height: 20),
        
              Text(
                'Datos personsales',
                style: TextStyle(
                  color: const Color(AppTheme.primaryColor),
                  fontSize: textTheme.subtitle2!.fontSize,
                  fontWeight: textTheme.subtitle2!.fontWeight,
                ),
              ),

              const SizedBox(height: 20),

              const _RegisterForm()
            ],
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nombres'
              ),
            ),

          const SizedBox(height: 20),

          TextFormField(
              decoration: const InputDecoration(
                labelText: 'Apellidos'
              ),
            ),

          const SizedBox(height: 20),

          TextFormField(
              decoration: const InputDecoration(
                labelText: 'Cédula'
              ),
            ),

          const SizedBox(height: 20),

          TextFormField(
              decoration: const InputDecoration(
                labelText: 'Correo'
              ),
            ),

          const SizedBox(height: 20),

          TextFormField(
              decoration: const InputDecoration(
                labelText: 'Teléfono'
              ),
            ),

          const SizedBox(height: 20),

          TextFormField(
              decoration: const InputDecoration(
                labelText: 'Fecha de nacimiento'
              ),
            ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, 'confirm'), 
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15), 
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Expanded(child: Center(child: Text('Siguiente'))),
                    Icon(Icons.arrow_forward)
                  ]
                )
              ),
            ),
          )
        ],
      ),
    );
  }
}