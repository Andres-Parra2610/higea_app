import 'package:flutter/material.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:higea_app/screens/screens.dart';
import 'package:higea_app/services/services.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';


class HomeDoctorScreen extends StatelessWidget {
const HomeDoctorScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){

    final calendarProvider = Provider.of<CalendarProvider>(context, listen: false);
    final currentDoctor = Provider.of<AuthProvider>(context, listen: false).currentDoctor;

    return Scaffold(
      appBar: AppBar(
        title: Text(currentDoctor.nombreMedico),
        titleTextStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Color(AppTheme.primaryColor)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          TextButton(
            onPressed: (){
              UserPreferences.deleteUser();
              calendarProvider.events = {};
              Navigator.pushAndRemoveUntil(
                context, 
                MaterialPageRoute(builder: (_) => const SessionScreen()), 
                (route) => false
              );
            }, 
            child: const Text('Cerrar sesión', style: TextStyle(color: Color(AppTheme.secondaryColor)),)
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: FutureBuilder(
          future: calendarProvider.getEventsFromBd(currentDoctor.cedula),
          builder: (context, AsyncSnapshot<Map<String, List<Appoiment>>> snapshot) {
            
            if(!snapshot.hasData){
              return const Center(child: CircularProgressIndicator(),);
            }

            return const _CalendarEventes();
          }
        ),
      ),
    );
  }
}

class _CalendarEventes extends StatelessWidget {
  const _CalendarEventes();

  @override
  Widget build(BuildContext context) {

    final calendarProvider = Provider.of<CalendarProvider>(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding - 10),
          child: TableCalendar( 
            rowHeight: 40,
            eventLoader: (day){
              return calendarProvider.getAllEvents(day);
            },
            locale: 'ES_es',
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: calendarProvider.dayFocused,  
            calendarFormat: calendarProvider.calendarFormat,
            selectedDayPredicate: (day){
              return isSameDay(calendarProvider.currentDay, day);
            },
            onDaySelected: calendarProvider.onSelectDay,
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: const Color(AppTheme.primaryColor).withOpacity(0.7),
                shape: BoxShape.circle
              ),
              selectedDecoration: const BoxDecoration(
                color:Color(AppTheme.primaryColor),
                shape: BoxShape.circle
              )
            ),
        
            headerStyle: const HeaderStyle(titleCentered: true, formatButtonVisible: false),
            calendarBuilders: CalendarBuilders(
              markerBuilder:(context, day, events) {
                if(events.isNotEmpty){
                  return Container(
                    width: 15,
                    height: 15,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(AppTheme.secondaryColor),
                      shape: BoxShape.circle
                    ),
                    child: Text(
                      '${events.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  );
                }
          
                return null;
              },
            ),
          ),
        ),

        const SizedBox(height: 30),

        Text(
          'Lista de citas', 
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold, 
            color: const Color(AppTheme.primaryColor)
          ),
        ),

        const SizedBox(height: 10),
        ValueListenableBuilder<List<Appoiment>>(
          valueListenable: calendarProvider.selectedAppoiments, 
          builder:(context, value, _) {
            return _AppoimentList(value: value);
          },
        )
      ],
    );
  }
}

class _AppoimentList extends StatelessWidget {
  const _AppoimentList({
    required this.value
  });

  final List<Appoiment> value;

  @override
  Widget build(BuildContext context) {


    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: value.length,
      itemBuilder:(context, index) {

        final appoiment = value[index];
        final User patient = value[index].user!;
        final DateFormat format = DateFormat('dd-MM-yyyy');
        final Guest? guest = value[index].invitado;

        return _AppoimentItem(patient: patient, appoiment: appoiment, format: format, guest: guest,);
      },
    );
  }
}

class _AppoimentItem extends StatelessWidget {
  const _AppoimentItem({
    required this.patient,
    required this.appoiment,
    required this.format,
    required this.guest
  });

  final User patient;
  final Appoiment appoiment;
  final DateFormat format;
  final Guest? guest;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: AppTheme.horizontalPadding),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => AppoimentsDetails(patient: patient, appoiment: appoiment, guest: guest,)
        ));
      },
      title: Text(
        guest != null
          ? '${guest!.nombreInvitado} ${guest!.apellidoInvitado}'
          : '${patient.nombrePaciente} ${patient.apellidoPaciente}',
        style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.normal)
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              '${appoiment.fechaCitaStr}',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black45),
            )
          ),
          Text(
            appoiment.horaCitaStr,
            style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black45),
          )
        ],
      ),
      trailing: const Icon(Icons.keyboard_arrow_right_outlined),
    );
  }
}