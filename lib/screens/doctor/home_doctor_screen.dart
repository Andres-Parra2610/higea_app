import 'package:flutter/material.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';


class HomeDoctorScreen extends StatelessWidget {
const HomeDoctorScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){

    final calendarProvider = Provider.of<CalendarProvider>(context);
    final currentDoctor = Provider.of<AuthProvider>(context, listen: false).currentDoctor;

    return Scaffold(
      appBar: AppBar(
        title: Text(currentDoctor.nombreMedico),
        titleTextStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Color(AppTheme.primaryColor)),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: calendarProvider.getEventsFromBd(currentDoctor.cedulaMedico),
          builder: (context, AsyncSnapshot<Map<String, List<Appoiment>>> snapshot) {
            
            if(!snapshot.hasData){
              return const Center(child: CircularProgressIndicator(),);
            }

            return Column(
              children: [
                TableCalendar( 
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


                  headerStyle: const HeaderStyle(titleCentered: true, formatButtonVisible: false),
                  calendarBuilders: CalendarBuilders(
                    markerBuilder:(context, day, events) {
                      if(events.isNotEmpty){
                        return Container(
                          width: 20,
                          height: 20,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.lightBlue,
                            shape: BoxShape.circle
                          ),
                          child: Text(
                            '${events.length}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }
        
                      return null;
                    },
                  ),
                ),

                const Text('Lista de citas'),
                ValueListenableBuilder<List<Appoiment>>(
                  valueListenable: calendarProvider.selectedAppoiments, 
                  builder:(context, value, _) {
                    return _AppoimentList(value: value);
                  },
                )
              ],
            );
          }
        ),
      ),
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
      shrinkWrap: true,
      itemCount: value.length,
      itemBuilder:(context, index) {

        final appoiment = value[index];
        final DateFormat format = DateFormat('dd-MM-yyyy');


        return ListTile(
          onTap: () => print(value[index]),
          title: Text(appoiment.horaCita),
          subtitle: Text('${appoiment.horaCita} ${format.format(appoiment.fechaCita)}'),
        );
      },
    );
  }
}