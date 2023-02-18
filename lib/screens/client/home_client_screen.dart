
import 'package:flutter/material.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:higea_app/widgets/widgets.dart';



class HomeClientScreen extends StatelessWidget {
const HomeClientScreen({ Key? key }) : super(key: key);

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Todas las especialidades', style: textTheme.headline6,),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              childAspectRatio: 3/2.5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10
            ), 
            itemCount: 30,
            itemBuilder: (_, index) => const CardWidget()
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
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Bienvenido',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24
            ),
          ),
          Text(
            'Andrés Parra',
            style: TextStyle(
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
      ),
    );
  }
}
