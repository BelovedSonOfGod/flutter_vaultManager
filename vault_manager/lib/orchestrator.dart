//Orchestrates storage layer, security layer and domain layer for UI to use
//import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
import 'dart:typed_data';
import 'package:vault_manager/domain_layer/vaultcreation.dart';
import 'package:vault_manager/security_layer/createsecurity.dart';
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
  Uint8List? _encryptionKey;
  static Orchestrator? orchestratorObject;

  Orchestrator._(this._storageObject, this._encryptionKey);

  static Future<Orchestrator> getInstance() async {
    if (orchestratorObject == null) {
      final VaultStorageClass vault = await VaultStorageClass.init();
      final orchestratorObjectLocal = Orchestrator._(vault, null);
      orchestratorObjectLocal.currentstate = AppStates.needsInitialization;
      orchestratorObject = orchestratorObjectLocal;
    }

    return orchestratorObject!;
  }

  Future<AppStates> initialize() async {
    try {
      final bool vaultExists = await _storageObject.fileExists(
        _storageObject.giveVaultNameReferece(),
      );

      if (!vaultExists) {
        currentstate = AppStates.needsSetup;
      } else {
        currentstate = AppStates.needsUnlock;
      }
    } catch (e) {
      currentstate = AppStates.error;
    }

    return currentstate;
  }

  Future<AppStates> createVault(String password) async {
    //salt : Random number generated at the vault creation and each time the vault is encrypted
    //nonce: Random number at the vault creation
    //KDF parameters needed to derive the master password and then with that, encrypt the vault. Also known as metadata
    if (currentstate != AppStates.needsSetup) {
      return AppStates.error;
    }
    String salt = CreateSecurity.generateRandomNumber();
    String nonce = CreateSecurity.generateRandomNumber();
    Map<String, String> plainTextPayload = {};
    Map<String, dynamic> kdfParameters = CreateSecurity.generateKDFParameters();
    kdfParameters["salt"] = salt;

    Uint8List derivedKey = CreateSecurity.deriveKey(
      password,
      salt,
      kdfParameters,
    );
    String ciphertext = CreateSecurity.encrypt(
      plainTextPayload,
      derivedKey,
      nonce,
    );

    Map<String, String> payload = {"nonce": nonce, "ciphertext": ciphertext};

    Map<String, dynamic> vaultJSON = VaultCreation.createVaultFileStructure(
      kdfParameters,
      payload,
    );
    await _storageObject.writeRawFileBytes(
      _storageObject.giveVaultNameReferece(),
      VaultCreation.convertMapToUInt8List(vaultJSON),
    );

    currentstate = AppStates.needsUnlock;

    return currentstate;
  }

  Future<AppStates> unlockVault(String receivedPasswordFrmUsr) async {
    if (currentstate != AppStates.needsUnlock) {
      return AppStates.error;
    }

    //Read vault contents

    Uint8List rawFileContents = await _storageObject.readRawFileBytes(
      _storageObject.giveVaultNameReferece(),
    );

    //Parse the data
    String stringFileContents = VaultCreation.convertUInt8ListToString(
      rawFileContents,
    );
    Map<String, dynamic> fileStructure = VaultCreation.readVaultFileStructure(
      stringFileContents,
    );

    //Get the metadata

    Map<String, dynamic> mapMetadata = VaultCreation.convertStringToMapStrDyn(
      fileStructure["metadata"],
    );

    //desencrypt and recalculate the match between passwords

    Uint8List derivedKey = CreateSecurity.deriveKey(
      receivedPasswordFrmUsr,
      mapMetadata["salt"],
      mapMetadata,
    );

    //Get the payload/passwords information

    _encryptionKey = CreateSecurity.desencrypt(
      mapMetadata["payload"],
      derivedKey,
    );

    return AppStates.error;
  }
}
