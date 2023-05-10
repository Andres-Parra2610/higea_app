
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:higea_app/widgets/widgets.dart';

class HomeClientScreen extends StatelessWidget {

  const HomeClientScreen({super.key});  

  @override
  Widget build(BuildContext context){
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          children: const [
            _CustomHeader(),
            
            _Especialities()
          ],
        ),
      ),
    );
  }
}

class _Especialities extends StatelessWidget {
  const _Especialities({
    Key? key,
  }) : super(key: key);

 
  @override
  Widget build(BuildContext context) {
    
    final textTheme = Theme.of(context).textTheme;
    

    return Container(
      padding: const EdgeInsets.all(AppTheme.horizontalPadding),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Todas las especialidades', style: textTheme.titleLarge,),

          const _SpecialitiesFutureBuilder()
        ],
      )
    );
  }
}

class _SpecialitiesFutureBuilder extends StatelessWidget {
  const _SpecialitiesFutureBuilder();

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final doctorProvider = Provider.of<DoctorProvider>(context);

    return FutureBuilder(
      future: doctorProvider.showSpecialities(),
      builder: (context, AsyncSnapshot<List<Speciality>> snapshot){
    
        if(!snapshot.hasData){
          return const Center(
            heightFactor: 10,
            child: CircularProgressIndicator.adaptive()
          );
        }
    
        List<Speciality> specialities = snapshot.data!;
    
        if(doctorProvider.searchSpeciality.isNotEmpty){
          final txt = doctorProvider.searchSpeciality.toLowerCase();
          specialities = specialities.where((speciality) => 
            speciality.nombreEspecialidad.toLowerCase().contains(txt)
          ).toList();
        }
    
        if(specialities.isEmpty){
          return SizedBox(
            height:size.height - size.height * 0.28 - (kBottomNavigationBarHeight + AppTheme.horizontalPadding * 2.5),
            child: const NotFoundWidget(text: 'Sin resultados', icon: Icons.search_off,),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            mainAxisSpacing: 10,
            crossAxisSpacing: 2.5,
          ), 
          itemCount: specialities.length, //snapshot.data!.length,
          itemBuilder: (_, index){
            final Speciality speciality = specialities[index];

            return Animate(
              effects: const [FadeEffect()],
              child: CardWidget(speciality: speciality)
            );
          }
        );
      }
    );
  }
}

class _CustomHeader extends StatelessWidget {
  
  const _CustomHeader({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {


    return Container(
      padding: const EdgeInsets.all(AppTheme.horizontalPadding),
      width: double.infinity,
      decoration: AppTheme.boxGradient(),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            
            _ClientName(),

            SizedBox(height: 20),

            _TextRecordatory(),
          
            _SearchField()
          ],
        ),
      ),
    );
  }
}

class _TextRecordatory extends StatelessWidget {
  const _TextRecordatory();

  @override
  Widget build(BuildContext context) {

    final appoimentProvider = Provider.of<AppoimentProvider>(context, listen: false);
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;

    return FutureBuilder(
      future: appoimentProvider.showAppoimentByPatient(user.cedula),
      builder: (context, AsyncSnapshot<List<Appoiment>> snapshot) {

        if(!snapshot.hasData) return const SizedBox();

        if(snapshot.data!.isEmpty) return const SizedBox();

        return Column(
          children: const [
            Text(
              'Recuerda que tienes citas pendientes, ¡no las olvides!',
              style: TextStyle(
                fontSize: 14, 
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),

            SizedBox(height: 25)
          ],
        );
      }
    );
  }
}

class _ClientName extends StatelessWidget {
  const _ClientName({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    final name = user.nombrePaciente.split(' ')[0];
    final lastName = user.apellidoPaciente.split(' ')[0];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bienvenido',
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white, fontWeight: FontWeight.normal)
        ),
        Text(
          '$name $lastName',
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white)
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);

    return SizedBox(
      width: double.infinity * 0.1,
      height: 50,
      child: TextFormField(
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: 'Buscar especialidad',
          hintStyle: TextStyle(fontSize: 14),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0)
        ),
        onChanged: (value) => doctorProvider.searchSpeciality = value ,
      ),
    );
  }
}
