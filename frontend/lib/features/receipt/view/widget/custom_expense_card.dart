import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/common_utils.dart';
import 'package:frontend/features/receipt/model/expense_model.dart';
import 'package:intl/intl.dart';

class CustomExpenseCard extends StatelessWidget {
  final ExpenseModel expense;
  final bool isDark;
  final TextTheme textTheme;
  final Color accentColor;
  final IconData icon;

  const CustomExpenseCard({
    super.key,
    required this.expense,
    required this.isDark,
    required this.textTheme,
    required this.accentColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: isDark
            ? Border.all(color: AppColors.darkBorder)
            : Border.all(color: AppColors.lightBorder.withValues(alpha: 0.6)),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accentColor, size: 22),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.merchant,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2.5,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        capitalize(expense.category),
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 10,
                      color: isDark
                          ? AppColors.darkTextHint
                          : AppColors.lightTextHint,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      DateFormat('MMM d, yyyy').format(expense.date),
                      style: textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.darkTextHint
                            : AppColors.lightTextHint,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${expense.totalAmount.toStringAsFixed(2)}',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
              if (expense.items.isNotEmpty)
                Text(
                  '${expense.items.length} item${expense.items.length == 1 ? '' : 's'}',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: isDark
                        ? AppColors.darkTextHint
                        : AppColors.lightTextHint,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
