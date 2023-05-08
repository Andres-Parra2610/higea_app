import 'package:flutter/material.dart';
import 'package:higea_app/screens/screens.dart';
import 'package:higea_app/widgets/widgets.dart';

class ReportsAdminScreen extends StatelessWidget {
const ReportsAdminScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
    
        const Align(
          alignment: Alignment.topLeft,
          child:  Text('Generar reportes', style: TextStyle(fontSize: 18),
          )
        ),
    
        Wrap(
          alignment: WrapAlignment.spaceBetween,
    
          spacing: 0,
          children: [
            const ReportButton(
              title: 'Citas',
              icon: Icons.person,
              url: 'paciente-frecuente',
              child: Text('Cliente más frecuente de la fundación'),
            ),
    
            ReportButton(
              tap: false,
              title: 'Citas por mes',
              icon: Icons.person,
              child: DropdownSelectButton(
                onSelected: (value){
                  Navigator.push(context, MaterialPageRoute(builder: (_) => PdfViewScreen(url: 'cita/$value')));
                }
              ),
            ),
    
            const ReportButton(
              title: 'Médicos',
              url: 'doctors',
              icon: Icons.health_and_safety,
              child: Text('Todos los médicos de la fundación'),
            ),
    
            const ReportButton(
              title: 'Médicos',
              url: 'doctor-more-visited',
              icon: Icons.health_and_safety,
              child: Text('Médicos con más pacientes atendidos'),
            ),
    
            ReportButton(
              tap: false,
              title: 'Consultas de médico por mes',
              icon: Icons.health_and_safety,
              child: DropdownSelectButton(
                onSelected: (value){
                  final Map<String, dynamic> params = {'month': '$value'};
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (_) => PdfViewScreen(url: 'doctor-more-visited', params: params,))
                  );
                }
              ),
            ),
    
            const ReportButton(
              title: 'Especialidades',
              url: 'specialities',
              icon: Icons.view_list_rounded,
              child: Text('Todas las especialidades'),
            ),
          ],
        ),
      ],
    );
  }
}