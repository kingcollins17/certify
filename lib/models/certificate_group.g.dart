// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificate_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CertificateGroup _$CertificateGroupFromJson(Map<String, dynamic> json) =>
    CertificateGroup(
      groupName: json['groupName'] as String,
      certificates:
          (json['certificates'] as List<dynamic>?)
              ?.map((e) => Certificate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CertificateGroupToJson(CertificateGroup instance) =>
    <String, dynamic>{
      'groupName': instance.groupName,
      'certificates': instance.certificates.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };
