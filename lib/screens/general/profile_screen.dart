
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

    final User user = Provider.of<AuthProvider>(context).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de usuario'),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=> const EditProfileScreen()));
            }, 
            icon: const Icon(Icons.edit), 
            iconSize: 22,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(AppTheme.horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              _InformationItem(
                title: '${user.cedula}', 
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
                title: user.correo, 
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


              _ActionText(
                title: 'Mis citas médicas pendientes',
                onNavigate: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const PendingAppoimentsScreen()));
                },
              ),

              const SizedBox(height: 15),

              _ActionText(
                title: 'Invitados', 
                onNavigate: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const GuestsScreen()));
                }
              ),


              const SizedBox(height: 15),

              TextButton(
                onPressed: (){
                  showDialog(context: context, builder: (_) =>  _ConfirmLogout());
                }, 
                child: const Text(
                  'Cerrar sesión', 
                  style: TextStyle(color: Color(AppTheme.secondaryColor), fontSize: 14)
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionText extends StatelessWidget {
  const _ActionText({
    required this.title,
    required this.onNavigate
  });

  final String title;
  final VoidCallback onNavigate;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
      onTap: onNavigate,
      title: Text(
        title, 
        style: const TextStyle(fontSize: 14, color: Color(AppTheme.primaryColor)),
      ),
      trailing: const Icon(Icons.keyboard_arrow_right_outlined),
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
          leading: Icon(icon, size: 20),
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              fontWeight: FontWeight.normal,
            ),
          ),
          subtitle: Text(
            subtTitle,
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: Colors.black45
            ),
          ),
        ),
        const Divider()
      ],
    );
  }
}

class _ConfirmLogout extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    final appoimentProvider = Provider.of<AppoimentProvider>(context, listen: false);

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
            appoimentProvider.closeSession();
            navigator.pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const SessionScreen()), 
              (route) => false
            );
          }, 
          child: const Text('Aceptar', style: TextStyle(fontSize: 16))
        )
      ],
    );
  }


}