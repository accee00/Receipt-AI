import 'package:frontend/features/receipt/model/expense_model.dart';
import 'package:frontend/features/receipt/repository/expense_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'add_view_model.g.dart';

@riverpod
class AddExpense extends _$AddExpense {
  late ExpenseRepo _repo;

  @override
  FutureOr<void> build() {
    _repo = ref.read(expenseRepoProvider);
  }

  Future<void> addExpense(ExpenseModel expense) async {
    state = const AsyncLoading();

    final result = await _repo.addExpense(expense);

    state = result.fold(
      (failure) => AsyncError(Exception(failure.message), StackTrace.current),
      (_) => const AsyncData(null),
    );
  }
}
