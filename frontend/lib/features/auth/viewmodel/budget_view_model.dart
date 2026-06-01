import 'package:fpdart/fpdart.dart';
import 'package:frontend/core/utils/failure.dart';
import 'package:frontend/features/auth/model/user_model.dart';
import 'package:frontend/features/auth/repository/auth_repo.dart';
import 'package:frontend/features/auth/viewmodel/auth_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'budget_view_model.g.dart';

@riverpod
class BudgetViewModel extends _$BudgetViewModel {
  late AuthRepo _authRepo;

  @override
  FutureOr<void> build() {
    _authRepo = ref.read(authRepoProvider);
  }

  Future<bool> setBudget(double amount) async {
    state = const AsyncLoading();

    final Either<Failure, UserModel> result = await _authRepo.addBudget(
      amount: amount,
    );

    return result.fold(
      (Failure failure) {
        state = AsyncError(failure.message, StackTrace.current);
        return false;
      },
      (UserModel user) {
        ref.read(authViewModelProvider.notifier).updateUser(user);
        state = const AsyncData(null);
        return true;
      },
    );
  }
}
