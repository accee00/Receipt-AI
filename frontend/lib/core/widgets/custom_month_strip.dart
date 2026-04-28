import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/build_extension.dart';

final List<String> _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

class CustomMonthStrip extends StatelessWidget {
  final int selectedMonth;
  final ValueChanged<int> onChanged;
  final EdgeInsets? padding;
  const CustomMonthStrip({
    super.key,
    required this.selectedMonth,
    required this.onChanged,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 12,
        itemBuilder: (context, index) {
          final isSelected = selectedMonth == index + 1;
          return GestureDetector(
            onTap: () => onChanged(index + 1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.primaryGradient : null,
                color: isSelected
                    ? null
                    : (isDark ? AppColors.darkCard : Colors.white),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                _months[index],
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.white54 : Colors.black45),
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 13,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
