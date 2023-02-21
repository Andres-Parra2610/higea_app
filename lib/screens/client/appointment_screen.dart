import 'package:flutter/material.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:higea_app/widgets/widgets.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Expanded(
            flex: 1, 
            child: _AppointMentAppBar()
          ),

          
          Expanded(
            flex: 1, 
            child:  _AppoinmentDates()
          ),

           Expanded(
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            const Expanded(
              child: _TextHeader(),
            ),
            CircleAvatar(
              radius: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: const Image(
                  width: double.infinity,
                  image: AssetImage('assets/doctor-avatar.jpg'),
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Dr Andrés Parra',
          style: TextStyle(
              color: Color(AppTheme.primaryColor),
              fontSize: 22,
              fontWeight: FontWeight.bold),
        ),
        Text(
          'Pediatra',
          style: TextStyle(fontSize: 18),
        )
      ],
    );
  }
}



class _AppoinmentDates extends StatelessWidget {
  const _AppoinmentDates({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding, vertical: 15),
          child: Text('Febrero', style: Theme.of(context).textTheme.headline6),
        ),
        SizedBox(
          width: double.infinity,
          height: 65,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 50,
              itemBuilder: (context, index) {
                double dateMargin;
                if (index == 0) {
                  dateMargin = AppTheme.horizontalPadding;
                } else {
                  dateMargin = 5;
                }
                return Container(
                  width: 65,
                  margin: EdgeInsets.only(
                      top: 0, bottom: 0, right: 5, left: dateMargin),
                  decoration: const BoxDecoration(
                      color: Colors.blue, shape: BoxShape.circle),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Lun',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text('19',
                          style:
                              TextStyle(fontSize: 18, color: Colors.white))
                    ],
                  ),
                );
              }
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
             Text('Lista de horarios', style: Theme.of(context).textTheme.headline6),
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
