import 'dart:typed_data';
import 'dart:convert';

class CreateSecurity {
  static String generateSalt() {
    String salt = "hola";
    return salt;
  }

  static String generateRandomNumber() {
    return "123holaSoyUnRandomNumber";
  }

  static String encrypt(
    Map<String, String> payload,
    Uint8List key,
    String nonce,
  ) {
    return "ImEncryptedText";
  }

  static Uint8List deriveKey(
    String password,
    String salt,
    Map<String, dynamic> kdfParameters,
  ) {
    return Uint8List.fromList(utf8.encode("12345derivedkey"));
  }

  static Map<String, dynamic> generateKDFParameters() {
    return <String, dynamic>{'length': 16, 'iterations': 1000};
  }
}
