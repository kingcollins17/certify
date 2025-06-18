import 'dart:io';
import 'package:qr_code_tools/qr_code_tools.dart';

/// Interface
abstract class QRCodeScannerUtil {
  static QRCodeScannerUtil? _instance;

  static QRCodeScannerUtil get instance {
    _instance ??= QRCodeScannerUtilImpl._internal();
    return _instance!;
  }

  /// Scans a QR code from an image file (e.g. picked from gallery)
  Future<String?> scanFromImage(File image);
}

/// Singleton implementation
class QRCodeScannerUtilImpl implements QRCodeScannerUtil {
  static QRCodeScannerUtilImpl? _instance;

  QRCodeScannerUtilImpl._internal();

  static QRCodeScannerUtilImpl get instance {
    _instance ??= QRCodeScannerUtilImpl._internal();
    return _instance!;
  }

  @override
  Future<String?> scanFromImage(File image) async {
    final result = await QrCodeToolsPlugin.decodeFrom(image.path);
    return result;
  }
}
