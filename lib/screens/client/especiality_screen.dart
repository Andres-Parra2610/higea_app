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

          _EspecialistAppBar(name: speciality.nombreEspecialidad, url: speciality.imagenEspecialidad!),


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
    required this.name, 
    required this.url,
  }) : super(key: key);

  final String name;
  final String url;

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
          decoration: AppTheme.BoxGradient(fOpacity: 0.5, sOpacity: 0.2),
          width: double.infinity,
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context), 
                icon: const Icon(Icons.arrow_back, color: Colors.white,)
              ),
              Text(
                name, 
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
              )
            ],
          ),
        ),
        background: Image(
          image: NetworkImage(url),
          fit: BoxFit.cover,
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
              
              final startTime = Helpers.transformDate(snapshot.data![index].horaInicio);
              final endTime = Helpers.transformDate(snapshot.data![index].horaFin);
              final name = snapshot.data![index].nombreMedico.split(' ')[0];
              final lastName = snapshot.data![index].apellidoMedico.split(' ')[0];
              final prefix = snapshot.data![index].sexoMedico == 'F' ? 'Dra.' : 'Dr';
              final img = snapshot.data![index].sexoMedico == 'F' 
                ? 'assets/doctora-avatar.jpg'
                : 'assets/doctor-avatar.jpg'; 

              return Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding, vertical: 15),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> AppointmentScreen(doctor: snapshot.data![index])));
                    },
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(img),
                      radius: 30,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$prefix $name $lastName',style: const TextStyle(
                          color: Color(AppTheme.primaryColor),
                          fontWeight: FontWeight.bold
                        )),
                        //const Text('Pediatra')
                      ],
                    ),
                    trailing: Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Horario'),
                          Text('$startTime - $endTime')
                        ],
                      ),
                    ),
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