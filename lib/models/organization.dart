import 'package:json_annotation/json_annotation.dart';

import '../utils/utils.dart';

part 'organization.g.dart';

@JsonSerializable(explicitToJson: true)
class Organization {
  final String id;
  final String name;
  final String? websiteUrl;
  final String? logoUrl;
  final DateTime? createdAt;

  Organization({
    required this.id,
    required this.name,
    this.websiteUrl,
    this.logoUrl,
    this.createdAt,
  });

  factory Organization.fromJson(json) {
    return _$OrganizationFromJson((json as Map).cast());
  }

  Map<String, dynamic> toJson() => _$OrganizationToJson(this);

  @override
  toString() => HelperUtility().formatJson(toJson());
}
