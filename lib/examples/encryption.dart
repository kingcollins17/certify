import 'package:encrypt/encrypt.dart' as encrypt;

final key = encrypt.Key.fromUtf8('my 32 length key................');
final iv = encrypt.IV.fromLength(16); // usually 16 bytes for AES

final encrypter = encrypt.Encrypter(
  encrypt.AES(key, mode: encrypt.AESMode.cbc),
);

final encrypted = encrypter.encrypt('hello', iv: iv);
final decrypted = encrypter.decrypt(encrypted, iv: iv);
