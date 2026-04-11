import 'package:frontend/core/di/riverpod_di.dart';
import 'package:frontend/core/network/dio_client.dart';
import 'package:frontend/core/utils/api_response.dart';
import 'package:frontend/core/utils/failure.dart';
import 'package:frontend/core/utils/secure_storage.dart';
import 'package:frontend/features/auth/model/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fpdart/fpdart.dart';
part 'auth_repo.g.dart';

@riverpod
AuthRepo authRepo(Ref ref) {
  return AuthRepo(
    dioClient: ref.watch(dioClientProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
}

class AuthRepo {
  final DioClient dioClient;
  final SecureStorage secureStorage;

  AuthRepo({required this.dioClient, required this.secureStorage});

  Future<Either<Failure, UserModel>> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final ApiResponse<Map<String, dynamic>> response = await dioClient.post(
        "users/signup",
        data: {"name": name, "email": email, "password": password},
      );

      final data = response.data;
      if (data != null && data['user'] != null) {
        final userModel = UserModel.fromJson(data['user']);
        if (data['token'] != null) {
          await secureStorage.setToken("token", data['token']);
        }
        return right(userModel);
      }
      return left(Failure("Invalid response format"));
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(Failure("An unexpected error occurred: ${e.toString()}"));
    }
  }

  Future<Either<Failure, UserModel>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final ApiResponse<Map<String, dynamic>> response = await dioClient.post(
        "users/login",
        data: {"email": email, "password": password},
      );

      final data = response.data;
      if (data != null && data['user'] != null) {
        final userModel = UserModel.fromJson(data['user']);
        if (data['token'] != null) {
          await secureStorage.setToken("token", data['token']);
        }
        return right(userModel);
      }
      return left(Failure("Invalid response format"));
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(Failure("An unexpected error occurred: ${e.toString()}"));
    }
  }

  Future<Either<Failure, Unit>> logOutUser() async {
    try {
      await secureStorage.deleteToken("token");
      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> getCurrentUser() async {
    try {
      final ApiResponse<dynamic> response = await dioClient.get("users/me");

      final data = response.data;
      if (data != null) {
        final userModel = UserModel.fromJson(data);
        return right(userModel);
      }
      return left(Failure("Invalid response format"));
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(Failure("An unexpected error occurred: ${e.toString()}"));
    }
  }
}
