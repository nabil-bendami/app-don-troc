# Quick Start Guide

## 5-Minute Setup

### Step 1: Get Firebase Credentials

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project or select existing
3. Enable Authentication (Email + Google)
4. Enable Firestore Database
5. Enable Firebase Storage
6. Download credentials

### Step 2: Configure Android

1. Download `google-services.json`
2. Place in `android/app/`
3. Done! ✅

### Step 3: Configure iOS

1. Download `GoogleService-Info.plist`
2. Open Xcode: `open ios/Runner.xcworkspace`
3. Drag plist into Runner project
4. Done! ✅

### Step 4: Update Firebase Config

Edit `lib/firebase_options.dart`:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_API_KEY',
  appId: 'YOUR_APP_ID',
  messagingSenderId: 'YOUR_SENDER_ID',
  projectId: 'YOUR_PROJECT_ID',
  storageBucket: 'YOUR_PROJECT_ID.appspot.com',
);

static const FirebaseOptions ios = FirebaseOptions(
  apiKey: 'YOUR_API_KEY',
  appId: 'YOUR_APP_ID',
  messagingSenderId: 'YOUR_SENDER_ID',
  projectId: 'YOUR_PROJECT_ID',
  storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  iosBundleId: 'com.example.don_tro',
);
```

### Step 5: Install & Run

```bash
# Install dependencies
flutter pub get

# Run on device/emulator
flutter run

# Or specify platform
flutter run -d android
flutter run -d ios
```

## Common Commands

```bash
# Clean build
flutter clean

# Install dependencies
flutter pub get

# Run in debug mode
flutter run

# Build release APK (Android)
flutter build apk --release

# Build app bundle (Android Play Store)
flutter build appbundle --release

# Build release IPA (iOS)
flutter build ios --release

# Format code
dart format lib/

# Analyze code
flutter analyze

# Run tests
flutter test
```

## Firebase Firestore Rules (Paste into Firebase Console)

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users - public readable, only owner can write
    match /users/{userId} {
      allow read: if true;
      allow create: if request.auth.uid == userId;
      allow update, delete: if request.auth.uid == userId;
    }
    
    // Items - public readable, creator can manage
    match /items/{itemId} {
      allow read: if true;
      allow create: if request.auth.uid != null;
      allow update, delete: if request.auth.uid == resource.data.userId;
    }
    
    // Chats - only participants can read
    match /chats/{chatId} {
      allow read: if request.auth.uid in resource.data.userIds;
      allow create: if request.auth.uid != null;
      allow update: if request.auth.uid in resource.data.userIds;
      
      // Messages subcollection
      match /messages/{messageId} {
        allow read: if request.auth.uid in get(/databases/$(database)/documents/chats/$(chatId)).data.userIds;
        allow create: if request.auth.uid != null;
      }
    }
  }
}
```

## Firebase Storage Rules (Paste into Firebase Console)

```firebase
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Item images
    match /items/{userId}/{filename} {
      allow read: if true;
      allow write: if request.auth.uid == userId;
      allow delete: if request.auth.uid == userId;
    }
    
    // User photos
    match /users/{userId}/{filename} {
      allow read: if true;
      allow write: if request.auth.uid == userId;
      allow delete: if request.auth.uid == userId;
    }
  }
}
```

## Testing the App

1. **Sign Up**: Create account with email/password
2. **Google Sign-In**: Click "Continue with Google"
3. **Browse Items**: Scroll home feed
4. **Add Item**: Tap + button, fill form, upload images
5. **View Details**: Tap any item card
6. **Request Item**: Click "Demander" button
7. **Chat**: Send/receive messages
8. **Profile**: View your items and settings

## Project Structure at a Glance

```
lib/
├── main.dart                 # Entry point (Firebase + Riverpod setup)
├── config/                   # App theme, routes, constants
├── models/                   # Data classes (User, Item, Chat, Message)
├── services/                 # Firebase services (Auth, Firestore, Storage)
├── providers/                # Riverpod state management
├── screens/                  # UI screens (Auth, Home, Chat, etc.)
└── widgets/                  # Reusable UI components
```

## Key Features Breakdown

| Feature | Files | Tech |
|---------|-------|------|
| Auth | `auth_service.dart`, `auth_screen.dart` | Firebase Auth |
| Items | `firestore_service.dart`, `home_screen.dart` | Firestore, Riverpod |
| Images | `storage_service.dart`, `add_item_screen.dart` | Firebase Storage, Image Picker |
| Chat | `firestore_service.dart`, `chat_screen.dart` | Firestore Streams |
| Navigation | `router.dart` | GoRouter |
| State | `providers.dart` | Riverpod |

## Need Help?

- **Firebase Issues**: Check [Firebase Docs](https://firebase.flutter.dev)
- **Flutter Issues**: Check [Flutter Docs](https://flutter.dev/docs)
- **Riverpod**: Check [Riverpod Docs](https://riverpod.dev)
- **GoRouter**: Check [GoRouter Docs](https://pub.dev/packages/go_router)

## Performance Tips

1. Use lazy loading for images with `CachedNetworkImage`
2. Limit Firestore queries with pagination
3. Unsubscribe from streams when not needed
4. Use `select` in providers for granular updates
5. Build release APK for performance testing

## Security Checklist

- [ ] Firebase credentials updated
- [ ] Firestore rules configured
- [ ] Storage rules configured
- [ ] Google Sign-In properly set up
- [ ] API keys restricted (Firebase Console)
- [ ] Image uploads validated
- [ ] User inputs sanitized
- [ ] Sensitive data encrypted

---

Happy coding! 🚀
