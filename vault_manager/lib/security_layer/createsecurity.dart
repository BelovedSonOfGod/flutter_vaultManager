class CreateSecurity {
  static String generateSalt() {
    String salt = "hola";
    return salt;
  }

  static String generateNonce() {
    return "123hola";
  }

  static Map<String, String> generateKDFParameters() {
    return <String, String>{'length': '16', 'iterations': '1000'};
  }
}
