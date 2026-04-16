import 'package:frontend/features/receipt/model/expense_model.dart';

class ScanResultModel {
  final String merchant;
  final double totalAmount;
  final DateTime date;
  final String category;
  final List<ExpenseItem> items;
  final String receiptImageUrl;
  ScanResultModel({
    required this.merchant,
    required this.totalAmount,
    required this.date,
    required this.category,
    required this.items,
    required this.receiptImageUrl,
  });

  factory ScanResultModel.fromJson(Map<String, dynamic> json) {
    return ScanResultModel(
      merchant: json['merchant'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      date: DateTime.parse(json['date'] as String),
      category: json['category'] ?? 'other',
      items: (json['items'] as List? ?? [])
          .map((item) => ExpenseItem.fromJson(item))
          .toList(),
      receiptImageUrl: json['receiptImageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'merchant': merchant,
      'totalAmount': totalAmount,
      'date': date.toIso8601String(),
      'category': category,
      'items': items.map((item) => item.toJson()).toList(),
      'receiptImageUrl': receiptImageUrl,
    };
  }

  ScanResultModel copyWith({
    String? merchant,
    double? totalAmount,
    DateTime? date,
    String? category,
    List<ExpenseItem>? items,
    String? receiptImageUrl,
  }) {
    return ScanResultModel(
      merchant: merchant ?? this.merchant,
      totalAmount: totalAmount ?? this.totalAmount,
      date: date ?? this.date,
      category: category ?? this.category,
      items: items ?? this.items,
      receiptImageUrl: receiptImageUrl ?? this.receiptImageUrl,
    );
  }
}
