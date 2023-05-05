import 'package:flutter/material.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:higea_app/services/services.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GuestFormScreen extends StatefulWidget {

  const GuestFormScreen({ 
    Key? key, 
    this.isEditable = false 
  }) : super(key: key);

  final bool isEditable;

  @override
  State<GuestFormScreen> createState() => _GuestFormScreenState();
}

class _GuestFormScreenState extends State<GuestFormScreen> {
  int option = 1;

  void onChanged(value){
    option = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context){

    final guestProvider = Provider.of<GuestProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: !widget.isEditable ? const Text('Agregar invitado') : const Text('Editar invitado'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(AppTheme.horizontalPadding),
            child: Form(
              key: guestProvider.guestForm,
              child: Column(
                children: [
                  
                  Visibility(
                    visible: !widget.isEditable,
                    child: _SelectGuestType(option, onChanged),
                  ),
                  
                  const SizedBox(height: 20),
      
                  _TextFormCi(option: option, isEditable: widget.isEditable),
      
                  const SizedBox(height: 20),
      
      
                  const _BodyForm(),
      
                  const SizedBox(height: 20),
      
                  _ButtonSubmit(widget.isEditable)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ButtonSubmit extends StatelessWidget {
  const _ButtonSubmit(this.isEditable);

  final bool isEditable;

  @override
  Widget build(BuildContext context) {

    final guestProvider = Provider.of<GuestProvider>(context);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async{
          if(!guestProvider.guestForm.currentState!.validate()) return;
          final navigator = Navigator.of(context);
          Response res;

          if(isEditable){
            res = await guestProvider.editGuest();
          }else{
            res = await guestProvider.registerGuest();
          }
          
           if(res.ok) return navigator.pop();

          SnackBarWidget.showSnackBar(res.msg); 
        },
        child: const Text('Guardar'),
      )
    );
  }
}

class _TextFormCi extends StatelessWidget {
  const _TextFormCi({
    required this.option,
    required this.isEditable
  });

  final int option;
  final bool isEditable;

  @override
  Widget build(BuildContext context) {

    final guestProvider = Provider.of<GuestProvider>(context);
    final User user = User.fromRawJson(UserPreferences.user);

    guestProvider.guestData.paciente = user.cedula;

    if(option != 1){
      guestProvider.guestData.cedula = guestProvider.guestWithoutCi;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12.5, horizontal: 15),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.black38),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: isEditable 
          ? Text(guestProvider.guestData.cedula!)
          : Text('${user.cedula} - 0${guestProvider.lastDigits}'),
      );
    }

    return TextFormField(
      readOnly: isEditable,
      initialValue: guestProvider.guestData.cedula,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(labelText: 'Cédula'),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly ],
      onChanged: (value) => guestProvider.guestData.cedula = value,
      validator: (value) {
        if(value!.length < 7) return 'Debe ser una cédula válida';
        return null;
      },
    );
  }
}

class _BodyForm extends StatelessWidget {
  const _BodyForm();


  @override
  Widget build(BuildContext context) {

    final guestProvider = Provider.of<GuestProvider>(context, listen: false);

    return Column(
      children: [
        TextFormField(
          initialValue: guestProvider.guestData.nombreInvitado,
          decoration: const InputDecoration(labelText: 'Nombre(s)'),
          inputFormatters: [ FilteringTextInputFormatter.deny(RegExp(r'[0-9]')) ],
          onChanged: (value)=> guestProvider.guestData.nombreInvitado = value,
          validator: (value) {
            if(value!.trim().isEmpty) return 'Debe colocar un nombre';
            return null;
          },
        ),

        const SizedBox(height: 20),

        TextFormField(
          initialValue: guestProvider.guestData.apellidoInvitado,
          decoration: const InputDecoration(labelText: 'Apellido(s)'),
          inputFormatters: [ FilteringTextInputFormatter.deny(RegExp(r'[0-9]')) ],
          onChanged: (value) => guestProvider.guestData.apellidoInvitado = value,
          validator: (value) {
            if(value!.trim().isEmpty) return 'Debe colocar un apellido';
            return null;
          },
        ),

        const SizedBox(height: 20),

        TextFormDatePickerWidget(
          initValue: guestProvider.guestData.fechaNacimiento,
          validate: (value){
            if(value!.trim().isEmpty) return 'Por favor seleccione una fecha';

            String formatToBd = DateFormat("yyyy-MM-dd").format(DateFormat("dd/MM/yyyy").parse(value));
            guestProvider.guestData.fechaNacimiento = formatToBd;
            return null;
          },
        )
      ],
    );
  }
}

class _SelectGuestType extends StatelessWidget {
  const _SelectGuestType(this.value, this.onChanged);

  final int value;
  final Function onChanged;
  

  @override
  Widget build(BuildContext context) {

    final User user = User.fromRawJson(UserPreferences.user);

    return DropdownButtonFormField(
      value: value,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Por favor seleccione el tipo de invitado',
        helperText: 'Nota: Los pacientes sin cédula son aquellos niños que no poseen cédula de identidad. Si su invitado es mayor edad le recomendamos que cree su propia cuenta',
        helperMaxLines: 5
      ),
      items: const [
        DropdownMenuItem(value: 1,child: Text('Paciente CON cédula')),
        DropdownMenuItem(value: 2,child: Text('Paciente SIN cédula')),
      ], 
      onChanged: (value){
        Provider.of<GuestProvider>(context, listen: false).lastCiGuest(user.cedula.toString());
        onChanged(value);
      }
    );
  }
}