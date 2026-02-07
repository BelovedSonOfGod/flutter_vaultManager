//Orchestrates storage layer, security layer and domain layer for UI to use
import 'package:flutter/foundation.dart';
import 'package:vault_manager/storage_layer/vault_storage_class.dart';

enum AppStates {
  //States represent status not action
  uninitialized,
  needsSetup,
  needsUnlock,
  unlocked,
  error,
}

//Singleton because we only want one orchestrator instance
//We have a method called getInstance to only initialize 1 orchestrator and 1 vault always if not null
class Orchestrator {
  final VaultStorageClass _storageObject;
  AppStates currentstate = AppStates.uninitialized;
  static Orchestrator? _orchestratorObject;
  Orchestrator._(this._storageObject);

  static Future<Orchestrator> getInstance() async {
    if (_orchestratorObject == null) {
      final VaultStorageClass vault = await VaultStorageClass.init();
      _orchestratorObject = Orchestrator._(vault);
    }

    return _orchestratorObject!;
  }

  AppStates initialize() {
    return AppStates.needsUnlock;
  }

  AppStates createVault() {}

  AppStates unlockVault() {}
}
