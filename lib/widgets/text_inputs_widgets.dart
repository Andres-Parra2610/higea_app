import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class HigeaTextField extends StatelessWidget {

  const HigeaTextField({ 
    Key? key,
    required this.formValues,
    required this.labelText,
    required this.mapKey,
    required this.validate,
    this.keyboardType,
    this.formatter,
    this.prefixText
  }) : super(key: key);

  final Map<String, dynamic> formValues;
  final String labelText;
  final String mapKey;
  final Function validate;
  final TextInputType? keyboardType;
  final String? prefixText;
  final List<TextInputFormatter>? formatter;


  @override
  Widget build(BuildContext context){
    return TextFormField(
      keyboardType: keyboardType ?? TextInputType.text,
      decoration: InputDecoration(
        labelText: labelText,
        prefixText: prefixText
      ),
      inputFormatters: formatter,
      onChanged: (value) => formValues[mapKey] = value,
      validator: (value) => validate(value),
    );
  }
}

class HigeaTextFieldPassword extends StatefulWidget {
  const HigeaTextFieldPassword({
    Key? key, 
    required this.validate,
    this.onchanged,
  }) : super(key: key);

 
  
  final Function validate;
  final Function? onchanged;

  @override
  State<HigeaTextFieldPassword> createState() => _HigeaTextFieldPasswordState();
}

class _HigeaTextFieldPasswordState extends State<HigeaTextFieldPassword> {

  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: !showPassword,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        suffixIcon: IconButton(
          onPressed: () => setState(() => showPassword = !showPassword),
          icon: showPassword
            ? const Icon(Icons.visibility_off_outlined)
            : const Icon(Icons.visibility)
        )
      ),
      onChanged: widget.onchanged == null ? null : (value) => widget.onchanged!(value),
      validator: (value) => widget.validate(value),
    );
  }
}
