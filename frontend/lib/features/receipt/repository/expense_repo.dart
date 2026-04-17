import 'package:dio/dio.dart';

import 'package:frontend/core/di/riverpod_di.dart';
import 'package:frontend/core/network/dio_client.dart';
import 'package:frontend/core/utils/api_response.dart';
import 'package:frontend/core/utils/failure.dart';
import 'package:frontend/features/receipt/model/expense_model.dart';
import 'package:frontend/features/receipt/model/scan_result_model.dart';
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
    int? page,
    int? limit,
    String? startDate,
    String? endDate,
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
      if (page != null) queryParameters['page'] = page;
      if (limit != null) queryParameters['limit'] = limit;
      if (startDate != null && startDate.isNotEmpty) {
        queryParameters['startDate'] = startDate;
      }
      if (endDate != null && endDate.isNotEmpty) {
        queryParameters['endDate'] = endDate;
      }

      final ApiResponse<dynamic> response = await dioClient.get(
        "expenses/",
        queryParameters: queryParameters,
      );

      final data = response.data as Map<String, dynamic>?;
      if (data != null && data.containsKey('expenses')) {
        final expensesList = data['expenses'] as List<dynamic>;

        return right(
          expensesList
              .map((e) => ExpenseModel.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      }
      return left(Failure("Invalid response format: 'expenses' key missing."));
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

  Future<Either<Failure, ScanResultModel>> scanReceipt(
    String filePath,
    CancelToken? cancelToken,
  ) async {
    try {
      final formData = FormData.fromMap({
        'receipt': await MultipartFile.fromFile(filePath),
      });

      final ApiResponse<Map<String, dynamic>> response = await dioClient.post(
        "expenses/scan-receipt",
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          receiveTimeout: Duration(seconds: 30),
        ),
        cancelToken: cancelToken,
      );

      final data = response.data;
      if (data != null) {
        final scanResult = ScanResultModel.fromJson(data['extractedData']);
        final updatedScanResult = scanResult.copyWith(
          receiptImageUrl: data['receiptImageUrl'],
        );
        return right(updatedScanResult);
      }
      return left(Failure("Failed to scan receipt"));
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
