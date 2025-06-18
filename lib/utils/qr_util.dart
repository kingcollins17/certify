import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrUtil {
  static final _instance = QrUtil._();

  static QrUtil get instance => _instance;
  factory QrUtil() => _instance;

  QrUtil._();

  static Widget basicQr({
    required String data,
    double size = 320,
    bool gapless = false,
    int version = QrVersions.auto,
  }) {
    return QrImageView(
      data: data,
      version: version,
      size: size,
      gapless: gapless,
    );
  }

  /// QR with embedded asset image
  static Widget embeddedImageQr({
    required String data,
    double size = 320,
    String assetPath = 'assets/images/my_embedded_image.png',
    Size embeddedImageSize = const Size(80, 80),
    bool gapless = false,
    int version = QrVersions.auto,
  }) {
    return QrImageView(
      data: data,
      version: version,
      size: size,
      gapless: gapless,
      embeddedImage: AssetImage(assetPath),
      embeddedImageStyle: QrEmbeddedImageStyle(size: embeddedImageSize),
    );
  }

  /// QR with error fallback widget
  static Widget errorHandledQr({
    required String data,
    double size = 320,
    bool gapless = false,
    int version = 1,
    QrErrorBuilder? errorBuilder,
  }) {
    return QrImageView(
      data: data,
      version: version,
      size: size,
      gapless: gapless,
      errorStateBuilder:
          errorBuilder ??
          (context, error) {
            return Container(
              color: Colors.red[100],
              child: const Center(
                child: Text(
                  'Uh oh! Something went wrong...',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            );
          },
    );
  }

  /// 🔥 Generates a PNG image file of the QR code from a string and saves it.
  static Future<File> generateQrImageFile({
    required String data,
    double size = 300.0,
    int version = QrVersions.auto,
  }) async {
    final qrValidationResult = QrValidator.validate(
      data: data,
      version: version,
      errorCorrectionLevel: QrErrorCorrectLevel.Q,
    );

    if (qrValidationResult.status != QrValidationStatus.valid) {
      throw Exception('Invalid QR Data');
    }

    final qrCode = qrValidationResult.qrCode!;
    final painter = QrPainter.withQr(
      qr: qrCode,
      color: const Color(0xFF000000),
      emptyColor: const Color(0xFFFFFFFF),
      gapless: true,
    );

    // Render to image
    final picData = await painter.toImageData(size);
    if (picData == null) throw Exception('Failed to generate image data');

    final buffer = picData.buffer.asUint8List();

    // Save to file
    final directory = await getApplicationDocumentsDirectory();
    final filePath =
        '${directory.path}/qr_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File(filePath);
    await file.writeAsBytes(buffer);

    return file;
  }
}
