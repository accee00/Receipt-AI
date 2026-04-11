import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';

enum SnackBarType { success, failure }

void showCustomSnackBar({
  required BuildContext context,
  required String message,
  required SnackBarType type,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: type == SnackBarType.success
          ? AppColors.success
          : AppColors.warning,
    ),
  );
}
