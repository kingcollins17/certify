import 'dart:async';

import 'package:encrypt/encrypt.dart' as enc;
import '../models/env.dart';

abstract class EncryptUtil {
  static Env? _env;
  static EncryptUtil? _instance;

  static Future<EncryptUtil> get instance async {
    _env ??= await Env.loadFromAsset();
    _instance ??= AesEncryptUtil.fromEnv(_env!);
    return _instance!;
  }

  String encrypt(String plainText);
  String decrypt(String encryptedText);
}

class AesEncryptUtil implements EncryptUtil {
  final enc.Encrypter _encrypter;

  AesEncryptUtil._(this._encrypter);

  factory AesEncryptUtil.fromEnv(Env env) {
    final key = enc.Key.fromBase16(env.encryptionKey);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    return AesEncryptUtil._(encrypter);
  }

  @override
  String encrypt(String plainText) {
    final iv = enc.IV.fromSecureRandom(16);
    final encrypted = _encrypter.encrypt(plainText, iv: iv);

    final result = '${iv.base64}:${encrypted.base64}';
    return result;
  }

  @override
  String decrypt(String encryptedText) {
    final parts = encryptedText.split(':');
    if (parts.length != 2) throw FormatException('Invalid encrypted format');

    final iv = enc.IV.fromBase64(parts[0]);
    final encrypted = parts[1];

    return _encrypter.decrypt64(encrypted, iv: iv);
  }
}
