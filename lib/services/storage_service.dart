import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  static const String _itemImagesPath = 'items';
  static const String _userPhotosPath = 'users';

  /// Upload item images to Firebase Storage
  Future<List<String>> uploadItemImages({
    required List<File> images,
    required String userId,
  }) async {
    try {
      const uuid = Uuid();
      final List<String> imageUrls = [];

      for (final image in images) {
        final fileName = uuid.v4();
        final ref = _storage
            .ref()
            .child(_itemImagesPath)
            .child(userId)
            .child(fileName);

        await ref.putFile(image);
        final url = await ref.getDownloadURL();
        imageUrls.add(url);
      }

      return imageUrls;
    } catch (e) {
      rethrow;
    }
  }

  /// Upload user profile photo
  Future<String?> uploadUserPhoto({
    required File photo,
    required String userId,
  }) async {
    try {
      final ref = _storage
          .ref()
          .child(_userPhotosPath)
          .child(userId)
          .child('profile');
      await ref.putFile(photo);
      return await ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }

  /// Delete item image
  Future<void> deleteItemImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Delete user photo
  Future<void> deleteUserPhoto(String userId) async {
    try {
      final ref = _storage
          .ref()
          .child(_userPhotosPath)
          .child(userId)
          .child('profile');
      await ref.delete();
    } catch (e) {
      rethrow;
    }
  }
}
