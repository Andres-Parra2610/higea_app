import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:higea_app/helpers/helpers.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/providers/doctor_provider.dart';
import 'package:higea_app/styles/app_theme.dart';

class AlertDoctorWidget extends StatelessWidget {
  const AlertDoctorWidget({ Key? key, required this.doctor, required this.title, this.isEdit}) : super(key: key);

  final Doctor doctor;
  final String title;
  final bool? isEdit;

  @override
  Widget build(BuildContext context){

    final doctorProvider = Provider.of<DoctorProvider>(context);
    final formKey = doctorProvider.formDoctorKey;
    
    return AlertDialog(
      actions: [
        TextButton(
          onPressed: doctorProvider.isLoading ? null : () async{
            if(!formKey.currentState!.validate() || doctorProvider.doctor.fechas!.isEmpty) return;
    
            final navigator = Navigator.of(context);
            dynamic res;
    
            if(isEdit == null){
              res = await doctorProvider.registerDoctor();
            }else{
              res = await doctorProvider.editDoctor();
            }
    
            res ? navigator.pop(true) : navigator.pop(false);
          }, 
          child: Text(title)
        )
      ],
      title: Text(title),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 700, 
          child: AbsorbPointer(absorbing: doctorProvider.isLoading, child: _DoctorForm(doctor, isEdit ?? false))
        )
      ),
    );
  }
}

class _DoctorForm extends StatelessWidget {
  const _DoctorForm(this.doctor, this.isEdit);

  final Doctor doctor;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {

    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    final Doctor doctorForm = doctorProvider.doctor = doctor;

    const double widthSeparator = 20; 
    const double heigthSeparator = 30;

    return Form(
      key: doctorProvider.formDoctorKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Datos personales'),
    
          const SizedBox(height: heigthSeparator - 10),
    
          _FirstRow(widthSeparator, doctorForm, isEdit),
    
          const SizedBox(height: heigthSeparator),
    
          _SecondRow(widthSeparator, doctorForm),
    
          const SizedBox(height: heigthSeparator),
    
          _ThirdRow(widthSeparator, doctorForm),
    
          const SizedBox(height: heigthSeparator),
    
          _FourthRow(widthSeparator, doctorForm, isEdit),
          
          Visibility(
            visible: !isEdit,
            child: Column(
              children: [
                const SizedBox(height: heigthSeparator),

                const Text('Horario de trabajo'),
          
                const SizedBox(height: heigthSeparator - 10),
          
                _ListDoctorDayWorks(doctorForm),
          
                const SizedBox(height: heigthSeparator - 10),
          
                _HourWorks(widthSeparator, doctorForm)
              ],
            )
          )
    
    
        ],
      ),
    );
  }
}

class _HourWorks extends StatelessWidget {
  _HourWorks(this.widthSeparator, this.doctorForm);

  final double widthSeparator; 
  final Doctor doctorForm;

  final TextEditingController _startHourController = TextEditingController();
  final TextEditingController _endHourController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    if(doctorForm.horaFin!.isNotEmpty){
      final String formatedStartHour = Helpers.transHour(doctorForm.horaInicio!);
      final String formatedEndHour = Helpers.transHour(doctorForm.horaFin!);
      
      _startHourController.text = formatedStartHour;
      _endHourController.text = formatedEndHour;
    }


    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _startHourController,
            readOnly: true,
            decoration: const InputDecoration(labelText: 'Hora inicio'),
            onTap: () async{
              final TimeOfDay? time = await showTimePicker(
                initialEntryMode: TimePickerEntryMode.inputOnly,
                context: context, 
                initialTime: const TimeOfDay(hour: 7, minute: 00)
              );

              if(time == null) return;

              final String timeFormat = Helpers.formattedHourFromTime(time);
              final String hourToBd = DateFormat('HH:mm:ss').format(DateFormat('h:mm a').parse(timeFormat));
              _startHourController.text = timeFormat;
              doctorForm.horaInicio = hourToBd;
            },
            validator: (value){
              if(value!.trim().isEmpty && doctorForm.horaInicio!.isEmpty) return 'Por favor seleccione una hora';
              return null; 
            },
          ),
        ),

        SizedBox(width: widthSeparator),

        Expanded(
          child: TextFormField(
            controller: _endHourController,
            readOnly: true,
            decoration: const InputDecoration(labelText: 'Hora fin'),
            onTap: () async{
              final TimeOfDay? time = await showTimePicker(
                initialEntryMode: TimePickerEntryMode.inputOnly,
                context: context, 
                initialTime: const TimeOfDay(hour: 7, minute: 00)
              );

              if(time == null) return;

              final String timeFormat = Helpers.formattedHourFromTime(time);
              final String hourToBd = DateFormat('HH:mm:ss').format(DateFormat('h:mm a').parse(timeFormat));
              _endHourController.text = timeFormat;
              doctorForm.horaFin = hourToBd;
            },
            validator: (value){
              if(value!.trim().isEmpty && doctorForm.horaFin!.isEmpty) return 'Por favor seleccione una hora';
              final startHour = DateFormat.jm().parse(_startHourController.text);
              final endHour = DateFormat.jm().parse(value);
              if(endHour.isBefore(startHour)) return 'El horario de fin no puede estar antes que el horario de inicio';
              return null; 
            },
          ),
        )
      ],
    );
  }
}

