import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/services/services.dart';


class SpecialityProvider extends ChangeNotifier{

  late Speciality currentSpeciality;
  PlatformFile? pickedImage;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value){
    _isLoading = value;
    notifyListeners();
  } 

  SpecialityProvider(Speciality speciality){
    currentSpeciality = speciality;
  }


  Future<void> pickImage() async {
    FilePickerResult? image = await FilePicker.platform.pickFiles(type: FileType.image);
    if (image != null) {
      Uint8List fileBytes = image.files.single.bytes!;
      pickedImage = image.files.single;
      notifyListeners();
      // Upload file
      String base64Image = base64Encode(fileBytes);
      currentSpeciality.imagenEspecialidad = base64Image;
    }
  }

  Future insertSpeciality()async {
    isLoading = true;
    final Map<String, dynamic> res = await SpecialityService.addSpeciality(currentSpeciality);
    isLoading = false;
    return res["ok"];
  }


  Future updateSpeciality() async{
    isLoading = true;
    final Map<String, dynamic> res = await SpecialityService.updateSpeciality(currentSpeciality);
    isLoading = false;
    return res["ok"];
  }

  Future deleteSpeciality(int id) async{
    isLoading = true;
    final Map<String, dynamic> res = await SpecialityService.removeSpeciality(id);
    isLoading = false;
    return res["ok"];
  }

  

}