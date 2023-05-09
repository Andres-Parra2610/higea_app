import 'package:flutter/material.dart';
import 'package:higea_app/providers/guest_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:higea_app/providers/appoiment_provider.dart';
import 'package:higea_app/services/services.dart';
import 'package:higea_app/helpers/helpers.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:higea_app/models/models.dart';

class ConfirmAppoimentWidget extends StatefulWidget {
  const ConfirmAppoimentWidget({ 
    Key? key,
    required this.appoiment
  }) : super(key: key);

  final Appoiment appoiment;

  @override
  State<ConfirmAppoimentWidget> createState() => _ConfirmAppoimentWidgetState();
}

class _ConfirmAppoimentWidgetState extends State<ConfirmAppoimentWidget> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context){

    final appoimentProvider = Provider.of<AppoimentProvider>(context, listen: false);
    final User user = User.fromRawJson(UserPreferences.user);
    final Appoiment currentAppoiment = widget.appoiment;
    currentAppoiment.cedulaPaciente = user.cedula;
    final String appoimentToBd = currentAppoiment.fechaCita.toString().split(' ')[0];
  
    return AbsorbPointer(
      absorbing: isLoading,
      child: AlertDialog(
        scrollable: true,
        buttonPadding: const EdgeInsets.all(25),
        insetPadding: const EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Color(AppTheme.secondaryColor), fontSize: 14)),
          ),
          TextButton(
            onPressed: () async{
                  if(!appoimentProvider.confirmAppoimentForm.currentState!.validate()) return;
    
                  setState(() => isLoading = true);
                  final navigator = Navigator.of(context);
    
                  final Response res = await appoimentProvider.newApoiment(currentAppoiment);
    
                  setState(() => isLoading = false);
    
                  await appoimentProvider.showAppoiment(currentAppoiment.cedulaMedico, appoimentToBd, appoimentProvider.date);
    
                  navigator.pop(res);
    
                },
            child: const Text('Aceptar', style: TextStyle(fontSize: 14),),
          ),
        ],
        title: Text('Detalles de la cita médica', style: Theme.of(context).textTheme.titleLarge,),
        
        content: _ConfirmAppoimentBody(currentAppoiment, user, isLoading)
      ),
    );
  }
}

class _ConfirmAppoimentBody extends StatelessWidget {
  const _ConfirmAppoimentBody(this.currentAppoiment, this.user, this.isLoading);

  final Appoiment currentAppoiment;
  final User user;
  final bool isLoading; 

  @override
  Widget build(BuildContext context) {

    final String appoimentHour = Helpers.transHour(currentAppoiment.horaCita);
    final String appoimentDate = DateFormat('dd-MM-yyyy').format(currentAppoiment.fechaCita);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: _BodyForm(user, appoimentDate, appoimentHour,  isLoading),
    );
  }
}

class _BodyForm extends StatelessWidget {
  const _BodyForm(
     this.user,
     this.appoimentDate,
     this.appoimentHour,
     this.isLoading,
    );

  final User user;
  final String appoimentDate;
  final String appoimentHour;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {

    const textStyle = TextStyle(fontSize: 15);
    final appoimentProvider = Provider.of<AppoimentProvider>(context, listen: false);

    return Form(
      key: appoimentProvider.confirmAppoimentForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          _GuestBuilder(user: user),

          const SizedBox(height: 20),

          const Text('Email principal del usuario', style: textStyle,),
          TextFormField(
            style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.normal),
            initialValue: user.correo,
            readOnly: true,
          ),

          const SizedBox(height: 20),

          const Text('Fecha', style: textStyle,),
          TextFormField(
            style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.normal),
            initialValue: appoimentDate,
            readOnly: true,
          ),

          const SizedBox(height: 20),

          const Text('Hora', style: textStyle,),
          TextFormField(
            style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.normal),
            initialValue: appoimentHour,
            readOnly: true,
          ),

          const SizedBox(height: 30),

          isLoading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : Container()
        ],
      ),
    );
  }
}

class _GuestBuilder extends StatelessWidget {
  const _GuestBuilder({
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {

    final guestProvider = Provider.of<GuestProvider>(context, listen: false);

    return FutureBuilder(
      future: guestProvider.showGuestByPaTient(user.cedula),
      builder:(context, AsyncSnapshot<List<Guest>> snapshot){

        if(!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final List<Guest> guests = snapshot.data!;

        if(guests.isEmpty){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Paciente ', style: TextStyle(fontSize: 15)),
              TextFormField(
                initialValue: user.nombrePaciente,
                readOnly: true,
              )
            ],
          );
        }

        return  _DropDownGuest(guests);

      },
    );
  }
}


class _DropDownGuest extends StatelessWidget {
  const _DropDownGuest(this.guests);

  final List<Guest> guests;

  @override
  Widget build(BuildContext context) {

    final appoimentProvider = Provider.of<AppoimentProvider>(context, listen: false);
    final User user = User.fromRawJson(UserPreferences.user);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Por favor selecciona al paciente', style: TextStyle(fontSize: 15)),

        DropdownButtonFormField(
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.normal),
          items: [
            DropdownMenuItem(
              value: user.cedula.toString(),
              child: Text('${user.nombrePaciente} ${user.apellidoPaciente} (yo)'),
            ),
            ...guests.map((guest){
              return DropdownMenuItem(
                value: guest.cedula,
                child: Text('${guest.nombreInvitado} ${guest.apellidoInvitado}'),
              );
            }).toList()
          ],

          onChanged: (value){
           appoimentProvider.onChangeGuest(value);
          },

          validator: (value) {
            if(value == null || value.trim().isEmpty) return 'Por favor seleccione un paciente';
            return null;
          },
        ),
      ],
    );
  }
}

