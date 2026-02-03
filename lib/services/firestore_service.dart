import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/index.dart';

// ignore: unnecessary_cast
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _itemsCollection = 'items';
  static const String _chatsCollection = 'chats';
  static const String _messagesCollection = 'messages';
  static const int _pageSize = 10;

  /// Create a new item
  Future<ItemModel> createItem({
    required String title,
    required String description,
    required String category,
    required ItemType type,
    required List<String> imageUrls,
    required String userId,
    required String userName,
    String? userPhotoUrl,
    required String location,
    double? latitude,
    double? longitude,
  }) async {
    try {
      const uuid = Uuid();
      final itemId = uuid.v4();

      final itemModel = ItemModel(
        id: itemId,
        title: title,
        description: description,
        category: category,
        type: type,
        imageUrls: imageUrls,
        userId: userId,
        userName: userName,
        userPhotoUrl: userPhotoUrl,
        location: location,
        latitude: latitude,
        longitude: longitude,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection(_itemsCollection)
          .doc(itemId)
          .set(itemModel.toJson());
      return itemModel;
    } catch (e) {
      rethrow;
    }
  }

  /// Get item by ID
  Future<ItemModel?> getItem(String itemId) async {
    try {
      final doc = await _firestore
          .collection(_itemsCollection)
          .doc(itemId)
          .get();
      if (doc.exists) {
        return ItemModel.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  /// Get paginated items feed
  Stream<List<ItemModel>> getItemsFeed({
    DocumentSnapshot? startAfter,
    int limit = _pageSize,
  }) {
    try {
      Query query = _firestore
          .collection(_itemsCollection)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      return query.snapshots().map((snapshot) {
        return snapshot.docs
            .map(
              (doc) => ItemModel.fromJson(doc.data() as Map<String, dynamic>),
            )
            .toList();
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Get items by user
  Stream<List<ItemModel>> getUserItems(String userId) {
    try {
      return _firestore
          .collection(_itemsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map(
                  (doc) =>
                      ItemModel.fromJson(doc.data() as Map<String, dynamic>),
                )
                .toList();
          });
    } catch (e) {
      rethrow;
    }
  }

  /// Search items by title or description
  Stream<List<ItemModel>> searchItems(String query) {
    try {
      return _firestore
          .collection(_itemsCollection)
          .orderBy('title')
          .startAt([query])
          .endAt(['$query\uf8ff'])
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map(
                  (doc) =>
                      ItemModel.fromJson(doc.data() as Map<String, dynamic>),
                )
                .toList();
          });
    } catch (e) {
      rethrow;
    }
  }

  /// Update item
  Future<void> updateItem(String itemId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection(_itemsCollection).doc(itemId).update(updates);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete item
  Future<void> deleteItem(String itemId) async {
    try {
      await _firestore.collection(_itemsCollection).doc(itemId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Create or get chat
  Future<ChatModel> createOrGetChat({
    required String userId1,
    required String userId2,
    required String itemId,
    required String itemTitle,
  }) async {
    try {
      /// Check if chat already exists
      final query = await _firestore
          .collection(_chatsCollection)
          .where('userIds', arrayContains: userId1)
          .where('itemId', isEqualTo: itemId)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final doc = query.docs.first;
        return ChatModel.fromJson(doc.data());
      }

      /// Create new chat
      const uuid = Uuid();
      final chatId = uuid.v4();
      final chatModel = ChatModel(
        id: chatId,
        userIds: [userId1, userId2],
        itemId: itemId,
        itemTitle: itemTitle,
        lastMessage: '',
        lastMessageSenderId: userId1,
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection(_chatsCollection)
          .doc(chatId)
          .set(chatModel.toJson());
      return chatModel;
    } catch (e) {
      rethrow;
    }
  }

  /// Get user chats
  Stream<List<ChatModel>> getUserChats(String userId) {
    try {
      return _firestore
          .collection(_chatsCollection)
          .where('userIds', arrayContains: userId)
          .orderBy('updatedAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => ChatModel.fromJson(doc.data()))
                .toList();
          });
    } catch (e) {
      rethrow;
    }
  }

  /// Get chat messages
  Stream<List<MessageModel>> getChatMessages(String chatId) {
    try {
      return _firestore
          .collection(_chatsCollection)
          .doc(chatId)
          .collection(_messagesCollection)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => MessageModel.fromJson(doc.data()))
                .toList()
                .reversed
                .toList();
          });
    } catch (e) {
      rethrow;
    }
  }

  /// Send message
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String senderPhotoUrl,
    required String text,
  }) async {
    try {
      const uuid = Uuid();
      final messageId = uuid.v4();
      final messageModel = MessageModel(
        id: messageId,
        chatId: chatId,
        senderId: senderId,
        senderName: senderName,
        senderPhotoUrl: senderPhotoUrl,
        text: text,
        createdAt: DateTime.now(),
      );

      /// Add message to chat subcollection
      await _firestore
          .collection(_chatsCollection)
          .doc(chatId)
          .collection(_messagesCollection)
          .doc(messageId)
          .set(messageModel.toJson());

      /// Update last message in chat
      await _firestore.collection(_chatsCollection).doc(chatId).update({
        'lastMessage': text,
        'lastMessageSenderId': senderId,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      rethrow;
    }
  }
}
