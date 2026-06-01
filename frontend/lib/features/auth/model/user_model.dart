class UserModel {
  final String id;
  final String name;
  final String email;
  final double budgetLimit;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.budgetLimit = 0,
    this.createdAt,
    this.updatedAt,
  });

  bool get needsBudgetSetup => budgetLimit <= 0;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      budgetLimit: (json['budgetLimit'] ?? 0).toDouble(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'budgetLimit': budgetLimit,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    double? budgetLimit,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      budgetLimit: budgetLimit ?? this.budgetLimit,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
