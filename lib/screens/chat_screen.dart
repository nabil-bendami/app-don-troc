import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../config/index.dart';
import '../widgets/index.dart' as custom;
import '../providers/providers.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String chatId;

  const ChatScreen({required this.chatId, super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final currentUser = ref.read(currentUserProvider);
    currentUser.whenData((user) async {
      if (user != null) {
        final firestoreService = ref.read(firestoreServiceProvider);
        try {
          await firestoreService.sendMessage(
            chatId: widget.chatId,
            senderId: user.uid,
            senderName: user.name,
            senderPhotoUrl: user.photoUrl ?? '',
            text: _messageController.text.trim(),
          );
          _messageController.clear();

          /// Scroll to bottom
          Future.delayed(const Duration(milliseconds: 100), () {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          });
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatMessagesProvider(widget.chatId));
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// Messages list
            Expanded(
              child: messagesAsync.when(
                data: (messages) {
                  if (messages.isEmpty) {
                    return const custom.EmptyWidget(
                      title: 'No messages',
                      message: 'Start the conversation!',
                      icon: Icons.chat_outlined,
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return currentUser.when(
                        data: (user) {
                          final isCurrentUser =
                              user != null && user.uid == message.senderId;
                          return custom.MessageBubble(
                            text: message.text,
                            isCurrentUser: isCurrentUser,
                            timestamp: _formatTime(message.createdAt),
                          );
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (_, stackTrace) => const SizedBox.shrink(),
                      );
                    },
                  );
                },
                loading: () =>
                    const custom.LoadingWidget(message: 'Loading messages...'),
                error: (error, stack) => custom.ErrorWidget(
                  message: error.toString(),
                  onRetry: () =>
                      ref.refresh(chatMessagesProvider(widget.chatId)),
                ),
              ),
            ),

            /// Message input
            Container(
              padding: const EdgeInsets.all(Constants.paddingMedium),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                border: Border(top: BorderSide(color: AppTheme.greyColor)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            Constants.borderRadiusMedium,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppTheme.greyColor,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Constants.paddingMedium,
                          vertical: Constants.paddingSmall,
                        ),
                      ),
                      maxLines: null,
                    ),
                  ),
                  const SizedBox(width: Constants.paddingSmall),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: AppTheme.primaryColor,
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }
}
