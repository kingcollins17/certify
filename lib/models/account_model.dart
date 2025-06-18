import 'package:json_annotation/json_annotation.dart';
import 'organization.dart';
part 'account_model.g.dart';

typedef Account = AccountModel;

@JsonSerializable(explicitToJson: true)
class AccountModel {
  final String name;
  final String email;
  final String? accessToken; // Optional: null for email/password sign-ins

  @JsonKey(defaultValue: [])
  final List<Organization>? organizations;

  AccountModel({
    required this.name,
    required this.email,
    this.accessToken,
    this.organizations,
  });

  factory AccountModel.fromJson(json) {
    return _$AccountModelFromJson((json as Map).cast());
  }

  Map<String, dynamic> toJson() => _$AccountModelToJson(this);
}
