import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import 'package:json_annotation/json_annotation.dart';
import 'package:certify/utils/utils.dart';
part 'env.g.dart';

@JsonSerializable(explicitToJson: true)
class Env {
  final String encryptionKey;

  Env({required this.encryptionKey});

  factory Env.fromJson(json) => _$EnvFromJson((json as Map).cast());
  Map<String, dynamic> toJson() => _$EnvToJson(this);

  /// Loads the env from assets/env.json using rootBundle
  static Future<Env> loadFromAsset() async {
    final jsonString = await rootBundle.loadString('assets/env.json');
    final jsonMap = json.decode(jsonString);
    return Env.fromJson(jsonMap);
  }

  @override
  toString() => HelperUtility().formatJson(toJson());
}
