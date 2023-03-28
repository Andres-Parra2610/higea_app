import 'package:flutter/foundation.dart';

class PlatformDevice {

  static bool get isMobile => defaultTargetPlatform == TargetPlatform.android;
}