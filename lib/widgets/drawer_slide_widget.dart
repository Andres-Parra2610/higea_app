import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:higea_app/screens/general/pdf_view_screen.dart';
import 'package:higea_app/screens/screens.dart';

class DrawerSlideWidget extends StatelessWidget {
const DrawerSlideWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    
    return Drawer(

      child: SingleChildScrollView(
        child: Column(
          children:   [
            
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: SvgPicture.asset(
                'assets/logo-higea.svg',
                semanticsLabel: 'Logo de la fundación Higea',
                width: 90,
              ),
            ),

            ListTile(
              title: const Text('Inicio'),
              leading: const Icon(Icons.home),
              onTap: () => Navigator.pushReplacement(
                context, 
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const HomeScreenAdmin(screen: AppoimentListAdminScreen()),
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
                  pageBuilder: (_, __, ___) => const HomeScreenAdmin(screen: SpecialitiesListAdminScreen()),
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
                  pageBuilder: (_, __, ___) => const HomeScreenAdmin(screen: DoctorListAdminScreen()),
                  transitionDuration: const Duration(seconds: 0)
                )
              ),
            ),

            ListTile(
              title: const Text('Pacientes'),
              leading: const Icon(Icons.supervised_user_circle_rounded),
              onTap: () => Navigator.pushReplacement(
                context, 
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const HomeScreenAdmin(screen: PatientListAdminScreen()),
                  transitionDuration: const Duration(seconds: 0)
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}