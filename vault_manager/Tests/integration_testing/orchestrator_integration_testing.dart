import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:vault_manager/orchestrator.dart';
import 'package:vault_manager/storage_layer/vault_storage_class.dart';

late Orchestrator testingOrchestrator;
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    testingOrchestrator = await Orchestrator.getInstance();
  });

  test("Create vault", () async {
    AppStates state = await testingOrchestrator.initialize();
    state = await testingOrchestrator.createVault();
    expect(state, equals(AppStates.needsUnlock));
  });
}
