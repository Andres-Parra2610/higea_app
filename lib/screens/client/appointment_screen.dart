import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:higea_app/widgets/widgets.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({
    Key? key,
    required this.doctor
  }) : super(key: key);

  final Doctor doctor;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1, 
            child: _AppointMentAppBar(doctor: doctor)
          ),

          
          Expanded(
            flex: 1, 
            child:  _AppoinmentDates(ci: doctor.cedulaMedico)
          ),

           const Expanded(
            flex: 3,
             child: _AppointmentHours(),
           )
        ],
      ),
    );
  }
}



class _AppointMentAppBar extends StatelessWidget {
  const _AppointMentAppBar({
    Key? key, 
    required this.doctor,
  }) : super(key: key);


  final Doctor doctor;

  @override
  Widget build(BuildContext context) {

    final name = doctor.nombreMedico.split(' ')[0];
    final lastName = doctor.apellidoMedico.split(' ')[0];
    final prefix = doctor.sexoMedico == 'F' ? 'Dra.' : 'Dr';
    final img = doctor.sexoMedico == 'F' 
          ? 'assets/doctora-avatar.jpg'
          : 'assets/doctor-avatar.jpg'; 

    return Container(
      padding: const EdgeInsets.only(right: AppTheme.horizontalPadding, left: 15),
      height: MediaQuery.of(context).size.height * 0.2,
      width: double.infinity,
      color: Colors.white,
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              iconSize: 30,
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: _TextHeader(name: name, lastName: lastName, prefix: prefix),
            ),
            CircleAvatar(
              radius: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image(
                  width: double.infinity,
                  image: AssetImage(img),
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _TextHeader extends StatelessWidget {
  const _TextHeader({
    Key? key, 
    required this.name, 
    required this.lastName, 
    required this.prefix,
  }) : super(key: key);

  final String name;
  final String lastName;
  final String prefix;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        Text(
          '$prefix $name $lastName',
          style: const TextStyle(
              color: Color(AppTheme.primaryColor),
              fontSize: 22,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}



class _AppoinmentDates extends StatelessWidget {
  const _AppoinmentDates({
    Key? key, 
    required this.ci,
  }) : super(key: key);

  final int ci;

  @override
  Widget build(BuildContext context) {

    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding, vertical: 15),
          child: Text(''),
        ),
        SizedBox(
          width: double.infinity,
          height: 85,
          child: FutureBuilder(
            future: doctorProvider.showDoctorDatesWork(ci),
            builder: (context, AsyncSnapshot<Doctor>snapshot){

              if(!snapshot.hasData){
                return const Center(child: CircularProgressIndicator.adaptive());
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.fechas!.length,
                itemBuilder: (context, index) {

                  final String date = snapshot.data!.fechas![index];
                  return _Dates(index, date);
                }
              );
            }
          ),
        ),
      ],
    );
  }
}

class _Dates extends StatelessWidget {
  const _Dates(
    this.index,
    this.date
  );

  final int index;
  final String date;

  @override
  Widget build(BuildContext context) {

    initializeDateFormatting('es_ES');
    List<String> dateArray = date.split(' ');
    final String nameDay = dateArray[0][0].toUpperCase() + dateArray[0].substring(1,3);
    final String day = dateArray[1].split('/')[0];
    final DateTime parsedDate = DateFormat('dd/MM/yy').parse(dateArray[1]);
    final String monthName =  DateFormat('MMMM', 'es_ES').format(parsedDate);
    final double dateMargin = index == 0 ? AppTheme.horizontalPadding : 5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.only( top: 0, bottom: 0, right: 5, left: dateMargin),
          child: Text(monthName, style: const TextStyle(fontSize: 12))
        ),
        Container(
          width: 60,
          margin: EdgeInsets.only( top: 0, bottom: 0, right: 5, left: dateMargin),
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration( color: Colors.blue, shape: BoxShape.circle),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(nameDay,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              Text(day,
                  style: const TextStyle(fontSize: 18, color: Colors.white))
            ],
          ),
        ),
      ],
    );
  }
}


class _AppointmentHours extends StatelessWidget {
  const _AppointmentHours({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
       padding: const EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding, vertical: 0),
       child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text('Lista de horarios', style: Theme.of(context).textTheme.titleLarge),
             const Text('Lunes 19 de febrero'),
                    
             ListView.builder(
               shrinkWrap: true,
               physics: const NeverScrollableScrollPhysics(),
               itemCount: 50,
               itemBuilder: (context, index){
                 return Container(
                   margin: const EdgeInsets.only(bottom: 20),
                   child: Row(
                     children: [
                       Container(
                         decoration: BoxDecoration(
                           color: const Color(AppTheme.primaryColor).withOpacity(0.05),
                           borderRadius: BorderRadius.circular(10)
                         ),
                         padding: const EdgeInsets.symmetric(vertical:15, horizontal: 40),
                         child: const Text('8:00 am', style: TextStyle(fontSize: 16)),
                       ),

                       const SizedBox(width: 20),
                       Expanded(
                         child: GestureDetector(
                          onTap: () => showDialog(context: context, builder: (context) => const ShowDialogWidget() ),
                           child: Container(
                             decoration: BoxDecoration(
                               color: const Color(AppTheme.primaryColor).withOpacity(0.8),
                               borderRadius: BorderRadius.circular(10)
                             ),
                             padding: const EdgeInsets.symmetric(vertical:15),
                             child: const Center(
                               child: Text('Disponible', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))
                             ),
                           ),
                         ),
                       )
                     ],
                   ),
                 );
               }
             )
                    
           ],
         ),
       ),
     );
  }
}
