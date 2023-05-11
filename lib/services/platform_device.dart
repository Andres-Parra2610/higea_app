import 'package:flutter/foundation.dart';


/// @class [PlatformDevice]
/// @description Servicio que contiene un método el cual comprueba si la plataforma es PC de escritorio o teléfono

class PlatformDevice {

  static bool get isMobile => defaultTargetPlatform == TargetPlatform.android;
}