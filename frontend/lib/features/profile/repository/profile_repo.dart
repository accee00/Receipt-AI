import 'package:fpdart/fpdart.dart';
import 'package:frontend/core/di/riverpod_di.dart';
import 'package:frontend/core/network/dio_client.dart';
import 'package:frontend/core/utils/api_response.dart';
import 'package:frontend/core/utils/failure.dart';
import 'package:frontend/features/auth/model/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
ProfileRepo profileRepo(Ref ref) {
  return ProfileRepo(dioClient: ref.read(dioClientProvider));
}

class ProfileRepo {
  final DioClient dioClient;
  ProfileRepo({required this.dioClient});

  Future<Either<Failure, UserModel>> updateName(String name) async {
    try {
      final ApiResponse<Map<String, dynamic>> response = await dioClient.put(
        "/profile/update-name",
        data: {name: name},
      );
      final Map<String, dynamic>? data = response.data;
      if (data != null) {
        final UserModel updatedUser = UserModel.fromJson(data);
        return right(updatedUser);
      }
      return left(Failure('Fail to update user.'));
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
