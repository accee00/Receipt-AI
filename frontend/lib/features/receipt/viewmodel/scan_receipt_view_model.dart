import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:frontend/core/utils/failure.dart';
import 'package:frontend/features/receipt/model/scan_result_model.dart';
import 'package:frontend/features/receipt/repository/expense_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scan_receipt_view_model.g.dart';

@riverpod
class ScanReceiptViewModel extends _$ScanReceiptViewModel {
  late ExpenseRepo expenseRepo;
  @override
  FutureOr<ScanResultModel?> build() {
    expenseRepo = ref.read(expenseRepoProvider);
    return null;
  }

  Future<void> scanReceipt(String imagePath, CancelToken? cancelToken) async {
    state = const AsyncLoading();
    final Either<Failure, ScanResultModel> result = await expenseRepo
        .scanReceipt(imagePath, cancelToken);
    state = result.fold(
      (failure) => AsyncError(failure.message, StackTrace.current),
      (ScanResultModel scanResult) {
        return AsyncData(scanResult);
      },
    );
  }
}
