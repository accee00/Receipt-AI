class ExpenseModel {
  final String id;
  final String merchant;
  final double totalAmount;
  final List<ExpenseItem> items;
  final DateTime date;
  final String category;
  final String? description;
  final String? notes;
  final String? receiptImage;

  ExpenseModel({
    required this.id,
    required this.merchant,
    required this.totalAmount,
    required this.items,
    required this.date,
    required this.category,
    this.description,
    this.notes,
    this.receiptImage,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['_id'] ?? '',
      merchant: json['merchant'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      items: (json['items'] as List? ?? [])
          .map((item) => ExpenseItem.fromJson(item))
          .toList(),
      date: DateTime.parse(json['date']),
      category: json['category'] ?? 'other',
      description: json['description'],
      notes: json['notes'],
      receiptImage: json['receiptImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'merchant': merchant,
      'totalAmount': totalAmount,
      'items': items.map((item) => item.toJson()).toList(),
      'date': date.toIso8601String(),
      'category': category,
      'description': description,
      'notes': notes,
      'receiptImage': receiptImage,
    };
  }
}

class ExpenseItem {
  final String name;
  final double amount;

  ExpenseItem({required this.name, required this.amount});

  factory ExpenseItem.fromJson(Map<String, dynamic> json) {
    return ExpenseItem(
      name: json['name'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'amount': amount};
  }
}
