import 'package:json_annotation/json_annotation.dart';
import 'certificate.dart';
import '../utils/helper_utility.dart';

part 'certificate_group.g.dart';

@JsonSerializable(explicitToJson: true)
class CertificateGroup {
  final String groupName;

  @JsonKey(defaultValue: [])
  final List<Certificate> certificates;

  final DateTime? createdAt;

  CertificateGroup({
    required this.groupName,
    required this.certificates,
    this.createdAt,
  });

  factory CertificateGroup.fromJson(json) {
    return _$CertificateGroupFromJson((json as Map).cast());
  }

  Map<String, dynamic> toJson() => _$CertificateGroupToJson(this);

  @override
  String toString() => HelperUtility().formatJson(toJson());
}
