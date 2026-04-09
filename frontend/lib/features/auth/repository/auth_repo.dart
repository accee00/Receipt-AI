import 'package:frontend/core/network/dio_client.dart';
import 'package:frontend/core/utils/api_response.dart';
import 'package:frontend/core/utils/secure_storage.dart';
import 'package:frontend/features/auth/model/user_model.dart';
import 'package:frontend/core/utils/failure.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepo {
  final DioClient _dio = DioClient();
  final SecureStorage _secureStorage = SecureStorage();

  Future<Either<Failure, UserModel>> login(
    String email,
    String password,
  ) async {
    try {
      final ApiResponse<Map<String, dynamic>> response = await _dio
          .post<Map<String, dynamic>>(
            'http://localhost:8000/api/v1/users/login',
            data: {'email': email, 'password': password},
          );

      if (!response.isSuccess) {
        return Left(Failure(response.message!));
      }
      final user = UserModel.fromJson(response.data!);

      if (response.token != null) {
        await _secureStorage.setToken("token", response.token!);
      }

      return Right(user);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
