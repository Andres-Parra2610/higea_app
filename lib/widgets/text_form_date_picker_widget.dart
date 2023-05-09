import 'package:flutter/material.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class TextFormDatePickerWidget extends StatelessWidget {
  TextFormDatePickerWidget({ Key? key, this.validate, this.initValue = ''}) : super(key: key);

  final Function? validate;
  final String? initValue;
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context){

    _dateController.text = initValue ?? '';

    return TextFormField(
      style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.normal),
      controller: _dateController,
      decoration: const InputDecoration(labelText: 'Fecha de nacimiento'),
      readOnly: true,
      onTap: () async{
        final DateTime? date = await showDialog(context: context, builder: (_) => _AlertDatePicker());

        if(date == null) return;

        String dateFormat = DateFormat('dd/MM/yyyy').format(date);
        _dateController.text = dateFormat;
      },
      validator: validate == null
        ? null
        : (value) => validate!(value)
    );
  }
}


class _AlertDatePicker extends StatefulWidget{

  @override
  State<_AlertDatePicker> createState() => _AlertDatePickerState();
}

class _AlertDatePickerState extends State<_AlertDatePicker> {

  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.all(0),
      title: const _TitleAlert(),
      actions: [
        TextButton(
          onPressed: ()=> Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: Color(AppTheme.secondaryColor), fontSize: 14)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _selectedDate),
          child: const Text('Aceptar', style: TextStyle(fontSize: 14),),
        ),
      ],

      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 250,
        child: ScrollDatePicker(
          minimumDate: DateTime(1920, 0 , 0),
          selectedDate: _selectedDate,
            locale: const Locale('es', ''),
            onDateTimeChanged: (value){
              _selectedDate = value;
              setState(() {});
            },
        ),
      ) ,
    );
  }
}

class _TitleAlert extends StatelessWidget {
  const _TitleAlert();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      height: 50,
      decoration: const BoxDecoration(
        color:  Color(AppTheme.primaryColor),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4))
      ),
      child: const Center(
        child: Text(
          'Seleccione una fecha',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
} 
