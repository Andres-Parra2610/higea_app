import 'package:flutter/material.dart';
import 'package:higea_app/screens/screens.dart';
import 'package:higea_app/styles/app_theme.dart';

class FloatinMenuButtonWidget extends StatelessWidget {
const FloatinMenuButtonWidget({ Key? key, required this.items }) : super(key: key);

  final List<PopupMenuItem<dynamic>> items;

  @override
  Widget build(BuildContext context){
    return PopupMenuButton(
      onSelected: (value) {
        if(value == 0){
          Navigator.push(context, MaterialPageRoute(builder: (_) => PdfViewScreen(url: 'paciente-frecuente')));
        }
      },
      tooltip: 'Generar reportes',
      itemBuilder: (context) {
        return items;
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.all(10),
        decoration:  BoxDecoration(
          color: const Color(AppTheme.primaryColor),
          borderRadius: BorderRadius.circular(50)
        ),
        child: Row(
          children: const [
            Icon(Icons.receipt_long_outlined, color: Colors.white,),
            SizedBox(width: 8,),
            Text('Generar reportes', style: TextStyle(color: Colors.white),)
          ],
        )
      ),
    );
  }
}