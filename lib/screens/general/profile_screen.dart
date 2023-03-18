
import 'package:flutter/material.dart';
import 'package:higea_app/models/user_model.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:higea_app/screens/screens.dart';
import 'package:higea_app/services/services.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
const ProfileScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){

    final User user = Provider.of<AuthProvider>(context, listen: false).currentUser;


    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de usuario'),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(AppTheme.horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              _InformationItem(
                title: '${user.cedulaPaciente}', 
                subtTitle: 'Cédula de identidad', 
                icon: Icons.contact_emergency_rounded, 
              ),

              _InformationItem(
                title: user.nombrePaciente, 
                subtTitle: 'Nombre(s)', 
                icon: Icons.person, 
              ),

              _InformationItem(
                title: user.apellidoPaciente, 
                subtTitle: 'Apellido(s)', 
                icon: Icons.person
              ),

               _InformationItem(
                title: user.correoPaciente, 
                subtTitle: 'Correo', 
                icon: Icons.email_rounded, 
              ),

               _InformationItem(
                title: '0${user.telefonoPaciente}', 
                subtTitle: 'Telefono', 
                icon: Icons.phone, 
              ),

               _InformationItem(
                title: DateFormat('dd/MM/yyyy').format(user.fechaNacimientoPaciente), 
                subtTitle: 'Fecha de nacimiento', 
                icon: Icons.date_range_rounded, 
              ),

              const SizedBox(height: 30),

              TextButton(
                onPressed: (){
                  showDialog(context: context, builder: (_) =>  _ConfirmLogout());
                }, 
                child: const Text(
                  'Cerrar sesión', 
                  style: TextStyle(color: Color(AppTheme.secondaryColor), fontSize: 15)
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _InformationItem extends StatelessWidget {
  const _InformationItem({
    required this.title, 
    required this.subtTitle, 
    required this.icon,
  });

  final String title;
  final String subtTitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(subtTitle),
        ),
        const Divider()
      ],
    );
  }
}

class _ConfirmLogout extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding),
      title: const Text('¿Cerrar sesión de tu cuenta?'),
      actions: [
        TextButton(
          onPressed: ()=> Navigator.pop(context), 
          child: const Text('Cancelar', style: TextStyle(color: Color(AppTheme.secondaryColor), fontSize: 16))
        ),

        TextButton(
          onPressed: () async{
            final navigator = Navigator.of(context);
            await UserPreferences.deleteUser();
            navigator.pushReplacement(
              MaterialPageRoute(builder: (_) => const SessionScreen()), 
            );
          }, 
          child: const Text('Aceptar', style: TextStyle(fontSize: 16))
        )
      ],
    );
  }


}