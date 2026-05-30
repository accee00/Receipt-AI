import 'package:fpdart/fpdart.dart';
import 'package:frontend/core/utils/failure.dart';
import 'package:frontend/features/receipt/model/expense_model.dart';
import 'package:frontend/features/receipt/repository/expense_repo.dart';
import 'package:frontend/features/receipt/viewmodel/get_and_filter_expense_viewmodel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'update_expense_view_model.g.dart';

@riverpod
class UpdateExpense extends _$UpdateExpense {
  late ExpenseRepo _repo;

  @override
  FutureOr<ExpenseModel?> build() {
    _repo = ref.read(expenseRepoProvider);
    return null;
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    state = const AsyncLoading();
    final Either<Failure, ExpenseModel> result = await _repo.updateExpense(
      expense,
    );
    state = result.fold(
      (failure) => AsyncError(Exception(failure.message), StackTrace.current),
      (success) => AsyncData(success),
    );

    if (!state.hasError) {
      ref.invalidate(expensesProvider);
    }
  }
}
