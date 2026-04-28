import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/build_extension.dart';
import 'package:frontend/core/utils/common_utils.dart';
import 'package:frontend/core/widgets/custom_dialog.dart';
import 'package:frontend/core/widgets/custom_month_strip.dart';
import 'package:frontend/features/receipt/view/presentation/ai_insights_screen.dart';
import 'package:frontend/features/receipt/view/widget/custom_expense_card.dart';
import 'package:frontend/features/receipt/view/widget/custom_filter_tab.dart';
import 'package:frontend/features/receipt/view/widget/custom_search_bar.dart';
import 'package:frontend/features/receipt/viewmodel/expense_view_model.dart';

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
        title: Text(
          'Expenses',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [_aiInsightsButton(textTheme), const SizedBox(width: 16)],
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: CustomSearchBar(
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

          Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 2),
            child: CustomMonthStrip(
              selectedMonth: _selectedMonth,
              onChanged: (m) {
                setState(() => _selectedMonth = m);
                _applyFilters();
              },
            ),
          ),

          FadeTransition(
            opacity: _filterFadeAnim,
            child: SlideTransition(
              position: _filterSlideAnim,
              child: _showFilters
                  ? CustomFilterTab(
                      isDark: isDark,
                      categories: _categories,
                      categoryMeta: CommonUtils.categoryMeta,
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
                  data: (expenses) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${expenses.length} total',
                      style: textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

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
                        CommonUtils.categoryMeta[capitalize(
                          expense.category,
                        )] ??
                        CommonUtils.categoryMeta['Other']!;
                    return Slidable(
                      key: ValueKey(expense.id),
                      endActionPane: ActionPane(
                        motion: const BehindMotion(),
                        extentRatio: 0.4,
                        children: [
                          CustomSlidableAction(
                            onPressed: (context) {},
                            backgroundColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                            child: Icon(
                              Icons.edit_note_rounded,
                              color: AppColors.primary,
                              size: 22,
                            ),
                          ),
                          CustomSlidableAction(
                            onPressed: (context) {
                              _showDeleteConfirmation(context, expense.id);
                            },
                            backgroundColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                            child: Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.redAccent,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                      child: CustomExpenseCard(
                        key: ValueKey('expense-${expense.id}'),
                        expense: expense,
                        isDark: isDark,
                        textTheme: textTheme,
                        accentColor: meta.$2,
                        icon: meta.$1,
                      ),
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

  void _showDeleteConfirmation(BuildContext ctx, String id) {
    showDialog(
      context: ctx,
      builder: (context) => CustomDialog(
        title: 'Delete Expense?',
        content: 'This action cannot be undone.',
        cancelText: 'Cancel',
        confirmText: 'Delete',
        onCancel: () => Navigator.pop(context),
        onConfirm: () {
          // ref.read(expenseViewModelProvider.notifier).deleteExpense(id);
        },
      ),
    );
  }

  GestureDetector _aiInsightsButton(TextTheme textTheme) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AiInsightsScreen(month: _selectedMonth, year: _selectedYear),
          ),
        );
      },
      child: Container(
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
