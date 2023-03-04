
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:higea_app/providers/auth_provider.dart';
import 'package:higea_app/screens/screens.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:higea_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ConfirmEmailScreen extends StatefulWidget {
const ConfirmEmailScreen({ Key? key }) : super(key: key);

  @override
  State<ConfirmEmailScreen> createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {

  final _textKey = GlobalKey<FormFieldState<String>>();
  String codeValidation = '';

  @override
  Widget build(BuildContext context){

    final media = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    final registerProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: media.width * 0.85,
                child: Text(
                  'Ingesa el código enviado a ${registerProvider.formRegisterValues["email"]}', 
                  overflow: TextOverflow.ellipsis, 
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: textTheme.subtitle2!.fontSize),
                )
              ),

              const SizedBox(height: 20),

              TextFormField(
                key: _textKey,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(5)
                ],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                onChanged: (value) => codeValidation = value,
                validator: (value){
                  if(value!.trim().isEmpty || value.length < 5) return 'Debes colocar un código';

                  return null;
                },
                //44739
              ),


              const SizedBox(height: 20),

              SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async{
                  if(!_textKey.currentState!.validate()) return;
                  final navigator = Navigator.of(context);
                  
                  final res = await registerProvider.confirmEmail(codeValidation);
                  
                  if(!res){
                    SnackBarWidget.showSnackBar('Código de verificación inválido');
                  }else{
                    navigator.pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const PageTabScreen()), 
                      (route) => false
                    );
                  }
                }, 
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