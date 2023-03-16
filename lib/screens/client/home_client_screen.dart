
import 'package:flutter/material.dart';
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
    final size = MediaQuery.of(context).size;
    final doctorProvider = Provider.of<DoctorProvider>(context);

    return Container(
      padding: const EdgeInsets.all(AppTheme.horizontalPadding),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Todas las especialidades', style: textTheme.titleLarge,),

          FutureBuilder(
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
          
              if(specialities.isEmpty) return const NotFoundWidget();

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ), 
                itemCount: specialities.length, //snapshot.data!.length,
                itemBuilder: (_, index){
                  final Speciality speciality = specialities[index];
                  return CardWidget(speciality: speciality);
                }
              );
            }
          )
        ],
      )
    );
  }
}

class _CustomHeader extends StatelessWidget {
  
  const _CustomHeader({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.all(AppTheme.horizontalPadding),
      height: size.height * 0.28,
      width: double.infinity,
      decoration: AppTheme.BoxGradient(),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            
            _ClientName(),
          
            _SearchField()
          ],
        ),
      ),
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

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bienvenido',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24
            ),
          ),
          Text(
            '$name $lastName',
            style: const TextStyle(
              color:  Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
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
        onFieldSubmitted: (value) => doctorProvider.searchSpeciality = value ,
      ),
    );
  }
}
