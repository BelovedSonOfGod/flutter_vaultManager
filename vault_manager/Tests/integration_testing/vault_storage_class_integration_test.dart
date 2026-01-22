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
}
