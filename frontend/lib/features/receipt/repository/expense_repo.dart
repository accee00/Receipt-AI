import 'package:dio/dio.dart';

import 'package:frontend/core/di/riverpod_di.dart';
import 'package:frontend/core/network/dio_client.dart';
import 'package:frontend/core/utils/api_response.dart';
import 'package:frontend/core/utils/failure.dart';
import 'package:frontend/features/receipt/model/expense_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fpdart/fpdart.dart';

part 'expense_repo.g.dart';

@riverpod
ExpenseRepo expenseRepo(Ref ref) {
  return ExpenseRepo(dioClient: ref.watch(dioClientProvider));
}

class ExpenseRepo {
  final DioClient dioClient;

  ExpenseRepo({required this.dioClient});

  Future<Either<Failure, List<ExpenseModel>>> getFilteredExpenses({
    int? month,
    int? year,
    String? category,
    String? merchant,
    double? amount,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (month != null) queryParameters['month'] = month;
      if (year != null) queryParameters['year'] = year;
      if (category != null && category != 'All') {
        queryParameters['category'] = category;
      }
      if (merchant != null && merchant.isNotEmpty) {
        queryParameters['merchant'] = merchant;
      }
      if (amount != null) {
        queryParameters['amount'] = amount;
      }

      final ApiResponse<List<dynamic>> response = await dioClient.get(
        "expenses/filter",
        queryParameters: queryParameters,
      );

      final data = response.data;
      if (data != null) {
        final expenses = data.map((e) => ExpenseModel.fromJson(e)).toList();
        return right(expenses);
      }
      return left(Failure("Invalid response format"));
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(Failure("An unexpected error occurred: ${e.toString()}"));
    }
  }

  Future<Either<Failure, ExpenseModel>> addExpense(ExpenseModel expense) async {
    try {
      final ApiResponse<Map<String, dynamic>> response = await dioClient.post(
        "expenses/add-expense",
        data: expense.toJson(),
      );

      final data = response.data;
      if (data != null) {
        return right(ExpenseModel.fromJson(data));
      }
      return left(Failure("Failed to save expense"));
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> scanReceipt(
    String filePath,
  ) async {
    try {
      final formData = FormData.fromMap({
        'receipt': await MultipartFile.fromFile(filePath),
      });

      final ApiResponse<Map<String, dynamic>> response = await dioClient.post(
        "expenses/scan-receipt",
        data: formData,
      );

      final data = response.data;
      if (data != null) {
        return right(data);
      }
      return left(Failure("Failed to scan receipt"));
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
