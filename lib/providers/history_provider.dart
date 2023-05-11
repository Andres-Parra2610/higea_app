

import 'package:flutter/material.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/services/services.dart';

/// @class [HistoryProvider]
/// @description Provider que controla los cambios de estado relacionados con las historias médicas

class HistoryProvider extends ChangeNotifier{

  late History currentHistory;
  List<History> histories = [];
  bool _switchValue = false;
  bool _loading = false;
  bool _writing = false;
  bool _saved = false;
  String _switchError = '';


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool get switchValue => _switchValue;
  bool get loading => _loading;
  bool get writing => _writing;
  bool get saved => _saved;
  String get switchError => _switchError;

  set switchValue(bool value){
    if(value != _switchValue){
      _switchValue = value;
      notifyListeners();
    }
  }

  set loading(bool value){
    _loading = value;
    notifyListeners();
  }

  set writing(bool value){
    if(value != _writing){
      _writing = value;
      notifyListeners();
    }
  }

  set saved(bool value){
    _saved = value;
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


  Future<List<History>> showHistoryByPatient(int ci) async{

    //if(histories.isNotEmpty) return histories;

    final Map<String, dynamic> res = await HistoryService.getHistoryByPatient(ci);

    if(res['ok'] == false) return [];

    final historyList = res['result'] as List<dynamic>;
    histories = historyList.map((e) => History.fromJson(e)).toList();
    return histories;
  }


  Future inattentiveAppoiment(int id) async{

    final Response res = await AppoimentService.makeInattentiveAppoiment(id);
    return res;
  }


  Future<String> finishAppoiment(int id) async{

    loading = true;
    final Map<String, dynamic> res = await AppoimentService.setHistory(currentHistory, id);

    loading = false;
    saved = true;

    return res['msg'];
  }


  void clearProvider(){
    switchValue = false;
    writing = false;
    switchError = '';
    saved = false;
  }


}