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
    final Map<String, dynamic> res = await SpecialityService.addSpeciality(currentSpeciality);

  }

  

}