import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/index.dart' as custom;
import '../providers/providers.dart';

class MessagesScreen extends ConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: currentUser.when(
          data: (user) {
            if (user == null) {
              return const Center(child: Text('Not authenticated'));
            }

            final chatsAsync = ref.watch(userChatsProvider(user.uid));

            return chatsAsync.when(
              data: (chats) {
                if (chats.isEmpty) {
                  return const custom.EmptyWidget(
                    title: 'No messages yet',
                    message: 'Start a conversation by requesting an item.',
                    icon: Icons.chat_outlined,
                  );
                }

                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    return custom.ChatPreviewCard(
                      chat: chat,
                      onTap: () => context.push('/chat/${chat.id}'),
                    );
                  },
                );
              },
              loading: () =>
                  const custom.LoadingWidget(message: 'Loading chats...'),
              error: (error, stack) => custom.ErrorWidget(
                message: error.toString(),
                onRetry: () => ref.refresh(userChatsProvider(user.uid)),
              ),
            );
          },
          loading: () => const custom.LoadingWidget(message: 'Loading user...'),
          error: (error, stack) =>
              custom.ErrorWidget(message: error.toString()),
        ),
      ),
    );
  }
}
