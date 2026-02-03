# Code Examples & API Reference

## Authentication Examples

### Sign Up
```dart
final authService = ref.read(authServiceProvider);
await authService.signUp(
  email: 'user@example.com',
  password: 'password123',
  name: 'John Doe',
);
```

### Sign In
```dart
final authService = ref.read(authServiceProvider);
final user = await authService.signIn(
  email: 'user@example.com',
  password: 'password123',
);
```

### Google Sign In
```dart
final authService = ref.read(authServiceProvider);
final user = await authService.signInWithGoogle();
```

### Sign Out
```dart
final authService = ref.read(authServiceProvider);
await authService.signOut();
```

## Firestore Examples

### Create Item
```dart
final firestoreService = ref.read(firestoreServiceProvider);
final item = await firestoreService.createItem(
  title: 'Laptop',
  description: 'MacBook Pro 2021',
  category: 'Electronics',
  type: ItemType.troc,
  imageUrls: ['https://...'],
  userId: 'user123',
  userName: 'John Doe',
  location: 'Paris',
);
```

### Get Item Details
```dart
final firestoreService = ref.read(firestoreServiceProvider);
final item = await firestoreService.getItem('item_id');
```

### Get Items Feed (Stream)
```dart
// In your widget
final itemsFeed = ref.watch(itemsFeedProvider);

itemsFeed.whenData((items) {
  ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) => ItemCard(item: items[index]),
  );
});
```

### Search Items
```dart
final searchResults = ref.watch(searchItemsProvider('laptop'));
```

### Get User Items
```dart
final userItems = ref.watch(userItemsProvider('user_id'));
```

### Update Item
```dart
final firestoreService = ref.read(firestoreServiceProvider);
await firestoreService.updateItem(
  'item_id',
  {
    'title': 'New Title',
    'description': 'New Description',
  },
);
```

### Delete Item
```dart
final firestoreService = ref.read(firestoreServiceProvider);
await firestoreService.deleteItem('item_id');
```

## Storage Examples

### Upload Images
```dart
final storageService = ref.read(storageServiceProvider);
final imageUrls = await storageService.uploadItemImages(
  images: [File('path/to/image1.jpg'), File('path/to/image2.jpg')],
  userId: 'user_id',
);
```

### Upload Profile Photo
```dart
final storageService = ref.read(storageServiceProvider);
final photoUrl = await storageService.uploadUserPhoto(
  photo: File('path/to/photo.jpg'),
  userId: 'user_id',
);
```

### Delete Image
```dart
final storageService = ref.read(storageServiceProvider);
await storageService.deleteItemImage('https://...');
```

## Chat Examples

### Create Chat
```dart
final firestoreService = ref.read(firestoreServiceProvider);
final chat = await firestoreService.createOrGetChat(
  userId1: 'current_user_id',
  userId2: 'other_user_id',
  itemId: 'item_id',
  itemTitle: 'Item Title',
);
```

### Send Message
```dart
final firestoreService = ref.read(firestoreServiceProvider);
await firestoreService.sendMessage(
  chatId: 'chat_id',
  senderId: 'user_id',
  senderName: 'John Doe',
  senderPhotoUrl: 'https://...',
  text: 'Hello!',
);
```

### Get Chat Messages (Stream)
```dart
final messages = ref.watch(chatMessagesProvider('chat_id'));

messages.whenData((messageList) {
  ListView.builder(
    itemCount: messageList.length,
    itemBuilder: (context, index) {
      final message = messageList[index];
      return MessageBubble(
        text: message.text,
        isCurrentUser: message.senderId == currentUserId,
        timestamp: message.createdAt.toString(),
      );
    },
  );
});
```

### Get User Chats (Stream)
```dart
final chats = ref.watch(userChatsProvider('user_id'));

chats.whenData((chatList) {
  ListView.builder(
    itemCount: chatList.length,
    itemBuilder: (context, index) {
      final chat = chatList[index];
      return ChatPreviewCard(
        chat: chat,
        onTap: () => context.push('/chat/${chat.id}'),
      );
    },
  );
});
```

## Navigation Examples

### Navigate to Home
```dart
context.go('/home');
```

