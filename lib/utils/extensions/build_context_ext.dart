import 'package:flutter/material.dart';
import '../ui_helper_util.dart';

extension on BuildContext {
  void showSuccess(String message) {
    UiHelperUtil().showSuccess(this, message);
  }

  void showError(String message) {
    UiHelperUtil().showError(this, message);
  }

  void showInfo(String message) {
    UiHelperUtil().showInfo(this, message);
  }
}
