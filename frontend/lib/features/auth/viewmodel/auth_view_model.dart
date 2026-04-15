import 'package:fpdart/fpdart.dart';
import 'package:frontend/core/utils/failure.dart';
import 'package:frontend/features/auth/model/user_model.dart';
import 'package:frontend/features/auth/repository/auth_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_view_model.g.dart';

@Riverpod(keepAlive: true)
class AuthViewModel extends _$AuthViewModel {
  late AuthRepo _authRepo;

  @override
  Future<UserModel?> build() async {
    _authRepo = ref.read(authRepoProvider);
    final result = await _authRepo.getCurrentUser();
    return result.fold((failure) => null, (userModel) => userModel);
  }

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final Either<Failure, UserModel> result = await _authRepo.signUpUser(
      name: name,
      email: email,
      password: password,
    );

    state = result.fold(
      (Failure failure) => AsyncError(failure.message, StackTrace.current),
      (UserModel userModel) => AsyncData(userModel),
    );
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final Either<Failure, UserModel> result = await _authRepo.loginUser(
      email: email,
      password: password,
    );

    state = result.fold(
      (Failure failure) => AsyncError(failure.message, StackTrace.current),
      (UserModel userModel) => AsyncData(userModel),
    );
  }

  Future<void> logOutUser() async {
    state = const AsyncLoading();
    final Either<Failure, Unit> result = await _authRepo.logOutUser();
    state = result.fold(
      (Failure failure) => AsyncError(failure.message, StackTrace.current),
      (Unit unit) => const AsyncData(null),
    );
  }

  Future<void> getCurrentUser() async {
    state = const AsyncLoading();
    final Either<Failure, UserModel> result = await _authRepo.getCurrentUser();
    state = result.fold(
      (Failure failure) => AsyncError(failure.message, StackTrace.current),
      (UserModel userModel) => AsyncData(userModel),
    );
  }
}