### Navigate to Item Details
```dart
context.push('/home/item/$itemId');
```

### Navigate to Chat
```dart
context.push('/chat/$chatId');
```

### Navigate to Add Item
```dart
context.push('/home/add-item');
```

### Navigate with Replacement
```dart
context.goNamed('auth');
```

### Go Back
```dart
context.pop();
```

## Riverpod Provider Examples

### Watch Provider in Widget
```dart
final data = ref.watch(itemsFeedProvider);

data.when(
  data: (items) => ListView(...),
  loading: () => LoadingWidget(),
  error: (err, stack) => ErrorWidget(message: err.toString()),
);
```

### Read Provider Once
```dart
final authService = ref.read(authServiceProvider);
```

### Refresh Provider
```dart
ref.refresh(itemsFeedProvider);
ref.refresh(userItemsProvider('user_id'));
```

### Watch Provider Family
```dart
final item = ref.watch(itemProvider('item_id'));
final messages = ref.watch(chatMessagesProvider('chat_id'));
```

## Error Handling Examples

### Try-Catch in Widget
```dart
try {
  await firestoreService.createItem(...);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Item created!')),
  );
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: ${e.toString()}')),
  );
}
```

### Async Data Handling
```dart
final currentUser = ref.watch(currentUserProvider);

currentUser.whenData((user) {
  if (user != null) {
    // Do something with user
  }
});
```

## Image Handling Examples

### Pick Multiple Images
```dart
final imagePicker = ImagePicker();
final images = await imagePicker.pickMultiImage();
```

### Display Cached Network Image
```dart
CachedNetworkImage(
  imageUrl: 'https://...',
  fit: BoxFit.cover,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
);
```

### Display Local File Image
```dart
Image.file(
  File('path/to/image.jpg'),
  fit: BoxFit.cover,
);
```

## Form Validation Examples

### Email Validation
```dart
bool isValidEmail(String email) {
  return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
}
```

### Password Strength
```dart
bool isStrongPassword(String password) {
  return password.length >= 6 &&
         password.contains(RegExp(r'[a-z]')) &&
         password.contains(RegExp(r'[A-Z]')) &&
         password.contains(RegExp(r'[0-9]'));
}
```

## Common Patterns

### Loading State Management
```dart
bool _isLoading = false;
String? _errorMessage;

setState(() {
  _isLoading = true;
  _errorMessage = null;
});

try {
  // Do something
} catch (e) {
  setState(() => _errorMessage = e.toString());
} finally {
  setState(() => _isLoading = false);
}
```

### Stream Handling with BuildContext
```dart
StreamBuilder<List<ItemModel>>(
  stream: firestoreService.getItemsFeed(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return LoadingWidget();
    }
    if (snapshot.hasError) {
      return ErrorWidget(message: snapshot.error.toString());
    }
    final items = snapshot.data ?? [];
    return ListView.builder(itemCount: items.length, ...);
  },
);
```

### Debouncing Search
```dart
Timer? _debounceTimer;

void _onSearchChanged(String query) {
  _debounceTimer?.cancel();
  _debounceTimer = Timer(Duration(milliseconds: 500), () {
    ref.refresh(searchItemsProvider(query));
  });
}
```

## Widget Composition Examples

### Item Card with Navigation
```dart
ItemCard(
  item: item,
  onTap: () => context.push('/home/item/${item.id}'),
);
```

### Error Boundary
```dart
item.when(
  data: (data) => ItemDetailScreen(item: data),
  loading: () => Scaffold(body: LoadingWidget()),
  error: (err, stack) => Scaffold(
    body: ErrorWidget(message: err.toString()),
  ),
);
```

### Bottom Nav with State Management
```dart
BottomNavBar(
  currentIndex: _currentIndex,
  onTap: (index) {
    setState(() => _currentIndex = index);
    _navigateTo(index);
  },
);
```

---

For more information, refer to the official documentation:
- [Firebase Docs](https://firebase.flutter.dev)
- [Flutter Docs](https://flutter.dev/docs)
- [Riverpod Docs](https://riverpod.dev)
- [GoRouter Docs](https://pub.dev/packages/go_router)
