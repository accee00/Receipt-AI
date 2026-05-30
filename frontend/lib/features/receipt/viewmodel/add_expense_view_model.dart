import 'package:fpdart/fpdart.dart';
import 'package:frontend/core/utils/failure.dart';
import 'package:frontend/features/receipt/model/expense_model.dart';
import 'package:frontend/features/receipt/repository/expense_repo.dart';
import 'package:frontend/features/receipt/viewmodel/get_and_filter_expense_viewmodel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'add_expense_view_model.g.dart';

@riverpod
class AddExpense extends _$AddExpense {
  late ExpenseRepo _repo;

  @override
  FutureOr<void> build() {
    _repo = ref.read(expenseRepoProvider);
  }

  Future<void> addExpense(ExpenseModel expense) async {
    state = const AsyncLoading();

    final Either<Failure, Unit> result = await _repo.addExpense(expense);

    state = result.fold(
      (failure) => AsyncError(Exception(failure.message), StackTrace.current),
      (_) => const AsyncData(null),
    );
    if (!state.hasError) {
      ref.invalidate(expensesProvider);
    }
  }
}
