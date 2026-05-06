import 'package:frontend/features/receipt/model/expense_model.dart';

class AiInsightsModel {
  final String insights;
  final List<ExpenseModel> expenses;

  AiInsightsModel({
    required this.insights,
    required this.expenses,
  });

  factory AiInsightsModel.fromJson(Map<String, dynamic> json) {
    return AiInsightsModel(
      insights: json['insights'] ?? '',
      expenses: (json['expenses'] as List? ?? [])
          .map((e) => ExpenseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
