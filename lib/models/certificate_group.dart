import 'package:flutter/material.dart'; // for Color
import 'package:json_annotation/json_annotation.dart';
import 'certificate.dart';
import '../utils/helper_utility.dart';

part 'certificate_group.g.dart';

@JsonSerializable(explicitToJson: true)
class CertificateGroup {
  final String id;
  final String groupName;

  @JsonKey(defaultValue: [])
  final List<Certificate> certificates;

  final DateTime? createdAt;

  /// New field to store hex color
  final int? hex;

  CertificateGroup({
    required this.id,
    required this.groupName,
    required this.certificates,
    this.createdAt,
    this.hex,
  });

  /// Getter to return a Flutter Color object
  Color? get color => hex != null ? Color(hex!) : null;

  factory CertificateGroup.fromJson(json) {
    return _$CertificateGroupFromJson((json as Map).cast());
  }

  Map<String, dynamic> toJson() => _$CertificateGroupToJson(this);

  @override
  String toString() => HelperUtility().formatJson(toJson());

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CertificateGroup &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
