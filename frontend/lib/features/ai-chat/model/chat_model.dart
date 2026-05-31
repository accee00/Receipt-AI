enum ChatRole {
  user,
  assistant;

  String get apiValue => name;

  static ChatRole fromApi(String? value) {
    return value == 'assistant' ? ChatRole.assistant : ChatRole.user;
  }
}

class ChatMessageModel {
  final ChatRole role;
  final String content;

  const ChatMessageModel({required this.role, required this.content});

  bool get isUser => role == ChatRole.user;
  bool get isAssistant => role == ChatRole.assistant;

  factory ChatMessageModel.user(String content) =>
      ChatMessageModel(role: ChatRole.user, content: content);

  factory ChatMessageModel.assistant(String content) =>
      ChatMessageModel(role: ChatRole.assistant, content: content);

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      role: ChatRole.fromApi(json['role'] as String?),
      content: json['content'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'role': role.apiValue, 'content': content};
}
