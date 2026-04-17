import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/build_extension.dart';
import 'package:frontend/features/receipt/viewmodel/expense_view_model.dart';
import 'package:intl/intl.dart';

class ReceptScreen extends ConsumerStatefulWidget {
  const ReceptScreen({super.key});

  @override
  ConsumerState<ReceptScreen> createState() => _ReceptScreenState();
}

class _ReceptScreenState extends ConsumerState<ReceptScreen>
    with SingleTickerProviderStateMixin {
  String _selectedCategory = 'All';
  int _selectedMonth = DateTime.now().month;
  final int _selectedYear = DateTime.now().year;
  bool _showFilters = false;

  final TextEditingController _merchantSearchController =
      TextEditingController();
  final TextEditingController _priceFilterController = TextEditingController();

  late final AnimationController _filterAnimController;
  late final Animation<double> _filterFadeAnim;
  late final Animation<Offset> _filterSlideAnim;

  final List<String> _categories = [
    'All',
    'Food',
    'Transport',
    'Shopping',
    'Health',
    'Entertainment',
    'Utilities',
    'Travel',
    'Other',
  ];

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

  // Map categories → icons + accent colours
  static const Map<String, (IconData, Color)> _categoryMeta = {
    'All': (Icons.grid_view_rounded, Color(0xFF00BFA5)),
    'Food': (Icons.restaurant_rounded, Color(0xFFFF7043)),
    'Transport': (Icons.directions_car_rounded, Color(0xFF42A5F5)),
    'Shopping': (Icons.shopping_bag_rounded, Color(0xFFAB47BC)),
    'Health': (Icons.favorite_rounded, Color(0xFFEF5350)),
    'Entertainment': (Icons.local_movies_rounded, Color(0xFFFFCA28)),
    'Utilities': (Icons.bolt_rounded, Color(0xFF26C6DA)),
    'Travel': (Icons.flight_takeoff_rounded, Color(0xFF26A69A)),
    'Other': (Icons.more_horiz_rounded, Color(0xFF78909C)),
  };

  @override
  void initState() {
    super.initState();
    _filterAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _filterFadeAnim = CurvedAnimation(
      parent: _filterAnimController,
      curve: Curves.easeOut,
    );
    _filterSlideAnim =
        Tween<Offset>(begin: const Offset(0, -0.08), end: Offset.zero).animate(
          CurvedAnimation(parent: _filterAnimController, curve: Curves.easeOut),
        );
  }

  @override
  void dispose() {
    _merchantSearchController.dispose();
    _priceFilterController.dispose();
    _filterAnimController.dispose();
    super.dispose();
  }

  void _toggleFilters() {
    setState(() => _showFilters = !_showFilters);
    if (_showFilters) {
      _filterAnimController.forward();
    } else {
      _filterAnimController.reverse();
    }
  }

  void _applyFilters() {
    ref
        .read(expenseViewModelProvider.notifier)
        .filterExpenses(
          category: _selectedCategory == 'All'
              ? null
              : _selectedCategory.toLowerCase(),
          month: _selectedMonth,
          year: _selectedYear,
          merchant: _merchantSearchController.text.trim().isEmpty
              ? null
              : _merchantSearchController.text.trim(),
          amount: double.tryParse(_priceFilterController.text.trim()),
        );
  }

  bool get _hasActiveFilters =>
      _selectedCategory != 'All' ||
      _merchantSearchController.text.trim().isNotEmpty ||
      _priceFilterController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textTheme = context.textTheme;
    final expensesAsync = ref.watch(expenseViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Expenses',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          _AiInsightsBadge(textTheme: textTheme),
          const SizedBox(width: 16),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Search + Filter Toggle Row ──────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: _SearchBar(
                    controller: _merchantSearchController,
                    isDark: isDark,
                    onChanged: (_) => _applyFilters(),
                  ),
                ),
                const SizedBox(width: 10),
                _FilterToggleButton(
                  isDark: isDark,
                  isActive: _showFilters,
                  hasActiveFilters: _hasActiveFilters,
                  onTap: _toggleFilters,
                ),
              ],
            ),
          ),

          // ── Month Strip ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 2),
            child: _MonthStrip(
              selectedMonth: _selectedMonth,
              months: _months,
              isDark: isDark,
              onChanged: (m) {
                setState(() => _selectedMonth = m);
                _applyFilters();
              },
            ),
          ),

          // ── Animated Filter Panel ───────────────────────────────
          FadeTransition(
            opacity: _filterFadeAnim,
            child: SlideTransition(
              position: _filterSlideAnim,
              child: _showFilters
                  ? _FilterPanel(
                      isDark: isDark,
                      categories: _categories,
                      categoryMeta: _categoryMeta,
                      selectedCategory: _selectedCategory,
                      priceController: _priceFilterController,
                      onCategoryChanged: (c) {
                        setState(() => _selectedCategory = c);
                        _applyFilters();
                      },
                      onPriceChanged: (_) => _applyFilters(),
                    )
                  : const SizedBox.shrink(),
            ),
          ),

          // ── Results header ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transactions',
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                expensesAsync.maybeWhen(
                  data: (expenses) =>
                      _CountBadge(count: expenses.length, isDark: isDark),
                  orElse: () => const SizedBox.shrink(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ── Expense List ────────────────────────────────────────
          Expanded(
            child: expensesAsync.when(
              data: (expenses) {
                if (expenses.isEmpty) return _buildEmptyState(context);
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    final meta =
                        _categoryMeta[_capitalize(expense.category)] ??
                        _categoryMeta['Other']!;
                    return _ExpenseCard(
                      expense: expense,
                      isDark: isDark,
                      textTheme: textTheme,
                      accentColor: meta.$2,
                      icon: meta.$1,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(
                child: Text(
                  'Error: $err',
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = context.isDark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              size: 38,
              color: isDark ? AppColors.darkTextHint : AppColors.lightTextHint,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No transactions found',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try adjusting your filters or search terms.',
            style: context.textTheme.bodySmall?.copyWith(
              fontSize: 13,
              color: isDark ? AppColors.darkTextHint : AppColors.lightTextHint,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────────

String _capitalize(String s) =>
    s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();

// ── Subwidgets ────────────────────────────────────────────────────────────────

class _AiInsightsBadge extends StatelessWidget {
  final TextTheme textTheme;
  const _AiInsightsBadge({required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.auto_awesome, color: AppColors.primary, size: 15),
          const SizedBox(width: 6),
          Text(
            'AI Insights',
            style: textTheme.labelSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isDark;
  final ValueChanged<String> onChanged;

  const _SearchBar({
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

class _FilterToggleButton extends StatelessWidget {
  final bool isDark;
  final bool isActive;
  final bool hasActiveFilters;
  final VoidCallback onTap;

  const _FilterToggleButton({
    required this.isDark,
    required this.isActive,
    required this.hasActiveFilters,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary
              : (isDark ? AppColors.darkCard : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive
                ? AppColors.primary
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              isActive ? Icons.tune_rounded : Icons.tune_rounded,
              color: isActive
                  ? Colors.white
                  : (isDark ? Colors.white54 : Colors.black54),
              size: 22,
            ),
            if (hasActiveFilters && !isActive)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MonthStrip extends StatelessWidget {
  final int selectedMonth;
  final List<String> months;
  final bool isDark;
  final ValueChanged<int> onChanged;

  const _MonthStrip({
    required this.selectedMonth,
    required this.months,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                months[index],
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

class _FilterPanel extends StatelessWidget {
  final bool isDark;
  final List<String> categories;
  final Map<String, (IconData, Color)> categoryMeta;
  final String selectedCategory;
  final TextEditingController priceController;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onPriceChanged;

  const _FilterPanel({
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
          // Price field
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

          // Category
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
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 10.5,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.1,
        color: isDark ? Colors.white38 : Colors.black38,
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final int count;
  final bool isDark;

  const _CountBadge({required this.count, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$count total',
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ExpenseCard extends StatelessWidget {
  final dynamic expense;
  final bool isDark;
  final TextTheme textTheme;
  final Color accentColor;
  final IconData icon;

  const _ExpenseCard({
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
          // Icon bubble
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

          // Info
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
                    // Category pill
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
                        _capitalize(expense.category),
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

          // Amount
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
