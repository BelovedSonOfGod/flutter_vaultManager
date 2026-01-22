import 'package:flutter/foundation.dart';

class PrintingForDebugClass {
  static void logDebug(String message) {
    if (kDebugMode) {
      print(message); // Or debugPrint(message);
    }
  }
}
