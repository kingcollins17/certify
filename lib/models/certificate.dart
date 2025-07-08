import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../utils/utils.dart';
part 'certificate.g.dart';

@JsonSerializable(explicitToJson: true)
class Certificate {
  final String id;
  final String title;
  final DateTime issuedAt;
  final Issuer issuer;
  final CertificateOwner owner;
  final String? fileUrl;
  final String? qrCodeUrl;
  final String? groupId;

  Certificate({
    required this.id,
    required this.title,
    required this.issuedAt,
    required this.issuer,
    required this.owner,
    this.groupId,
    this.fileUrl,
    this.qrCodeUrl,
  });

  factory Certificate.fromJson(json) {
    return _$CertificateFromJson((json as Map).cast());
  }

  Map<String, dynamic> toJson() => _$CertificateToJson(this);

  Certificate copyWith({
    String? id,
    String? title,
    DateTime? issuedAt,
    Issuer? issuer,
    CertificateOwner? owner,
    String? fileUrl,
    String? qrCodeUrl,
    String? groupId,
  }) {
    return Certificate(
      id: id ?? this.id,
      title: title ?? this.title,
      issuedAt: issuedAt ?? this.issuedAt,
      issuer: issuer ?? this.issuer,
      owner: owner ?? this.owner,
      fileUrl: fileUrl ?? this.fileUrl,
      qrCodeUrl: qrCodeUrl ?? this.qrCodeUrl,
      groupId: groupId ?? this.groupId,
    );
  }

  Future<String> encrypt() async {
    final instance = await EncryptUtil.instance;
    return instance.encrypt(HelperUtility().formatJson(toJson()));
  }

  static Future<String> _decrypt(String value) async {
    final instance = await EncryptUtil.instance;
    return instance.decrypt(value);
  }

  static Future<Certificate> decrypt(String value) async {
    final data = await _decrypt(value);
    return Certificate.fromJson(json.decode(data));
  }

  Future<Widget> generateQRCode({double size = 48}) async {
    return QrUtil.basicQr(data: await encrypt(), size: size);
  }

  Future<File> generateQRCodeFile() async {
    return await QrUtil.generateQrImageFile(
      data: HelperUtility().formatJson(toJson()),
    );
  }

  @override
  String toString() => HelperUtility().formatJson(toJson());
}

@JsonSerializable()
class Issuer {
  final String id;
  final String name;

  Issuer({required this.id, required this.name});

  factory Issuer.fromJson(json) => _$IssuerFromJson((json as Map).cast());

  Map<String, dynamic> toJson() => _$IssuerToJson(this);

  @override
  String toString() => HelperUtility().formatJson(toJson());
}

@JsonSerializable()
@JsonSerializable()
class CertificateOwner {
  final String id;
  final String name;

  CertificateOwner({required this.id, required this.name});

  factory CertificateOwner.fromJson(json) {
    return _$CertificateOwnerFromJson((json as Map).cast());
  }

  Map<String, dynamic> toJson() => _$CertificateOwnerToJson(this);

  @override
  String toString() => HelperUtility().formatJson(toJson());
}

final List<Certificate> mockCertificates = [
  Certificate(
    id: 'cert_001',
    title: 'Flutter Development',
    issuedAt: DateTime(2024, 12, 10),
    issuer: Issuer(id: 'issuer_01', name: 'KodeCamp'),
    owner: CertificateOwner(id: 'user_01', name: 'King Collins'),
    fileUrl: 'https://example.com/flutter_dev_cert.pdf',
  ),
  Certificate(
    id: 'cert_002',
    title: 'Backend Engineering',
    issuedAt: DateTime(2023, 6, 1),
    issuer: Issuer(id: 'issuer_02', name: 'AltSchool Africa'),
    owner: CertificateOwner(id: 'user_02', name: 'Jane Doe'),
    fileUrl: 'https://example.com/backend_cert.pdf',
  ),
  Certificate(
    id: 'cert_003',
    title: 'UI/UX Design',
    issuedAt: DateTime(2022, 11, 22),
    issuer: Issuer(id: 'issuer_03', name: 'Google UX Academy'),
    owner: CertificateOwner(id: 'user_03', name: 'John Smith'),
    fileUrl: null, // maybe no file uploaded yet
  ),
  Certificate(
    id: 'cert_004',
    title: 'Cloud Fundamentals',
    issuedAt: DateTime(2023, 3, 15),
    issuer: Issuer(id: 'issuer_04', name: 'Microsoft Learn'),
    owner: CertificateOwner(id: 'user_04', name: 'Ada Lovelace'),
    fileUrl: 'https://example.com/cloud_fundamentals.pdf',
  ),
  Certificate(
    id: 'cert_005',
    title: 'Cybersecurity Essentials',
    issuedAt: DateTime(2025, 1, 5),
    issuer: Issuer(id: 'issuer_05', name: 'Cisco Networking Academy'),
    owner: CertificateOwner(id: 'user_05', name: 'Elon Test'),
    fileUrl: 'https://example.com/cybersec_cert.pdf',
  ),
];
