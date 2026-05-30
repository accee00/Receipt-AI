import 'package:fpdart/fpdart.dart';
import 'package:frontend/core/utils/failure.dart';
import 'package:frontend/features/receipt/repository/expense_repo.dart';
import 'package:frontend/features/receipt/viewmodel/get_and_filter_expense_viewmodel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'delete_expense_view_model.g.dart';

@riverpod
class DeleteExpense extends _$DeleteExpense {
  late ExpenseRepo _repo;
  @override
  FutureOr<void> build() {
    _repo = ref.read(expenseRepoProvider);
  }

  Future<void> deleteExpense(String expenseId) async {
    state = const AsyncLoading();

    final Either<Failure, Unit> result = await _repo.deleteExpense(
      expenseId: expenseId,
    );

    state = result.fold(
      (failure) => AsyncError(Exception(failure.message), StackTrace.current),
      (_) => const AsyncData(null),
    );

    if (!state.hasError) {
      ref.invalidate(expensesProvider);
    }
  }
}
