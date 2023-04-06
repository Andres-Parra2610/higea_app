import 'package:flutter/material.dart';
import 'package:higea_app/helpers/helpers.dart';
import 'package:higea_app/screens/screens.dart';

class ReportButton extends StatelessWidget {
const ReportButton({ 
    Key? key,
    required this.title,
    required this.child,
    required this.icon,
    this.url = '',
    this.tap = true
  }) : super(key: key);

  final String title;
  final Widget child;
  final IconData icon;
  final String? url;
  final bool? tap;

  @override
  Widget build(BuildContext context){
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width * 0.25,
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          title: Text(title),
          subtitle: child,
          leading: Icon(icon),
          onTap: tap == false ? null : (){
            Navigator.push(context, MaterialPageRoute(builder: (_) => PdfViewScreen(url: url!)));
          },
        ),
      ),
    );
  }
}

//SELECT * from cita WHERE MONTH(cita.fecha_cita) = 1

class DropdownSelectButton extends StatelessWidget{
  DropdownSelectButton({super.key, required this.onSelected});

  final Function onSelected;

  final List<String> months = Helpers.months();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: DropdownButtonFormField(
        decoration: const InputDecoration(
          hintText: 'Listado de citas por mes', 
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10)
        ),
        isDense: true,
        onChanged: (value) => onSelected(value),
        items: [
          ...months.map((month){
            return DropdownMenuItem(
              value: months.indexOf(month) + 1,
              child: Text(month)
            );
          }).toList()
        ], 
      ),
    );
  }


}


