import 'package:flutter/material.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:higea_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
const HistoryScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){

    final User currentPatient = Provider.of<AuthProvider>(context, listen: false).currentUser;

    return HistoryListWidget(patient: currentPatient);
  }
}

