# Don & Troc - Donation & Barter Marketplace

A modern, production-ready Flutter application for sharing and exchanging items between users. Built with Flutter, Firebase, Riverpod, and GoRouter.

## 📋 Features

- **User Authentication**: Email/Password and Google Sign-In
- **Item Marketplace**: Browse, post, and search items
- **Real-time Chat**: One-to-one messaging with real-time updates
- **User Profiles**: Manage posts, view activity, and sign out
- **Image Uploads**: Multi-image support for items
- **Firestore Database**: Scalable cloud storage
- **Responsive UI**: Works on Android & iOS
- **State Management**: Riverpod for reactive state
- **Navigation**: GoRouter for modern routing

## 🛠️ Tech Stack

- **Flutter**: 3.10.8+
- **Firebase Core**: 3.0.0+
- **Firebase Auth**: 5.0.0+
- **Cloud Firestore**: 5.0.0+
- **Firebase Storage**: 12.0.0+
- **Google Sign-In**: 6.2.0+
- **Riverpod**: 2.4.0+
- **GoRouter**: 13.0.0+
- **Cached Network Image**: 3.3.0+
- **Image Picker**: 1.0.0+

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── config/
│   ├── router.dart          # GoRouter configuration
│   ├── theme.dart           # App theming
│   ├── constants.dart       # App constants
│   └── index.dart
├── models/
│   ├── user_model.dart
│   ├── item_model.dart
│   ├── message_model.dart
│   ├── chat_model.dart
│   └── index.dart
├── services/
│   ├── auth_service.dart       # Firebase authentication
│   ├── firestore_service.dart  # Firestore operations
│   ├── storage_service.dart    # Firebase Storage operations
│   └── index.dart
├── providers/
│   └── providers.dart          # Riverpod providers
├── screens/
│   ├── splash_screen.dart
│   ├── auth_screen.dart
│   ├── sign_up_screen.dart
│   ├── home_screen.dart
│   ├── item_detail_screen.dart
│   ├── add_item_screen.dart
│   ├── chat_screen.dart
│   ├── messages_screen.dart
│   ├── activity_screen.dart
│   ├── profile_screen.dart
│   └── index.dart
├── widgets/
│   ├── item_card.dart
│   ├── chat_preview_card.dart
│   ├── message_bubble.dart
│   ├── state_widgets.dart
│   ├── bottom_nav_bar.dart
│   └── index.dart
└── firebase_options.dart       # Firebase configuration
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.10.8+)
- Dart SDK (3.10.8+)
- Firebase project with enabled services
- Google Cloud credentials for OAuth

### 1. Setup Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project (or use existing)
3. Enable the following services:
   - **Authentication**: Email/Password + Google Sign-In
   - **Firestore Database**: Create database in production mode
   - **Storage**: Create storage bucket
4. Download the configuration files

### 2. Configure Firebase for Android

1. Download `google-services.json` from Firebase Console
2. Place it in `android/app/` directory
3. Ensure Android SDK version in `android/app/build.gradle.kts`:
```kotlin
android {
    compileSdk = 34
    defaultConfig {
        targetSdk = 34
    }
}
```

### 3. Configure Firebase for iOS

1. Download `GoogleService-Info.plist` from Firebase Console
2. Add it to Xcode project (via Xcode, not file system)
3. Ensure iOS deployment target is 12.0+ in `ios/Podfile`:
```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'FIREBASE_ANALYTICS_COLLECTION_ENABLED=1'
      ]
    end
  end
end
```

### 4. Update Firebase Configuration

Update `lib/firebase_options.dart` with your Firebase project credentials:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ANDROID_API_KEY',
  appId: 'YOUR_ANDROID_APP_ID',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'YOUR_PROJECT_ID',
  storageBucket: 'YOUR_PROJECT_ID.appspot.com',
);
```

### 5. Install Dependencies

```bash
flutter pub get
```

### 6. Setup Google Sign-In (Optional)

For Google Sign-In to work:

**Android**:
1. Get your SHA-1 fingerprint: `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android`
2. Add to Firebase Console > Project Settings > Your apps

**iOS**:
1. Configure OAuth consent screen in Google Cloud Console
2. Download OAuth client ID and add custom URL scheme to `ios/Runner/Info.plist`

### 7. Run the App

```bash
# For Android
flutter run

# For iOS
flutter run -d ios

