
import 'package:flutter/material.dart';
import 'package:higea_app/styles/app_theme.dart';

class ConfirmEmailScreen extends StatelessWidget {
const ConfirmEmailScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){

    final media = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.formPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: media.width * 0.85,
                child: Text(
                  'Ingesa el código enviado a andresparra261000@gmail.com', 
                  overflow: TextOverflow.ellipsis, 
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: textTheme.subtitle2!.fontSize),
                )
              ),

              const SizedBox(height: 20),

              const TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
              ),


              const SizedBox(height: 20),

              SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (){}, 
                child: const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Text('Confirmar'),),
              ),
            )
            ],
          ) 
        ),
      ),
    );
  }
}