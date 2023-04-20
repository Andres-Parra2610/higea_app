import 'package:flutter/material.dart';
import 'package:higea_app/styles/app_theme.dart';

class NotFoundWidget extends StatelessWidget {
  const NotFoundWidget({
      Key? key,
      required this.text,
      required this.icon
    }) : super(key: key);


  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {

    
    return Center(
        child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          Text(
            text,
            style: const TextStyle(color: Colors.black45, fontSize: 16),
          ),
          const SizedBox(width: 10),
          Icon(icon, color: Colors.black45, size: 24,)
        ],
      )
    );
  }
}
