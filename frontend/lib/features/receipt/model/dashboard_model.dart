import 'package:frontend/features/receipt/model/expense_model.dart';

class DashboardModel {
  final double totalExpenses;
  final int totalItems;
  final int totalCategories;
  final int totalMerchants;
  final List<ExpenseModel> recentExpenses;
  final double budgetLimit;
  final String aiInsights;

  DashboardModel({
    required this.totalExpenses,
    required this.totalItems,
    required this.totalCategories,
    required this.totalMerchants,
    required this.recentExpenses,
    required this.budgetLimit,
    required this.aiInsights,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalExpenses: (json['totalExpenses'] ?? 0.0).toDouble(),
      totalItems: json['totalItems'] ?? 0,
      totalCategories: json['totalCategories'] ?? 0,
      totalMerchants: json['totalMerchants'] ?? 0,
      recentExpenses: (json['recentExpense'] as List? ?? [])
          .map((e) => ExpenseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      budgetLimit: (json['budgetLimit'] ?? 0.0).toDouble(),
      aiInsights: json['aiInsights'] ?? '',
    );
  }
}