class _ListDoctorDayWorks extends StatefulWidget {
  const _ListDoctorDayWorks(this.doctorForm);

  final Doctor doctorForm;

  @override
  State<_ListDoctorDayWorks> createState() => _ListDoctorDayWorksState();
}

class _ListDoctorDayWorksState extends State<_ListDoctorDayWorks> {

  final List<String> days = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'];


  @override
  Widget build(BuildContext context) {

    final List<String> selectedDays = Provider.of<DoctorProvider>(context, listen: false).selectedDays = widget.doctorForm.fechas!;

    return Wrap(
      children: [
        ...days.map((String day){
          return Container(
            margin: const EdgeInsets.only(right: 20, left: 0, bottom: 10),
            child: InputChip(
              checkmarkColor: Colors.white,
              selectedColor: const Color(AppTheme.primaryColor),
              selected: selectedDays.contains(day),
              onSelected: (value){

                if(selectedDays.contains(day)){
                  widget.doctorForm.fechas!.remove(day);
                }else{
                  widget.doctorForm.fechas!.add(day);
                }

                setState(() {});
              },
              label: Text(day, style: TextStyle(color: selectedDays.contains(day) ? Colors.white : Colors.black),)
            ),
          );
        }).toList()
      ],
    );
  }
}


class _FirstRow extends StatelessWidget {
  const _FirstRow(this.widthSeparator, this.doctorForm, this.isEdit);

  final double widthSeparator; 
  final Doctor doctorForm;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Expanded(
          child: TextFormField(
            readOnly: isEdit,
            initialValue: doctorForm.cedula == 0 ? '' : doctorForm.cedula.toString(),
            decoration: const InputDecoration(labelText: 'Cédula'),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly ],
            onChanged: (value) => doctorForm.cedula = int.parse(value),
            validator: (value) {
              if(value!.length < 7 || value.length > 8) return 'Debe ser una cédula válida';
              return null;
            },
          ),
        ),
        SizedBox(width: widthSeparator),
        Expanded(
          child: TextFormField( 
            initialValue: doctorForm.nombreMedico,
            decoration: const InputDecoration(labelText: 'Nombre(s)'),
            inputFormatters: [ FilteringTextInputFormatter.deny(RegExp(r'[0-9]')) ],
            onChanged: (value) => doctorForm.nombreMedico = value,
            validator: (value) {
              if(value!.trim().isEmpty) return 'Debe colocar un nombre';
              return null;
            },
          ),
        )         
      ],
    );
  }
}


class _SecondRow extends StatelessWidget {
  const _SecondRow(this.widthSeparator, this.doctorForm);

  final double widthSeparator; 
  final Doctor doctorForm;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: doctorForm.apellidoMedico,
            decoration: const InputDecoration(labelText: 'Apellido(s)'),
            inputFormatters: [ FilteringTextInputFormatter.deny(RegExp(r'[0-9]')) ],
            onChanged: (value) => doctorForm.apellidoMedico = value,
            validator: (value) {
              if(value!.trim().isEmpty) return 'Debe colocar un apellido';
              return null;
            },
          ),
        ),
        SizedBox(width: widthSeparator),
        Expanded(
          child: TextFormField(
            initialValue: doctorForm.telefonoMedico,
            decoration: const InputDecoration(labelText: 'Teléfono', prefixText: '0-'),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
            onChanged: (value) => doctorForm.telefonoMedico = value,
            validator: (value){
              if(value!.trim().isEmpty) return 'Ingrese un teléfono';
              if(value.trim().startsWith('0')) return 'El número no debe empezar con 0';
              return null;
            },
          ),
        )      
      ],
    );
  }
}

