
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:higea_app/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
const RegisterScreen({ Key? key }) : super(key: key);

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

    final registerProvider = Provider.of<AuthProvider>(context);

    print('Este es el register y me estoy renderizando');

    return Form(
      key: registerProvider.formRegisterKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Nombres'
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$'))
            ],
            onChanged: (value) => registerProvider.formRegisterValues['name'] = value,
            validator: (value){
              if(value!.trim().isEmpty) return 'Debe colocar un nombre';
              return null;
            },
          ),

          const SizedBox(height: 20),

          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Apellidos'
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$'))
            ],
            onChanged: (value) => registerProvider.formRegisterValues['lastName'] = value,
            validator: (value){
              if(value!.trim().isEmpty) return 'Debe colocar un apellido';
              return null;
            },
          ),

          const SizedBox(height: 20),

          TextFormField(
            toolbarOptions: const ToolbarOptions(
              paste: false,
              copy: true
            ),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Cédula'
            ),
            onChanged: (value) => registerProvider.formRegisterValues['ci'] = value,
            validator: (value){
              if(value!.length < 7 || value.length > 8) return 'Debe ser una cédula válida';
              return null;
            },
          ),

          const SizedBox(height: 20),

          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Correo'
            ),
            onChanged: (value) => registerProvider.formRegisterValues['email'] = value,
            validator: (value){
              if(value!.trim().isEmpty) return 'Debe colocar un email';
              if(!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Debe ser un email válido';
              return null;
            },
          ),

          const SizedBox(height: 20),

          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(10)
            ],
            decoration: const InputDecoration(
              labelText: 'Teléfono',
              prefixText: '0-',
            ),
            onChanged: (value) => registerProvider.formRegisterValues['phone'] = value,
            validator: (value) {
              if(value!.trim().isEmpty) return 'Ingrese un teléfono';
              if(value.trim().startsWith('0')) return 'El número no debe empezar con 0';
              return null;
            },
          ),

          const SizedBox(height: 20),

          const _TextFormDate(),

          const _SelectGenderRadio(),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async{
                if(registerProvider.formRegisterKey.currentState!.validate() == false) return;
                FocusScope.of(context).unfocus();

                final navigator = Navigator.of(context);

                final res = await registerProvider.registerUser();
                
                if(!res){
                  SnackBarWidget.showSnackBar('Usuario ya registrado');
                  return;
                }

                navigator.pushNamed('confirm');
              }, 
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15), 
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Center(
                      child: registerProvider.loadingRegister 
                        ? const CircularProgressIndicator.adaptive(
                          backgroundColor: Colors.white,
                        )
                        : const Text('Siguiente')
                    )),
                    const Icon(Icons.arrow_forward)
                  ]
                )
              ),
            ),
          ),

        ],
      ),
    );
  }
}

class _TextFormDate extends StatefulWidget {
  const _TextFormDate({
    Key? key,
  }) : super(key: key);

  @override
  State<_TextFormDate> createState() => _TextFormDateState();
}

class _TextFormDateState extends State<_TextFormDate> {

  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final registerFormValues = Provider.of<AuthProvider>(context, listen: false).formRegisterValues;

    return TextFormField(
      controller: _dateController,
      decoration: const InputDecoration(
        labelText: 'Fecha de nacimiento'
      ),
      readOnly: true,
      onTap: () async{
        DateTime? birthDate = await showDatePicker(
          context: context, 
          initialDate: DateTime.now(), 
          firstDate: DateTime(1900), 
          lastDate: DateTime(2150)
        );

        if(birthDate == null) return;
        
        String dateFormat = DateFormat('dd/MM/yyyy').format(birthDate);
        String dateFormatToBd = DateFormat('yyyy-MM-dd').format(birthDate);

        _dateController.text = dateFormat;
        registerFormValues['birthDate'] = dateFormatToBd;
      },
      validator: (value){
        if(value!.trim().isEmpty) return 'Por favor seleccione una fecha';

        final DateTime date = DateFormat('dd/MM/yyyy').parse(value);
        final DateTime now = DateTime.now();
        final age = now.year - date.year - ((now.month > date.month || (now.month == date.month && now.day >= date.day)) ? 0 : 1); 

        if(age < 18) return 'Debe ser mayor de edad para usar la aplicación';

        return null; 
      },
    );
  }
}



class _SelectGenderRadio extends StatefulWidget {
  const _SelectGenderRadio({
    Key? key,
  }) : super(key: key);

  @override
  State<_SelectGenderRadio> createState() => _SelectGenderRadioState();
}

class _SelectGenderRadioState extends State<_SelectGenderRadio> {

  String selectedGender = '';

  @override
  Widget build(BuildContext context) {

    final registerFormValues = Provider.of<AuthProvider>(context, listen: false).formRegisterValues;
  
    return Column(
      children: [

        RadioListTile(
          title: const Text('Masculino'),
          value: 'M', 
          groupValue: selectedGender, 
          onChanged: (value){
            setState(()=> selectedGender = value!);
            registerFormValues['gender'] = value;
          } 
        ),

        RadioListTile(
          title: const Text('Femenino'),
          value: 'F', 
          groupValue: selectedGender, 
          onChanged: (value){
            setState(()=> selectedGender = value!);
            registerFormValues['gender'] = value;
          } 
        ),
      ],
    );
  }
}