# For Web (if configured)
flutter run -d web
```

## 📊 Firestore Data Models

### Users Collection
```json
{
  "uid": "user_id",
  "name": "User Name",
  "email": "user@example.com",
  "photoUrl": "https://...",
  "createdAt": "timestamp",
  "location": "City",
  "latitude": 48.8566,
  "longitude": 2.3522
}
```

### Items Collection
```json
{
  "id": "item_id",
  "title": "Item Name",
  "description": "Item description",
  "category": "Electronics",
  "type": "don|troc",
  "imageUrls": ["https://...", "https://..."],
  "userId": "user_id",
  "userName": "User Name",
  "userPhotoUrl": "https://...",
  "location": "City",
  "latitude": 48.8566,
  "longitude": 2.3522,
  "createdAt": "timestamp"
}
```

### Chats Collection
```json
{
  "id": "chat_id",
  "userIds": ["user1_id", "user2_id"],
  "itemId": "item_id",
  "itemTitle": "Item Name",
  "lastMessage": "Message text",
  "lastMessageSenderId": "user_id",
  "updatedAt": "timestamp",
  "unreadCount": 2
}
```

### Messages Subcollection (under chats)
```json
{
  "id": "message_id",
  "chatId": "chat_id",
  "senderId": "user_id",
  "senderName": "User Name",
  "senderPhotoUrl": "https://...",
  "text": "Message text",
  "createdAt": "timestamp"
}
```

## 🎨 UI/UX Features

- **Minimal Design**: Clean, white background with soft shadows
- **Rounded Cards**: 16px border radius for modern look
- **Responsive Layout**: Adapts to all screen sizes
- **Bottom Navigation**: Easy access to main sections
- **Loading States**: Smooth loading indicators
- **Error Handling**: User-friendly error messages
- **Real-time Updates**: Firestore streams for instant data

## 🔐 Security

### Firestore Rules (Recommended)

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users
    match /users/{userId} {
      allow read: if true;
      allow write: if request.auth.uid == userId;
    }
    
    // Items
    match /items/{itemId} {
      allow read: if true;
      allow create: if request.auth.uid != null;
      allow update: if request.auth.uid == resource.data.userId;
      allow delete: if request.auth.uid == resource.data.userId;
    }
    
    // Chats
    match /chats/{chatId} {
      allow read: if request.auth.uid in resource.data.userIds;
      allow create: if request.auth.uid != null;
      
      // Messages
      match /messages/{messageId} {
        allow read: if request.auth.uid in get(/databases/$(database)/documents/chats/$(chatId)).data.userIds;
        allow create: if request.auth.uid != null;
      }
    }
  }
}
```

### Storage Rules (Recommended)

```firebase
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /items/{userId}/{filename} {
      allow read: if true;
      allow write: if request.auth.uid == userId;
      allow delete: if request.auth.uid == userId;
    }
    
    match /users/{userId}/{filename} {
      allow read: if true;
      allow write: if request.auth.uid == userId;
      allow delete: if request.auth.uid == userId;
    }
  }
}
```

## 📱 App Navigation

- **Splash** → Shows loading animation
- **Auth** → Sign In / Sign Up screens
- **Home** → Browse items with search
- **Item Detail** → Full item information and chat request
- **Add Item** → Create new listings
- **Messages** → Manage conversations
- **Activity** → Notifications and alerts
- **Profile** → User info and posted items

## 🐛 Troubleshooting

### Firebase Initialization Error
- Ensure `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are properly configured
- Check Firebase project ID in `firebase_options.dart`

### Image Upload Issues
- Verify Firebase Storage permissions are set correctly
- Check device storage permissions are granted

### Google Sign-In Not Working
- Verify SHA-1 fingerprint in Firebase Console (Android)
- Check custom URL scheme in Info.plist (iOS)
- Ensure OAuth consent screen is configured

### Real-time Chat Not Updating
- Check Firestore rules allow read/write for authenticated users
- Verify internet connection
- Restart app to refresh stream

## 🚀 Deployment

### Android Release Build
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS Release Build
```bash
flutter build ios --release
# Then open with Xcode and submit to App Store
```

## 📝 License

This project is open source and available under the MIT License.

## 🤝 Contributing

Feel free to fork this project and submit pull requests for any improvements.

## 📧 Support

For issues and questions, please create an issue in the repository.

---

Built with ❤️ for the community
