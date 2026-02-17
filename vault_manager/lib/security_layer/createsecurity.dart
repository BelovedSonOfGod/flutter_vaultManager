class CreateSecurity {
  String generateSalt() {
    String salt = "hola";
    return salt;
  }

  static Map<String, String> generateKDFParameters() {
    return <String, String>{
      'index.html': 'Homepage',
      'robots.txt': 'Hints for web robots',
      'humans.txt': 'We are people, not machines',
    };
  }
}
