import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isDark;
  final ValueChanged<String> onChanged;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: TextStyle(
        fontSize: 14,
        color: isDark ? Colors.white : Colors.black87,
      ),
      decoration: InputDecoration(
        hintText: 'Search merchant...',
        hintStyle: TextStyle(
          fontSize: 13.5,
          color: isDark ? Colors.white30 : Colors.black38,
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          size: 20,
          color: isDark ? Colors.white30 : Colors.black38,
        ),
        suffixIcon: ValueListenableBuilder(
          valueListenable: controller,
          builder: (_, val, _) => val.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    controller.clear();
                    onChanged('');
                  },
                  child: Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                )
              : const SizedBox.shrink(),
        ),
        filled: true,
        fillColor: isDark ? AppColors.darkCard : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        isDense: true,
      ),
    );
  }
}
