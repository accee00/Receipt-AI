import 'package:frontend/features/ai-chat/model/chat_model.dart';
import 'package:frontend/features/ai-chat/repository/chat_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_view_model.g.dart';

const _welcomeMessage =
    'Hi there! I am your AI Budget Master. You can ask me to analyze your expenses, suggest budget cuts, or show your top spending categories this month.';

class ChatState {
  final List<ChatMessageModel> messages;
  final bool isSending;

  const ChatState({
    required this.messages,
    this.isSending = false,
  });

  factory ChatState.initial() => ChatState(
        messages: [ChatMessageModel.assistant(_welcomeMessage)],
      );

  ChatState copyWith({
    List<ChatMessageModel>? messages,
    bool? isSending,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
    );
  }
}

@riverpod
class ChatViewModel extends _$ChatViewModel {
  late ChatRepo _repo;

  @override
  ChatState build() {
    _repo = ref.read(chatRepoProvider);
    return ChatState.initial();
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isSending) return;

    final priorMessages = List<ChatMessageModel>.from(state.messages);

    state = state.copyWith(
      messages: [...priorMessages, ChatMessageModel.user(trimmed)],
      isSending: true,
    );

    final result = await _repo.sendMessage(
      message: trimmed,
      history: priorMessages,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          messages: priorMessages,
          isSending: false,
        );
        throw Exception(failure.message);
      },
      (reply) {
        state = state.copyWith(
          messages: [...state.messages, ChatMessageModel.assistant(reply)],
          isSending: false,
        );
      },
    );
  }
}
