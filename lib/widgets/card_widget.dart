
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
const CardWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return  Card(
      elevation: 1,
      child: Column(
        children: [
          const ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            child: Image(
              image: AssetImage('assets/doctor-avatar.jpg'),
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Text('Pediatría', style: Theme.of(context).textTheme.subtitle1,)
        ],
      ),
    );
  }
}