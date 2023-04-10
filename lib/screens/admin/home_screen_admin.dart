import 'package:flutter/material.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:higea_app/screens/screens.dart';
import 'package:higea_app/services/services.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:higea_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreenAdmin extends StatelessWidget {

  const HomeScreenAdmin({ 
    super.key,
    this.screen
  });

  final Widget? screen;

  @override
  Widget build(BuildContext context){

    final Admin admin = Provider.of<AuthProvider>(context, listen: false).currentAdmin;

    if(PlatformDevice.isMobile){
      return Scaffold(
        body: Center(
          child: Column(
            children: [
              const Text('Para acceder al administrador debe hacerlo desde la web'),
              ElevatedButton(
                onPressed: (){
                  UserPreferences.deleteUser();
                  Navigator.pushAndRemoveUntil(
                    context, 
                    MaterialPageRoute(builder: (_) => const SessionScreen()), 
                    (route) => false
                  );
                },  
                child: const Text('Cerrar')
              )
            ],
          )
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido ${admin.nombreAdmin}'),
        actions: [
          TextButton.icon(
            onPressed: (){
              UserPreferences.deleteUser();
              Navigator.pushAndRemoveUntil(
                context, 
                MaterialPageRoute(builder: (_) => const SessionScreen()), 
                (route) => false
              );
            }, 
            icon: const Icon(Icons.logout_sharp, color: Colors.white,), 
            label: const Text('Cerrar sesión', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
          )
        ],
      ),

      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(!PlatformDevice.isMobile) const Expanded(flex: 2, child: DrawerSlideWidget()),
            Expanded(
              flex: 8,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: screen ?? const AppoimentListAdminScreen(),
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}