class _ThirdRow extends StatelessWidget {
  const _ThirdRow(this.widthSeparator, this.doctorForm);

  final double widthSeparator;
  final Doctor doctorForm;

  @override
  Widget build(BuildContext context) {


    if(doctorForm.sexoMedico!.isEmpty){
      doctorForm.sexoMedico = 'M';
    }

    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: doctorForm.correo,
            decoration: const InputDecoration(labelText: 'Correo electrónico'),
            onChanged: (value) => doctorForm.correo = value,
            validator: (value){
              if(value!.trim().isEmpty) return 'Debe colocar un email';
              if(!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Debe ser un email válido';
              return null;
            },
          )
        ),
        SizedBox(width: widthSeparator),
        Expanded(
          child: DropdownButtonFormField(
            value: doctorForm.sexoMedico,
            onChanged: (value) => doctorForm.sexoMedico = value!,
            items: const [
              DropdownMenuItem(value: 'M',child: Text('Masculino')),
              DropdownMenuItem(value: 'F',child: Text('Femenino'))
            ],
          )
        )
      ],
    );
  }
}


class _FourthRow extends StatefulWidget {
  const _FourthRow(this.widthSeparator, this.doctorForm, this.isEdit,);

  final double widthSeparator;
  final Doctor doctorForm;
  final bool isEdit;

  @override
  State<_FourthRow> createState() => _FourthRowState();
}

class _FourthRowState extends State<_FourthRow> {

  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    Provider.of<DoctorProvider>(context, listen: false).getSpecialitiesToDropDown();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final doctorProvider = Provider.of<DoctorProvider>(context);
    final List<Speciality> specialities = doctorProvider.specialities;


    if(doctorProvider.doctor.nombreEspecialidad!.isEmpty && specialities.isNotEmpty){
      doctorProvider.doctor.nombreEspecialidad = specialities[0].idespecialidad.toString();
    }

    if(doctorProvider.doctor.fechaNacimiento!.year != 0){
      _controller.text = DateFormat('dd/MM/yyyy').format(doctorProvider.doctor.fechaNacimiento!);
      widget.doctorForm.fechaNacimiento = DateTime.parse(DateFormat('yyyy-MM-dd').format(widget.doctorForm.fechaNacimiento!));
    }

    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Fecha de nacimiento'),
            readOnly: true,
            onTap: () async{
              DateTime? birthDate = await showDatePicker(
                context: context, 
                initialDate: DateTime.now(), 
                firstDate: DateTime(1900), 
                lastDate: DateTime(2150)
              );
        
              if(birthDate == null) return;
              
              String dateFormat = DateFormat('dd/MM/yyyy').format(birthDate);
              final dateToBd = DateFormat('yyyy-MM-dd').format(birthDate);
              _controller.text = dateFormat;
              widget.doctorForm.fechaNacimiento = DateTime.parse(dateToBd);
            },
            validator: (value){
              if(value!.trim().isEmpty) return 'Por favor seleccione una fecha';
              return null; 
            },
          ),
        ),

        SizedBox(width: widget.widthSeparator),

        Expanded(
          child: specialities.isEmpty || doctorProvider.isLoading
            ? const Center(child: CircularProgressIndicator(),)
            : DropdownButtonFormField(
            value: doctorProvider.doctor.nombreEspecialidad!.contains('1')
               ? specialities[0].idespecialidad
               : specialities.firstWhere((spe) => spe.nombreEspecialidad == doctorProvider.doctor.nombreEspecialidad).idespecialidad,

            decoration: const InputDecoration(labelText: 'Eliga la especialidad'),
            onChanged: widget.isEdit ? null : (value) => doctorProvider.doctor.nombreEspecialidad = value.toString(),
            items: [
              ...specialities.map((Speciality speciality){ 
                return DropdownMenuItem(
                  value: speciality.idespecialidad, 
                  child: Text(speciality.nombreEspecialidad, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15),)
                );
              }).toList()
              
            ],
          )
        )
      ],
    );
  }
}
