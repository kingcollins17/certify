import 'package:certify/services/storage_service.dart';

FirebaseStorage internet() {
  return FirebaseStorage();
}

DeviceStorageService device() {
  return DeviceStorageService();
}

class AccountsRepository {
  StorageService? _storageService;

  void save(value) {
    if (isInternetConnected()) {
      _storageService = internet();
      _storageService!.save(value);
    } else {
      _storageService = device();
      _storageService!.save(value);
    }
  }

  bool isInternetConnected() {
    return false;
  }
}
