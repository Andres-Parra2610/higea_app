
import 'package:flutter/material.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/screens/screens.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    Key? key, 
    required this.speciality
  }) : super(key: key);

  final Speciality speciality;

  @override
  Widget build(BuildContext context){

    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => EspecialityScreen(speciality: speciality)));
      },
      child: Card(
        elevation: 1,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              child: Image(
                image: NetworkImage(speciality.imagenEspecialidad!),
                height: 110,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(speciality.nombreEspecialidad, style: Theme.of(context).textTheme.titleMedium,)
          ],
        ),
      ),
    );
  }
}