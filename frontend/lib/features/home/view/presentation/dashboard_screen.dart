import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/routes/app_routes.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/utils/build_extension.dart';
import 'package:frontend/core/utils/common_utils.dart';
import 'package:frontend/features/receipt/model/dashboard_model.dart';
import 'package:frontend/features/receipt/view/widget/custom_expense_card.dart';
import 'package:frontend/features/home/viewmodel/dashboard_view_model.dart';
import 'package:frontend/core/widgets/custom_month_strip.dart';
import 'package:frontend/features/home/view/widgets/summary_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedMonth = DateTime.now().month;
  final int _selectedYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textTheme = context.textTheme;
    final dashboardAsync = ref.watch(
      dashboardViewModelProvider(month: _selectedMonth, year: _selectedYear),
    );

    return RefreshIndicator(
      onRefresh: () => ref
          .read(
            dashboardViewModelProvider(
              month: _selectedMonth,
              year: _selectedYear,
            ).notifier,
          )
          .refresh(month: _selectedMonth, year: _selectedYear),
      child: dashboardAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  err.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.error),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (data) =>
            _buildDashboardContent(context, data, textTheme, isDark),
      ),
    );
  }

  Widget _buildDashboardContent(
    BuildContext context,
    DashboardModel data,
    TextTheme textTheme,
    bool isDark,
  ) {
    final highestExpense = data.recentExpenses.isNotEmpty
        ? data.recentExpenses
              .map((e) => e.totalAmount)
              .reduce((a, b) => a > b ? a : b)
        : 0.0;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, User!',
                    style: textTheme.bodyLarge?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your Dashboard',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: const Icon(Icons.person, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 15),

          CustomMonthStrip(
            selectedMonth: _selectedMonth,
            onChanged: (m) {
              setState(() => _selectedMonth = m);
            },
          ),
          const SizedBox(height: 18),

          // Summary Card with real data
          SummaryCard(
            monthlyLimit: data.budgetLimit,
            thisMonthSpend: data.totalExpenses,
            categoriesCount: data.totalCategories,
            itemsCount: data.totalItems,
            highestExpense: highestExpense,
          ),
          const SizedBox(height: 23),

          // AI Insights Section
          GestureDetector(
            onTap: () => context.push(
              AppRoutes.aiInsights,
              extra: AiInsightsRouteArgs(
                month: _selectedMonth,
                year: _selectedYear,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'AI Insights',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Spending Analysis',
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data.aiInsights.isNotEmpty
                            ? data.aiInsights
                            : 'Analyzing your spending habits for ${CommonUtils.months[_selectedMonth - 1]}...',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium?.copyWith(height: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),
          Text(
            'Recent Transactions',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          if (data.recentExpenses.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'No transactions for this month.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppColors.darkTextHint
                        : AppColors.lightTextHint,
                  ),
                ),
              ),
            )
          else
            ...data.recentExpenses.map((expense) {
              final meta =
                  CommonUtils.categoryMeta[capitalize(expense.category)] ??
                  CommonUtils.categoryMeta['Other']!;
              return CustomExpenseCard(
                expense: expense,
                isDark: isDark,
                textTheme: textTheme,
                accentColor: meta.$2,
                icon: meta.$1,
                onTap: () {
                  context.push(AppRoutes.expenseDetail, extra: expense);
                },
              );
            }),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
