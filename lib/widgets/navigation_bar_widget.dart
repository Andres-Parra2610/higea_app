import 'package:flutter/material.dart';
import 'package:higea_app/styles/app_theme.dart';

class NavigationBarWidget extends StatefulWidget {
  const NavigationBarWidget({ Key? key, required this.setCurrentIndex }) : super(key: key);

  final Function setCurrentIndex;

  @override
  State<NavigationBarWidget> createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {

  int index = 0;

  @override
  Widget build(BuildContext context){
    return BottomNavigationBar(
      currentIndex: index,
      onTap: (value){
        widget.setCurrentIndex(value);
        setState(() => index = value);
      },
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          activeIcon: _iconActive(Icons.home),
          label: 'Inicio'
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.history),
          activeIcon: _iconActive(Icons.history),
          label: 'Historial'
        )
      ]
    );
  }

  CircleAvatar _iconActive(IconData icon) {
    return CircleAvatar(
      backgroundColor: const Color(AppTheme.primaryColor),
      child: Icon(icon, color: Colors.white,),
    );
  }
}