import 'dart:io';

class PlatformOs {

  static final String os = Platform.operatingSystem;

  static final bool isAndroid = (os == "android");

  static final bool isIOS = (os == "ios");
}
