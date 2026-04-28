import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/build_extension.dart';

class CustomFilterTab extends StatelessWidget {
  final bool isDark;
  final List<String> categories;
  final Map<String, (IconData, Color)> categoryMeta;
  final String selectedCategory;
  final TextEditingController priceController;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onPriceChanged;

  const CustomFilterTab({
    super.key,
    required this.isDark,
    required this.categories,
    required this.categoryMeta,
    required this.selectedCategory,
    required this.priceController,
    required this.onCategoryChanged,
    required this.onPriceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PanelLabel(label: 'Max Amount', isDark: isDark),
          const SizedBox(height: 8),
          TextField(
            controller: priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: onPriceChanged,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white : Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: 'e.g. 500',
              hintStyle: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white30 : Colors.black38,
              ),
              prefixIcon: Icon(
                Icons.attach_money_rounded,
                size: 18,
                color: isDark ? Colors.white30 : Colors.black38,
              ),
              filled: true,
              fillColor: isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : AppColors.lightBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              isDense: true,
            ),
          ),

          const SizedBox(height: 16),

          _PanelLabel(label: 'Category', isDark: isDark),
          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((cat) {
              final isSelected = selectedCategory == cat;
              final meta = categoryMeta[cat] ?? categoryMeta['Other']!;
              final accent = meta.$2;
              final icon = meta.$1;

              return GestureDetector(
                onTap: () => onCategoryChanged(cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? accent.withValues(alpha: 0.15)
                        : (isDark
                              ? Colors.white.withValues(alpha: 0.04)
                              : AppColors.lightBackground),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? accent
                          : (isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        size: 14,
                        color: isSelected
                            ? accent
                            : (isDark ? Colors.white38 : Colors.black38),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        cat,
                        style: TextStyle(
                          color: isSelected
                              ? accent
                              : (isDark ? Colors.white60 : Colors.black54),
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _PanelLabel extends StatelessWidget {
  final String label;
  final bool isDark;

  const _PanelLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(label.toUpperCase(), style: context.textTheme.titleSmall);
  }
}
