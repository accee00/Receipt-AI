import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/build_extension.dart';
import 'package:frontend/core/utils/custom_snackbar.dart';
import 'package:frontend/features/ai-chat/model/chat_model.dart';
import 'package:frontend/features/ai-chat/viewmodel/chat_view_model.dart';

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _onSend() async {
    final text = _msgController.text;
    if (text.trim().isEmpty) return;

    _msgController.clear();
    try {
      await ref.read(chatViewModelProvider.notifier).sendMessage(text);
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      showCustomSnackBar(
        context: context,
        message: e.toString().replaceFirst('Exception: ', ''),
        type: SnackBarType.failure,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final chatState = ref.watch(chatViewModelProvider);

    ref.listen(chatViewModelProvider, (previous, next) {
      if (next.messages.length != (previous?.messages.length ?? 0)) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.auto_awesome, color: AppColors.primary),
            SizedBox(width: 8),
            Text(
              'Budget Master AI',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount:
                  chatState.messages.length + (chatState.isSending ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= chatState.messages.length) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: _TypingIndicator(),
                  );
                }

                final message = chatState.messages[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _ChatBubble(message: message),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 120,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    enabled: !chatState.isSending,
                    onSubmitted: (_) => _onSend(),
                    decoration: InputDecoration(
                      hintText: 'Ask about your budget...',
                      filled: true,
                      fillColor: isDark
                          ? AppColors.darkCard
                          : AppColors.lightBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: chatState.isSending ? null : _onSend,
                    icon: chatState.isSending
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send_rounded, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessageModel message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isMe = message.isUser;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(left: isMe ? 40 : 0, right: isMe ? 0 : 40),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe
              ? AppColors.primary
              : (isDark ? AppColors.darkCard : AppColors.lightCard),
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomRight: isMe
                ? const Radius.circular(4)
                : const Radius.circular(20),
            bottomLeft: !isMe
                ? const Radius.circular(4)
                : const Radius.circular(20),
          ),
          border: isMe
              ? null
              : Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
        ),
        child: Text(
          message.content,
          style: TextStyle(
            color: isMe
                ? Colors.white
                : (isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary),
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(right: 40),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(
            20,
          ).copyWith(bottomLeft: const Radius.circular(4)),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: SizedBox(
          width: 48,
          height: 20,
          child: Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary.withValues(alpha: 0.8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
