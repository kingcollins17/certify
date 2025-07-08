import 'package:hive/hive.dart';

abstract class LocalStorageService {
  Future<void> init();

  Future<void> save<T>(String key, T value, dynamic Function(T) serializer);

  T? get<T>(String key, T Function(dynamic) deserializer);

  Future<List<T>> getAll<T>(T Function(dynamic) deserializer); // <-- Added this

  Future<void> delete(String key);

  Future<void> clear();
}

class HiveLocalStorageService implements LocalStorageService {
  final String boxName;
  Box? _box;

  HiveLocalStorageService(this.boxName) {
    init();
  }

  @override
  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      _box = await Hive.openBox(boxName);
    } else {
      _box = Hive.box(boxName);
    }
  }

  Box get _ensureBox {
    if (_box == null) {
      throw Exception('Box $boxName not initialized. Call init() first.');
    }
    return _box!;
  }

  Future<void> _waitTillBoxReady() async {
    if (_box == null) {
      await init();
    }
  }

  @override
  Future<void> save<T>(
    String key,
    T value,
    dynamic Function(T) serializer,
  ) async {
    await _waitTillBoxReady();
    final serialized = serializer(value);
    await _ensureBox.put(key, serialized);
  }

  @override
  T? get<T>(String key, T Function(dynamic) deserializer) {
    final raw = _ensureBox.get(key);
    if (raw == null) return null;
    return deserializer(raw);
  }

  @override
  Future<List<T>> getAll<T>(T Function(dynamic) deserializer) async {
    await _waitTillBoxReady();
    final values = _ensureBox.values;
    return values.map((item) => deserializer(item)).toList();
  }

  @override
  Future<void> delete(String key) async {
    await _waitTillBoxReady();
    await _ensureBox.delete(key);
  }

  @override
  Future<void> clear() async {
    await _waitTillBoxReady();
    await _ensureBox.clear();
  }
}
