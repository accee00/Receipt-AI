import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/build_extension.dart';

class OrDivider extends StatelessWidget {
  final bool isDark;
  const OrDivider({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Row(
      children: [
        Expanded(child: Divider(color: borderColor)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: context.textTheme.bodySmall?.copyWith(color: textColor),
          ),
        ),
        Expanded(child: Divider(color: borderColor)),
      ],
    );
  }
}
