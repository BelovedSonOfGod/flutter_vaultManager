import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:vault_manager/Misc/printing_for_debug_class.dart';

class VaultStorageClass {
  final String appDataDirectory;
  static final String vaultNameTemplate = "vault.vau";
  static final String metaDataReference = "metadata.bin";

  VaultStorageClass._(String directoryStringToUse)
    : appDataDirectory = directoryStringToUse;

  static Future<VaultStorageClass> init() async {
    final Directory foundDirectory = await getApplicationSupportDirectory();
    if (!await foundDirectory
        .exists()) //Pauses async to check that Future<bool> has returned the right value and if not the throw exception
    {
      throw ("The app directory was not found!!!");
    }
    return VaultStorageClass.fromFile(foundDirectory.path);
  }

  factory VaultStorageClass.fromFile(String path) {
    return VaultStorageClass._(path);
  }

  String giveVaultNameReferece({String vaultName = "1"}) {
    return "${this.appDataDirectory}/$vaultNameTemplate";
  }

  String giveMetaDataReference({String metaDataName = "1"}) {
    return "${this.appDataDirectory}/$metaDataReference";
  }

  Future<bool> vaultExists() async {
    final File file = File(giveVaultNameReferece());
    return await file.exists();
  }

  Future<Uint8List> readRawFileBytes(String filePath) async {
    File file = File(filePath);
    // readAsBytes() returns a Future<Uint8List> with all bytes at once
    Uint8List bytes = await file.readAsBytes();
    return bytes;
  }

  Future<void> writeRawFileBytes(String filePath, Uint8List dataToWrite) async {
    final File file = File(filePath);
    await file.writeAsBytes(dataToWrite);
  }
}
