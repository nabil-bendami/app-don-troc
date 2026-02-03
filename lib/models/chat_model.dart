import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String id;
  final List<String> userIds;
  final String itemId;
  final String itemTitle;
  final String lastMessage;
  final String lastMessageSenderId;
  final DateTime updatedAt;
  final int unreadCount;

  ChatModel({
    required this.id,
    required this.userIds,
    required this.itemId,
    required this.itemTitle,
    required this.lastMessage,
    required this.lastMessageSenderId,
    required this.updatedAt,
    this.unreadCount = 0,
  });

  /// Convert ChatModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userIds': userIds,
      'itemId': itemId,
      'itemTitle': itemTitle,
      'lastMessage': lastMessage,
      'lastMessageSenderId': lastMessageSenderId,
      'updatedAt': updatedAt,
      'unreadCount': unreadCount,
    };
  }

  /// Create ChatModel from Firestore document
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] as String,
      userIds: List<String>.from(json['userIds'] as List),
      itemId: json['itemId'] as String,
      itemTitle: json['itemTitle'] as String,
      lastMessage: json['lastMessage'] as String,
      lastMessageSenderId: json['lastMessageSenderId'] as String,
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      unreadCount: json['unreadCount'] as int? ?? 0,
    );
  }

  /// Create a copy with modified fields
  ChatModel copyWith({
    String? id,
    List<String>? userIds,
    String? itemId,
    String? itemTitle,
    String? lastMessage,
    String? lastMessageSenderId,
    DateTime? updatedAt,
    int? unreadCount,
  }) {
    return ChatModel(
      id: id ?? this.id,
      userIds: userIds ?? this.userIds,
      itemId: itemId ?? this.itemId,
      itemTitle: itemTitle ?? this.itemTitle,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      updatedAt: updatedAt ?? this.updatedAt,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
