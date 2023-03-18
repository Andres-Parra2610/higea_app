import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:higea_app/screens/screens.dart';
import 'package:higea_app/widgets/widgets.dart';

class IndexScreen extends StatefulWidget {
const IndexScreen({ Key? key }) : super(key: key);

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {

  final PageController controller = PageController();

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: () async{
        SystemNavigator.pop();
        return Future.value(false);
      },
      child: Scaffold(
        body: PageView(
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            HomeClientScreen(),
            HistoryScreen(),
            ProfileScreen()
          ],
        ),
    
        bottomNavigationBar: NavigationBarWidget(
          setCurrentIndex: (int value){
            controller.animateToPage(value, duration: const Duration(milliseconds: 100), curve: Curves.ease);
          },
        ),
      ),
    );
  }
}