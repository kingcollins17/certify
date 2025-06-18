abstract interface class StorageService {
  void save(value);
}

class FirebaseStorage extends StorageService {
  @override
  void save(value) {}
}

class DeviceStorageService implements StorageService {
  @override
  void save(value) {}
}

class NoInterfaceStorageService {
  void saveSomething(something) {}
}
