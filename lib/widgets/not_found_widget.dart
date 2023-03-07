import 'package:flutter/material.dart';
import 'package:higea_app/styles/app_theme.dart';

class NotFoundWidget extends StatelessWidget {
  const NotFoundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height - size.height * 0.28 - (kBottomNavigationBarHeight + AppTheme.horizontalPadding * 2.5),
      child: Center(
          child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Vuelve a intentarlo',
              style: TextStyle(color: Colors.black45, fontSize: 16),
            ),
            SizedBox(width: 10),
            Icon(Icons.search_off, color: Colors.black45, size: 24,)
          ],
        )
      ),
    );
  }
}
