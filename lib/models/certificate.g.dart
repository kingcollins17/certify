// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Certificate _$CertificateFromJson(Map<String, dynamic> json) => Certificate(
  id: json['id'] as String,
  title: json['title'] as String,
  issuedAt: DateTime.parse(json['issuedAt'] as String),
  issuer: Issuer.fromJson(json['issuer']),
  owner: CertificateOwner.fromJson(json['owner']),
  groupId: json['groupId'] as String?,
  fileUrl: json['fileUrl'] as String?,
  qrCodeUrl: json['qrCodeUrl'] as String?,
);

Map<String, dynamic> _$CertificateToJson(Certificate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'issuedAt': instance.issuedAt.toIso8601String(),
      'issuer': instance.issuer.toJson(),
      'owner': instance.owner.toJson(),
      'fileUrl': instance.fileUrl,
      'qrCodeUrl': instance.qrCodeUrl,
      'groupId': instance.groupId,
    };

Issuer _$IssuerFromJson(Map<String, dynamic> json) =>
    Issuer(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$IssuerToJson(Issuer instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
};

CertificateOwner _$CertificateOwnerFromJson(Map<String, dynamic> json) =>
    CertificateOwner(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$CertificateOwnerToJson(CertificateOwner instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
