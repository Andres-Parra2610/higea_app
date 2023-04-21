import 'package:flutter/material.dart';
import 'package:higea_app/helpers/helpers.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:higea_app/screens/screens.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:provider/provider.dart';

class EspecialityScreen extends StatelessWidget {
  const EspecialityScreen({ 
    Key? key, 
    required this.speciality 
  }) : super(key: key);

  final Speciality speciality;
  @override
  Widget build(BuildContext context){

    return  Scaffold(
      body: CustomScrollView(
        slivers: [

          _EspecialistAppBar(speciality: speciality),


          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.horizontalPadding),
              child: Text('Doctores de la especialidad', style: Theme.of(context).textTheme.titleLarge),
            ),
          ),

          _EspecialistList(id: speciality.idespecialidad)
        ],
      ),
    );
  }
}



class _EspecialistAppBar extends StatelessWidget {
  const _EspecialistAppBar({
    Key? key, 
    required this.speciality, 
  }) : super(key: key);

  final Speciality speciality;
  

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      leading: Container(),
      backgroundColor: const Color(AppTheme.primaryColor),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.all(0),
        title:  Container(
          alignment: Alignment.bottomCenter,
          decoration: AppTheme.boxGradient(fOpacity: 0.5, sOpacity: 0.2),
          width: double.infinity,
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context), 
                icon: const Icon(Icons.arrow_back, color: Colors.white,)
              ),
              Expanded(
                child: Text(
                  speciality.nombreEspecialidad, 
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold,color: Colors.white)
                ),
              )
            ],
          ),
        ),
        background: Hero(
          tag: speciality.idespecialidad,
          child: Image(
            image: speciality.imagenEspecialidad!.isEmpty
            ? const AssetImage('assets/no-image.jpg')
            : NetworkImage(speciality.imagenEspecialidad!) as ImageProvider,
            fit: BoxFit.cover,
          ),
        )
      ),
    );
  }
}


class _EspecialistList extends StatelessWidget {
  const _EspecialistList({
    Key? key, 
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {

    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);

    return FutureBuilder(
      future: doctorProvider.showDoctorBySpeciality(id),
      builder: (context, AsyncSnapshot<List<Doctor>> snapshot){
        
        if(!snapshot.hasData){
          return const SliverToBoxAdapter(
            child: Center(
              heightFactor: 10,
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: snapshot.data!.length,
            (context, index) {
              
              final Doctor doctor = snapshot.data![index];
              
              return Column(
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> AppointmentScreen(doctor: doctor)));
                    },
                    child: _DoctorItem(doctor: doctor),
                  ),

                  const Divider()
                ],
              );
          })
        );
      }
    );
  }
}

class _DoctorItem extends StatelessWidget {
  const _DoctorItem({
    required this.doctor,
  });

  final Doctor doctor;
  

  @override
  Widget build(BuildContext context) {

    final startTime = Helpers.transformHour(doctor.horaInicio!);
    final endTime = Helpers.transformHour(doctor.horaFin!);
    final name = doctor.nombreMedico.split(' ')[0];
    final lastName = doctor.apellidoMedico.split(' ')[0];
    final prefix = doctor.sexoMedico == 'F' ? 'Dra.' : 'Dr';
    final img = doctor.sexoMedico == 'F' 
      ? 'assets/doctora-avatar.jpg'
      : 'assets/doctor-avatar.jpg'; 

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding, vertical: 8),
      child: Row(
        children: [
          Hero(
            tag: doctor.cedula,
            child: CircleAvatar(
              backgroundImage: AssetImage(img),
              radius: 25,
            ),
          ),

          const SizedBox(width: 40),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$prefix $name $lastName',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: const Color(AppTheme.primaryColor),
                fontWeight: FontWeight.bold,
              )),

              const SizedBox(height: 5),
              Text('Horario de atención: ', style: Theme.of(context).textTheme.labelMedium),
              Text('$startTime - $endTime', style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
        ],
      ),
    );
  }
}