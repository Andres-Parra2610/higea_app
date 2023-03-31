import 'package:flutter/material.dart';
import 'package:higea_app/screens/screens.dart';

class DrawerSlideWidget extends StatelessWidget {
const DrawerSlideWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Drawer(

      child: SingleChildScrollView(
        child: Column(
          children:   [

            ListTile(
              title: const Text('Inicio'),
              leading: const Icon(Icons.home),
              onTap: () => Navigator.pushReplacement(
                context, 
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const HomeScreenAdmin(screen: AppoimentListAdmin()),
                  transitionDuration: const Duration(seconds: 0)
                )
              ),
            ),

            ListTile(
              title: const Text('Especialidades'),
              leading: const Icon(Icons.add_chart_sharp),
              onTap: () => Navigator.pushReplacement(
                context, 
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const HomeScreenAdmin(screen: SpecialitiesScreenAdmin()),
                  transitionDuration: const Duration(seconds: 0)
                )
              ),
            ),

            ListTile(
              title: const Text('Médicos'),
              leading: const Icon(Icons.medical_information),
              onTap: () => Navigator.pushReplacement(
                context, 
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const HomeScreenAdmin(screen: DoctorScreenAdmin()),
                  transitionDuration: const Duration(seconds: 0)
                )
              ),
            ),

            ListTile(
              title: const Text('Pacientes'),
              leading: const Icon(Icons.supervised_user_circle_rounded),
              //onTap: (){},
            ),

             ListTile(
              title: const Text('Reportes'),
              leading: const Icon(Icons.supervised_user_circle_rounded),
              //onTap: (){},
            )

          ],
        ),
      ),
    );
  }
}