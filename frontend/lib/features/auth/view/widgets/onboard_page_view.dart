import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/build_extension.dart';
import 'package:frontend/features/auth/view/widgets/onboard_page.dart';

class OnboardPageView extends StatelessWidget {
  final OnboardPage page;
  final Animation<double> iconAnimation;
  final bool isDark;

  const OnboardPageView({
    super.key,
    required this.page,
    required this.iconAnimation,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: iconAnimation,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    page.accentColor.withValues(alpha: isDark ? 0.25 : 0.18),
                    page.accentColor.withValues(alpha: 0.0),
                  ],
                ),
                border: Border.all(
                  color: page.accentColor.withValues(alpha: 0.25),
                  width: 1.5,
                ),
              ),
              child: Icon(page.icon, size: 80, color: page.accentColor),
            ),
          ),
          const SizedBox(height: 48),

          Text(
            page.title,
            textAlign: TextAlign.center,
            style: context.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 20),

          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyLarge?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }
}
