// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) => AccountModel(
  name: json['name'] as String,
  email: json['email'] as String,
  accessToken: json['accessToken'] as String?,
  organizations:
      (json['organizations'] as List<dynamic>?)
          ?.map(Organization.fromJson)
          .toList() ??
      [],
);

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'accessToken': instance.accessToken,
      'organizations': instance.organizations?.map((e) => e.toJson()).toList(),
    };
