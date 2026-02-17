//Orchestrates storage layer, security layer and domain layer for UI to use
import 'package:flutter/foundation.dart';
import 'package:vault_manager/storage_layer/vault_storage_class.dart';

enum AppStates {
  //States represent status not action
  uninitialized,
  needsInitialization,
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
  static Orchestrator? orchestratorObject;
  Orchestrator._(this._storageObject);

  static Future<Orchestrator> getInstance() async {
    if (orchestratorObject == null) {
      final VaultStorageClass vault = await VaultStorageClass.init();
      final orchestratorObjectLocal = Orchestrator._(vault);
      orchestratorObjectLocal.currentstate = AppStates.needsInitialization;
    }

    return orchestratorObject!;
  }

  Future<AppStates> initialize() async {
    if (currentstate != AppStates.needsInitialization) {
      currentstate = AppStates.error;
    } else {
      try {
        final bool vaultExists = await _storageObject.fileExists(
          _storageObject.giveVaultNameReferece(),
        );

        if (vaultExists) {
          currentstate = AppStates.needsSetup;
        } else {
          currentstate = AppStates.needsUnlock;
        }
      } catch (e) {
        currentstate = AppStates.error;
      }
    }

    return currentstate;
  }

  Future<AppStates> createVault() async {
    if (currentstate != AppStates.needsSetup) {
      currentstate = AppStates.error;
    }

    return currentstate;
  }

  AppStates unlockVault() {}
}
