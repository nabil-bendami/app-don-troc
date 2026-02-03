import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/index.dart';
import '../models/index.dart';

/// Service providers
final firestoreServiceProvider = Provider((ref) => FirestoreService());
final storageServiceProvider = Provider((ref) => StorageService());

/// Auth state provider
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

/// Current user model provider
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authService = ref.watch(authServiceProvider);
  final user = authService.currentUser;
  if (user != null) {
    return await authService.getUserModel(user.uid);
  }
  return null;
});

/// Items feed provider with pagination
final itemsFeedProvider = StreamProvider.autoDispose((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getItemsFeed();
});

/// User items provider
final userItemsProvider = StreamProvider.family<List<ItemModel>, String>((
  ref,
  userId,
) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getUserItems(userId);
});

/// Search items provider
final searchItemsProvider = StreamProvider.family<List<ItemModel>, String>((
  ref,
  query,
) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.searchItems(query);
});

/// User chats provider
final userChatsProvider = StreamProvider.family<List<ChatModel>, String>((
  ref,
  userId,
) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getUserChats(userId);
});

/// Chat messages provider
final chatMessagesProvider = StreamProvider.family<List<MessageModel>, String>((
  ref,
  chatId,
) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getChatMessages(chatId);
});

/// Item provider by ID
final itemProvider = FutureProvider.family<ItemModel?, String>((
  ref,
  itemId,
) async {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return await firestoreService.getItem(itemId);
});
