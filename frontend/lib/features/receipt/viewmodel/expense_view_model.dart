import 'package:frontend/features/receipt/model/expense_model.dart';
import 'package:frontend/features/receipt/repository/expense_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'expense_view_model.g.dart';

@Riverpod(keepAlive: true)
class ExpenseViewModel extends _$ExpenseViewModel {
  late ExpenseRepo expenseRepo;
  @override
  FutureOr<List<ExpenseModel>> build() async {
    expenseRepo = ref.read(expenseRepoProvider);
    final now = DateTime.now();
    return _fetchExpenses(month: now.month, year: now.year);
  }

  Future<List<ExpenseModel>> _fetchExpenses({
    int? month,
    int? year,
    String? category,
    String? merchant,
    double? amount,
  }) async {
    final result = await expenseRepo.getFilteredExpenses(
      month: month,
      year: year,
      category: category,
      merchant: merchant,
      amount: amount,
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

    state = await AsyncValue.guard(
      () => _fetchExpenses(
        month: month,
        year: year,
        category: category,
        merchant: merchant,
        amount: amount,
      ),
    );
  }

  Future<void> addExpense(ExpenseModel expense) async {
    final result = await expenseRepo.addExpense(expense);

    result.fold(
      (failure) {
        state = AsyncError(Exception(failure.message), StackTrace.current);
      },
      (_) {
        ref.invalidateSelf();
      },
    );
  }
}
