import 'package:flutter/material.dart';
import 'package:certify/utils/colors.dart';

mixin AppSnackbar {
  void showSuccess(BuildContext context, String message) {
    _show(context, message, backgroundColor: AppColors.success);
  }

  void showError(BuildContext context, String message) {
    _show(context, message, backgroundColor: AppColors.error);
  }

  void showInfo(BuildContext context, String message) {
    _show(context, message, backgroundColor: AppColors.textSecondary);
  }

  void _show(
    BuildContext context,
    String message, {
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
