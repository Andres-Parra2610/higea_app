import 'package:flutter/material.dart';

class AppoimentsDetails extends StatelessWidget {
const AppoimentsDetails({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cita particular'),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container()
          ],
        ),
      ),
    );
  }
}