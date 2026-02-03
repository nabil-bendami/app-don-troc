import 'package:cloud_firestore/cloud_firestore.dart';

enum ItemType { don, troc }

class ItemModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final ItemType type;
  final List<String> imageUrls;
  final String userId;
  final String userName;
  final String? userPhotoUrl;
  final String location;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;

  ItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.type,
    required this.imageUrls,
    required this.userId,
    required this.userName,
    this.userPhotoUrl,
    required this.location,
    this.latitude,
    this.longitude,
    required this.createdAt,
  });

  /// Convert ItemModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'type': type.name,
      'imageUrls': imageUrls,
      'userId': userId,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt,
    };
  }

  /// Create ItemModel from Firestore document
  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      type: ItemType.values.byName(json['type'] as String),
      imageUrls: List<String>.from(json['imageUrls'] as List),
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userPhotoUrl: json['userPhotoUrl'] as String?,
      location: json['location'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Create a copy with modified fields
  ItemModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    ItemType? type,
    List<String>? imageUrls,
    String? userId,
    String? userName,
    String? userPhotoUrl,
    String? location,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
  }) {
    return ItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      type: type ?? this.type,
      imageUrls: imageUrls ?? this.imageUrls,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
