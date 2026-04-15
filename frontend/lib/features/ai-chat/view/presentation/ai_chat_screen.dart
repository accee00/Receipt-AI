import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/build_extension.dart';

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final TextEditingController _msgController = TextEditingController();

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

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
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildChatBubble(
                  context: context,
                  text:
                      'Hi there! I am your AI Budget Master. You can ask me to analyze your expenses, suggest budget cuts, or show your top spending categories this month.',
                  isMe: false,
                ),
                const SizedBox(height: 16),
                _buildChatBubble(
                  context: context,
                  text: 'What are my top spending categories?',
                  isMe: true,
                ),
                const SizedBox(height: 16),
                _buildChatBubble(
                  context: context,
                  text:
                      'Based on your recent transactions, your top categories are:\n1. Food & Dining (\$450)\n2. Transport (\$120)\nYou are spending 20% more on food than last month!',
                  isMe: false,
                ),
              ],
            ),
          ),

          // Input Area
          Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 120),
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
                    icon: const Icon(Icons.send_rounded, color: Colors.white),
                    onPressed: () {
                      // handle send message
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble({
    required BuildContext context,
    required String text,
    required bool isMe,
  }) {
    final isDark = context.isDark;

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
          text,
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
