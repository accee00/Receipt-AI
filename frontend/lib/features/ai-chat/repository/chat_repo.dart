import 'package:fpdart/fpdart.dart';
import 'package:frontend/core/di/riverpod_di.dart';
import 'package:frontend/core/network/dio_client.dart';
import 'package:frontend/core/utils/api_response.dart';
import 'package:frontend/core/utils/failure.dart';
import 'package:frontend/features/ai-chat/model/chat_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_repo.g.dart';

@riverpod
ChatRepo chatRepo(Ref ref) {
  return ChatRepo(dioClient: ref.watch(dioClientProvider));
}

class ChatRepo {
  final DioClient dioClient;

  ChatRepo({required this.dioClient});

  Future<Either<Failure, String>> sendMessage({
    required String message,
    required List<ChatMessageModel> history,
  }) async {
    try {
      final ApiResponse<Map<String, dynamic>> response = await dioClient.post(
        'chat',
        data: {
          'message': message,
          'history': history.map((m) => m.toJson()).toList(),
        },
      );

      final reply = response.data?['reply'] as String?;
      if (reply != null && reply.isNotEmpty) {
        return right(reply);
      }
      return left(Failure('Failed to get reply'));
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
