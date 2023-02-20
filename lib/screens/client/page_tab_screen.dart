import 'package:flutter/material.dart';
import 'package:higea_app/screens/screens.dart';
import 'package:higea_app/widgets/widgets.dart';

class PageTabScreen extends StatefulWidget {
const PageTabScreen({ Key? key }) : super(key: key);

  @override
  State<PageTabScreen> createState() => _PageTabScreenState();
}

class _PageTabScreenState extends State<PageTabScreen> {

  final PageController controller = PageController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const HomeClientScreen(),
          Container(),
          Container(),
        ],
      ),

      bottomNavigationBar: NavigationBarWidget(
        setCurrentIndex: (int value){
          controller.animateToPage(value, duration: const Duration(milliseconds: 500), curve: Curves.ease);
        },
      ),
    );
  }
}