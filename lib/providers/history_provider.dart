

import 'package:flutter/material.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/services/services.dart';

class HistoryProvider extends ChangeNotifier{

  bool _switchValue = false;
  bool _loading = false;
  late History currentHistory;
  String _switchError = '';


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool get switchValue => _switchValue;
  bool get loading => _loading;
  String get switchError => _switchError;

  set switchValue(bool value){
    _switchValue = value;
    notifyListeners();
  }

  set loading(bool value){
    _loading = value;
    notifyListeners();
  }

  set switchError(String value){
    _switchError = value;
    notifyListeners();
  }

  Future<History> showHistory(int id) async{

    final Map<String, dynamic> res = await AppoimentService.getHistoryById(id);

    final History history = History.fromJson(res['results']);
    currentHistory = history;
    return history;
  }


  Future<String> finishAppoiment(int id) async{

    loading = true;
    final Map<String, dynamic> res = await AppoimentService.setHistory(currentHistory, id);

    loading = false;

    return res['msg'];
  }


}