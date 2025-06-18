// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Organization _$OrganizationFromJson(Map<String, dynamic> json) => Organization(
  id: json['id'] as String,
  name: json['name'] as String,
  websiteUrl: json['websiteUrl'] as String?,
  logoUrl: json['logoUrl'] as String?,
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$OrganizationToJson(Organization instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'websiteUrl': instance.websiteUrl,
      'logoUrl': instance.logoUrl,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
