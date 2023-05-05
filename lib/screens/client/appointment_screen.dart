import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:higea_app/helpers/helpers.dart';
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

    final appoimentProvider = Provider.of<AppoimentProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async{
        appoimentProvider.appoiments = [];
        return true;
      },
      child: Scaffold(
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
              child:  _AppoinmentDates(ci: doctor.cedula)
            ),
    
            const Expanded(
              flex: 4,
              child: _AppointmentHours(),
            ),
          ],
        ),
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

    final appoimentProvider = Provider.of<AppoimentProvider>(context, listen: false);

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
              onPressed: (){
                appoimentProvider.appoiments = [];
                Navigator.pop(context);
              }
            ),
            Expanded(
              child: _TextHeader(doctor: doctor),
            ),
            /* CircleAvatar(
              radius: 30,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image(
                  width: double.infinity,
                  image: AssetImage(img),
                  fit: BoxFit.cover,
                ),
              ),
            ) */
          ],
        ),
      ),
    );
  }
}

class _TextHeader extends StatelessWidget {
  const _TextHeader({
    Key? key, 
    required this.doctor
  }) : super(key: key);

  final Doctor doctor;
  
  @override
  Widget build(BuildContext context) {

    final name = doctor.nombreMedico.split(' ')[0];
    final lastName = doctor.apellidoMedico.split(' ')[0];
    final prefix = doctor.sexoMedico == 'F' ? 'Dra.' : 'Dr';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        Text(
          '$prefix $name $lastName',
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: const Color(AppTheme.primaryColor),
              fontWeight: FontWeight.bold,
              fontSize: 18
            ),
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

    final appimentProvider = Provider.of<AppoimentProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding, vertical: 15),
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: FutureBuilder(
            future: appimentProvider.showDoctorDatesWork(ci),
            builder: (context, AsyncSnapshot<Doctor>snapshot){

              if(!snapshot.hasData){
                return const Center(child: CircularProgressIndicator.adaptive());
              }

              final dates = snapshot.data!.fechas;

              return _DatesListView(dates: dates!, ci: ci);
            }
          ),
        ),
      ],
    );
  }
}

class _DatesListView extends StatefulWidget {
  const _DatesListView({
    required this.dates,
    required this.ci,
  });

  final List<String> dates;
  final int ci;

  @override
  State<_DatesListView> createState() => _DatesListViewState();
}

class _DatesListViewState extends State<_DatesListView> {

  late int currentIndex;

  @override
  void initState() {
    currentIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.dates.length,
      itemBuilder: (context, index) {
        final String date = widget.dates[index];
        return _Dates(
          index: index, 
          date: date, 
          doctorCi: widget.ci,
          currentIndex: currentIndex,
          updateIndex: (int index){
            setState(()=> currentIndex = index);
          },
        );
      }
    );
  }
}

class _Dates extends StatelessWidget {
  const _Dates({
    required this.index,
    required this.date,
    required this.doctorCi,
    required this.currentIndex,
    required this.updateIndex
  }
  );

  final int index;
  final int doctorCi;
  final String date;
  final int currentIndex;
  final Function updateIndex;

  @override
  Widget build(BuildContext context) {

    final appoimentProvider = Provider.of<AppoimentProvider>(context, listen: false);
    int bgColor;
    int textColor;

    if(currentIndex == index){
      bgColor = AppTheme.primaryColor;
      textColor = 0xFFFFFFFF;
    }else{
      bgColor = 0xFFEEEEEE;
      textColor = AppTheme.primaryColor;
    }

    List<String> dateArray = date.split(' ');
    final String nameDay = dateArray[0][0].toUpperCase() + dateArray[0].substring(1,3);
    final String day = dateArray[1].split('/')[0];
    final DateTime parsedDate = DateFormat('dd/MM/yy').parse(dateArray[1]);
    final String monthName =  DateFormat('MMMM', 'es_ES').format(parsedDate);
    final double dateMargin = index == 0 ? AppTheme.horizontalPadding : 5;


    return GestureDetector(
      onTap: currentIndex == index 
        ? null 
        : () async{
          final currentDay = DateFormat('yyyy-MM-dd').format(parsedDate);
          final showCompleteDate = Helpers.completeDate(date);
          updateIndex(index);
          await appoimentProvider.showAppoiment(doctorCi, currentDay, showCompleteDate);
        },
      child: Container(
        margin: EdgeInsets.only( top: 0, bottom: 0, right: 5, left: dateMargin),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(bgColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Text('$monthName: ', style: TextStyle(fontSize: 14,color: Color(textColor), fontWeight: FontWeight.bold)),
            Text('$nameDay ', style: TextStyle(fontSize: 14,color: Color(textColor))),
            Text(day, style: TextStyle(fontSize: 14, color: Color(textColor)))
          ],
        ),
      ),
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

             const _ShowAppoimentDate(),
                    
             const _AviableAppoiments()
                    
           ],
         ),
       ),
     );
  }
}

class _ShowAppoimentDate extends StatelessWidget {
  const _ShowAppoimentDate();

  @override
  Widget build(BuildContext context) {

    final appoimentProvider = Provider.of<AppoimentProvider>(context);


    if(appoimentProvider.date.isEmpty){
      return Container();
    }

    return Text(appoimentProvider.date);
  }
}

class _AviableAppoiments extends StatelessWidget {
  const _AviableAppoiments();

  @override
  Widget build(BuildContext context) {

    final appoimentProvider = Provider.of<AppoimentProvider>(context);

    if(appoimentProvider.loading){
      return const Center(child: CircularProgressIndicator.adaptive());
    }


    final List<Appoiment> appoiments = appoimentProvider.appoiments;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: appoiments.length,
      itemBuilder: (context, index){

        final Appoiment appoiment = appoiments[index];

        return _AppoimentStatus(appoiment: appoiment);
      }
    );
  }
}

class _AppoimentStatus extends StatelessWidget {
  const _AppoimentStatus({
    required this.appoiment,
  });

  final Appoiment appoiment;


  @override
  Widget build(BuildContext context) {


    final currentUser = Provider.of<AuthProvider>(context, listen: false).currentUser;
    final size = MediaQuery.of(context).size;

    final String appoimentHour = Helpers.transformHour(appoiment.horaCita);
    String text = "Disponible";
    int bgColor = AppTheme.primaryColor;
    String actionText = "Reservar";
    
   

    if((currentUser.cedula == appoiment.cedulaPaciente) && appoiment.idCita != 0){
      if(appoiment.citaEstado == "cancelada"){
        text = "Cancelada";
        actionText = " ";
        bgColor = 0xFFFF8A00;
      }else{
        actionText = "Cancelar";
        text = "Reservada";
        bgColor = 0xFF45BB1B;
      }
    }else if(appoiment.citaEstado == "ocupada"){
      text = "Ocupada";
      actionText = " ";
      bgColor = AppTheme.secondaryColor;
    }


    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(bgColor).withOpacity(0.05),
              borderRadius: BorderRadius.circular(10)
            ),
            padding: EdgeInsets.symmetric(vertical:15, horizontal: size.width * 0.020),
            child: Text(appoimentHour, style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.normal)),
          ),
      
          const SizedBox(width: 20),
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              splashColor: Colors.black,
              onTap: actionText == "Cancelar"
                ? () => _alertDialog(context, 'cancelar')
                : appoiment.idCita == 0 || actionText == "Reservar"
                  ? () => _alertDialog(context, 'reservar')
                  : null,

              child: Container(
                decoration: BoxDecoration(
                  color: Color(bgColor).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10)
                ),
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text(actionText, style: const TextStyle(fontSize: 13, color: Colors.white))
                  ],
                ),
              ),
            ),
          )
        ],  
      ),
    );
  }

  _alertDialog(BuildContext context, String action) async {

    Widget alertDialog;
    
    action == 'cancelar' 
      ? alertDialog = CancelAppoimentWidget(appoiment: appoiment)
      : alertDialog = ConfirmAppoimentWidget(appoiment: appoiment);

    final result = await showDialog(context: context, builder: (context) => alertDialog);              
    if(result == null) return;

    final Response response = result;
    
    SnackBarWidget.showSnackBar(response.msg, response.ok);
  }
}
