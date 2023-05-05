import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:higea_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatelessWidget {
const EditProfileScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){

    final User user = Provider.of<AuthProvider>(context).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar usuario'),
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(AppTheme.horizontalPadding),
            child:  _FormEditUser(user),
          ),
        ),
      ),
    );
  }
}

class _FormEditUser extends StatelessWidget {
  const _FormEditUser(this.user);

  final User user;

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final tempUser = authProvider.tempUser = user;

    return Form(
      key: authProvider.formEditUserKey,
      child: Column(
        children: [

          /* TextFormField(
            initialValue: user.nombrePaciente,
            decoration: const InputDecoration(labelText: 'Nombre(s)'),
            onChanged: (value) => tempUser.nombrePaciente = value,
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[0-9]'))],
            validator: (value){
              if(value!.trim().isEmpty) return 'Debe colocar un nombre';
              return null;
            },
          ),


          const SizedBox(height: 20),


          TextFormField(
            initialValue: user.apellidoPaciente,
            decoration: const InputDecoration(labelText: 'Apellido(s)'),
            onChanged: (value) => tempUser.apellidoPaciente = value,
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[0-9]'))],
            validator: (value){
              if(value!.trim().isEmpty) return 'Debe colocar un apellido';
              return null;
            },
          ),

          const SizedBox(height: 20), */


          TextFormField(
            initialValue: user.correo,
            decoration: const InputDecoration(labelText: 'Correo electrónico'),
            onChanged: (value) => tempUser.correo = value,
            validator: (value){
              if(value!.trim().isEmpty) return 'Debe colocar un email';
              if(!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Debe ser un email válido';
              return null;
            },
          ),

          const SizedBox(height: 20),

          TextFormField(
            initialValue: user.telefonoPaciente,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Número de teléfono', prefixText: '0-'),
            onChanged: (value) => tempUser.telefonoPaciente = value,
            inputFormatters: [ LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.digitsOnly ],
            validator: (value){
              if(value!.trim().isEmpty) return 'Ingrese un teléfono';
              if(value.trim().startsWith('0')) return 'El número no debe empezar con 0';
              return null;
            },
          ),

          const SizedBox(height: 20),
          
          _ButtonSubmit(authProvider)
        ],
      ),
    );
  }
}

class _ButtonSubmit extends StatefulWidget {
  const _ButtonSubmit(this.authProvider);

  final AuthProvider authProvider;

  @override
  State<_ButtonSubmit> createState() => _ButtonSubmitState();
}

class _ButtonSubmitState extends State<_ButtonSubmit> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async{
          if(!widget.authProvider.formEditUserKey.currentState!.validate()) return;
          final navigator = Navigator.of(context);
          setState(() => isLoading = true);

          final Response res = await widget.authProvider.editUser();

          res.ok 
            ? navigator.pop()
            : SnackBarWidget.showSnackBar(res.msg, res.ok);

          setState(() => isLoading = true);

        }, 
        child: isLoading 
          ? const Center(child: CircularProgressIndicator())
          : const Text('Guardar')
      )
    );
  }
}