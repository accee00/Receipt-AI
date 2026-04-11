import 'package:frontend/core/network/dio_client.dart';
import 'package:frontend/core/utils/secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'riverpod_di.g.dart';

@Riverpod(keepAlive: true)
DioClient dioClient(Ref ref) {
  return DioClient();
}

@Riverpod(keepAlive: true)
SecureStorage secureStorage(Ref ref) {
  return SecureStorage();
}
