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

class _ReceptScreenState extends ConsumerState<ReceptScreen> {
  String _selectedCategory = 'All';
  int _selectedMonth = DateTime.now().month;
  final int _selectedYear = DateTime.now().year;

  final TextEditingController _merchantSearchController =
      TextEditingController();
  final TextEditingController _priceFilterController = TextEditingController();

  final List<String> _categories = [
    'All',
    'food',
    'transport',
    'shopping',
    'health',
    'entertainment',
    'utilities',
    'travel',
    'other',
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

  @override
  void dispose() {
    _merchantSearchController.dispose();
    _priceFilterController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    ref
        .read(expenseViewModelProvider.notifier)
        .filterExpenses(
          category: _selectedCategory == 'All' ? null : _selectedCategory,
          month: _selectedMonth,
          year: _selectedYear,
          merchant: _merchantSearchController.text.trim().isEmpty
              ? null
              : _merchantSearchController.text.trim(),
          amount: double.tryParse(_priceFilterController.text.trim()),
        );
  }

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
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),

      body: Column(
        children: [
          // Filter Panel
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: Column(
              children: [
                // Merchant & Price Search
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _merchantSearchController,
                        onChanged: (_) => _applyFilters(),
                        decoration: InputDecoration(
                          hintText: 'Search Merchant...',
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            size: 20,
                          ),
                          filled: true,
                          fillColor: isDark ? AppColors.darkCard : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _priceFilterController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _applyFilters(),
                        decoration: InputDecoration(
                          hintText: 'Price',
                          prefixIcon: const Icon(
                            Icons.attach_money_rounded,
                            size: 20,
                          ),
                          filled: true,
                          fillColor: isDark ? AppColors.darkCard : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Month Picker
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      final isSelected = _selectedMonth == index + 1;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(_months[index]),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedMonth = index + 1);
                              _applyFilters();
                            }
                          },
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : (isDark ? Colors.white70 : Colors.black87),
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          backgroundColor: isDark
                              ? AppColors.darkCard
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.primary
                                  : (isDark
                                        ? AppColors.darkBorder
                                        : AppColors.lightBorder),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),

                // Category Toolbar
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          selected: isSelected,
                          label: Text(
                            category[0].toUpperCase() + category.substring(1),
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? Colors.white70 : Colors.black87),
                              fontSize: 12,
                            ),
                          ),
                          onSelected: (selected) {
                            setState(() => _selectedCategory = category);
                            _applyFilters();
                          },
                          selectedColor: AppColors.primary,
                          checkmarkColor: Colors.white,
                          backgroundColor: isDark
                              ? AppColors.darkCard
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.primary
                                  : (isDark
                                        ? AppColors.darkBorder
                                        : AppColors.lightBorder),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Expense List
          Expanded(
            child: expensesAsync.when(
              data: (expenses) {
                if (expenses.isEmpty) {
                  return _buildEmptyState(context);
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: isDark
                            ? Border.all(color: AppColors.darkBorder)
                            : null,
                        boxShadow: [
                          if (!isDark)
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getCategoryIcon(expense.category),
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  expense.merchant,
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat(
                                    'MMM dd, yyyy',
                                  ).format(expense.date),
                                  style: textTheme.bodySmall?.copyWith(
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '\$${expense.totalAmount.toStringAsFixed(2)}',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text(
                  'Error: $err',
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant_rounded;
      case 'transport':
        return Icons.directions_car_rounded;
      case 'shopping':
        return Icons.shopping_bag_rounded;
      case 'health':
        return Icons.health_and_safety_rounded;
      case 'entertainment':
        return Icons.local_movies_rounded;
      case 'utilities':
        return Icons.power_rounded;
      case 'travel':
        return Icons.flight_takeoff_rounded;
      default:
        return Icons.more_horiz_rounded;
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = context.isDark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_rounded,
            size: 64,
            color: isDark ? AppColors.darkTextHint : AppColors.lightTextHint,
          ),
          const SizedBox(height: 16),
          Text(
            'No matches found',
            style: context.textTheme.titleMedium?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or search terms.',
            style: context.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
