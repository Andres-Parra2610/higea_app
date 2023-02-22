import 'package:flutter/material.dart';
import 'package:higea_app/styles/app_theme.dart';

class HistoryScreen extends StatelessWidget {
const HistoryScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Historial de citas médicas', style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),),
        elevation: 0.5,
      ),
      body: ListView.builder(
        itemCount: 50,
        itemBuilder: (context, index){
          Color bgColor;

          index % 2 == 0
            ? bgColor = const Color(AppTheme.primaryColor).withOpacity(0.1)
            : bgColor = const Color(AppTheme.secondaryColor).withOpacity(0.1);
          

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: bgColor
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('21/02/2023'),
                          Text('8:00 AM'),
                        ],
                      ),
                    ),
          
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const[
                        Text('Pediatra', style: TextStyle(fontSize: 16, color: Color(AppTheme.primaryColor), fontWeight: FontWeight.bold)),
                        Text('Dr. Andrés Parra'),
                        SizedBox(height: 10),
                        Text('Paciente: Laura Palacios'),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}