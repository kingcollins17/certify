// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificate_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CertificateGroup _$CertificateGroupFromJson(Map<String, dynamic> json) =>
    CertificateGroup(
      id: json['id'] as String,
      groupName: json['groupName'] as String,
      certificates:
          (json['certificates'] as List<dynamic>?)
              ?.map(Certificate.fromJson)
              .toList() ??
          [],
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
      hex: (json['hex'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CertificateGroupToJson(CertificateGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupName': instance.groupName,
      'certificates': instance.certificates.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'hex': instance.hex,
    };
