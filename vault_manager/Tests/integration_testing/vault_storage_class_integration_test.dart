import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:vault_manager/storage_layer/vault_storage_class.dart';

late VaultStorageClass myVaultTest;
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    myVaultTest = await VaultStorageClass.init();
  });

  test("App data directory should not be null", () {
    expect(myVaultTest.appDataDirectory, isNotNull);
  });

  test("App data directory should not be empty", () {
    expect(myVaultTest.appDataDirectory, isNotEmpty);
  });

  test("Print app data directory for debugging", () {
    print("App data directory: ${myVaultTest.appDataDirectory}");
    expect(myVaultTest.appDataDirectory, isNotEmpty);
  });

  group("File testing", () {
    test("Write a file", () async {
      //Data to be initialized
      String expectedFileContent = "hola mundo!!";
      String filePathToUse = "${myVaultTest.appDataDirectory}/filetest.txt";
      //File operations
      List<int> listofCharacters = utf8.encode(expectedFileContent);
      Uint8List listofuint = Uint8List.fromList(listofCharacters);
      await myVaultTest.writeRawFileBytes(
        //without this await the program keeps going on
        filePathToUse,
        listofuint,
      );
      Uint8List fileContents = await myVaultTest.readRawFileBytes(
        filePathToUse,
      );
      expect(fileContents, equals(utf8.encode(expectedFileContent)));
      expect(await myVaultTest.fileExists(filePathToUse), isTrue);
    });
  });
}
