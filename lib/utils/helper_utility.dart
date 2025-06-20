import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'package:intl/intl.dart'; // Add this import at the top

class HelperUtility {
  HelperUtility._internal();

  static final HelperUtility _instance = HelperUtility._internal();

  factory HelperUtility() => _instance;

  final ImagePicker _picker = ImagePicker();
  final Uuid _uuid = Uuid();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? password) {
    final value = password;
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void log(value) {
    if (kDebugMode) {
      debugPrint(value.toString());
    }
  }

  String formatJson(json) => JsonEncoder.withIndent(' ').convert(json);

  /// Picks an image from the specified source (camera or gallery)
  Future<File?> pickImage({ImageSource source = ImageSource.gallery}) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  /// Generates a UUID v4 string
  String generateUuid4() => _uuid.v4();

  /// Formats DateTime to something like "Dec 15, 2024"
  String formatDate(DateTime date) {
    return DateFormat('MMM d, y').format(date);
  }
}
