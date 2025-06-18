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

  Certificate({
    required this.id,
    required this.title,
    required this.issuedAt,
    required this.issuer,
    required this.owner,
    this.fileUrl,
  });

  factory Certificate.fromJson(Map<String, dynamic> json) =>
      _$CertificateFromJson(json);

  Map<String, dynamic> toJson() => _$CertificateToJson(this);

  @override
  String toString() => HelperUtility().formatJson(toJson());
}

@JsonSerializable()
class Issuer {
  final String id;
  final String name;

  Issuer({required this.id, required this.name});

  factory Issuer.fromJson(Map<String, dynamic> json) => _$IssuerFromJson(json);

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

  factory CertificateOwner.fromJson(Map<String, dynamic> json) =>
      _$CertificateOwnerFromJson(json);

  Map<String, dynamic> toJson() => _$CertificateOwnerToJson(this);

  @override
  String toString() => HelperUtility().formatJson(toJson());
}
