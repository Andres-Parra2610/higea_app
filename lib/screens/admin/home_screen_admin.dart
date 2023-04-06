import 'package:flutter/material.dart';
import 'package:higea_app/screens/screens.dart';
import 'package:higea_app/services/services.dart';
import 'package:higea_app/widgets/widgets.dart';

class HomeScreenAdmin extends StatelessWidget {

  const HomeScreenAdmin({ 
    super.key,
    this.screen
  });

  final Widget? screen;

  @override
  Widget build(BuildContext context){

    if(PlatformDevice.isMobile){
      return const Scaffold(
        body: Center(child: Text('Para acceder al administrador debe hacerlo desde la web'),),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido administrador'),
      ),

      body: SafeArea(
        child: Row(
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