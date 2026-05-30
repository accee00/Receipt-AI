import 'package:frontend/features/receipt/model/expense_model.dart';
import 'package:frontend/features/receipt/repository/expense_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'expense_view_model.g.dart';

@Riverpod(keepAlive: true)
class Expenses extends _$Expenses {
  late ExpenseRepo _repo;

  @override
  FutureOr<List<ExpenseModel>> build() async {
    _repo = ref.read(expenseRepoProvider);

    final now = DateTime.now();

    final result = await _repo.getFilteredExpenses(
      month: now.month,
      year: now.year,
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (expenses) => expenses,
    );
  }

  Future<void> filterExpenses({
    int? month,
    int? year,
    String? category,
    String? merchant,
    double? amount,
  }) async {
    state = const AsyncLoading();

    final result = await _repo.getFilteredExpenses(
      month: month,
      year: year,
      category: category,
      merchant: merchant,
      amount: amount,
    );

    state = result.fold(
      (failure) => AsyncError(Exception(failure.message), StackTrace.current),
      AsyncData.new,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
