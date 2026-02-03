# Developer Checklist

## Pre-Launch Checklist

### Firebase Setup
- [ ] Create Firebase project
- [ ] Enable Authentication (Email + Google)
- [ ] Create Firestore database
- [ ] Create Storage bucket
- [ ] Download `google-services.json` (Android)
- [ ] Download `GoogleService-Info.plist` (iOS)
- [ ] Place files in correct directories
- [ ] Configure Firebase rules (Firestore)
- [ ] Configure Firebase rules (Storage)
- [ ] Set up Google OAuth credentials
- [ ] Test Firebase connectivity

### Android Configuration
- [ ] Place `google-services.json` in `android/app/`
- [ ] Verify `compileSdk = 34` in build.gradle.kts
- [ ] Set `targetSdk = 34` in build.gradle.kts
- [ ] Ensure `minSdk = 23` for Firebase
- [ ] Update `applicationId` if needed
- [ ] Configure Android permissions (AndroidManifest.xml)
- [ ] Set up keystore for signing (release builds)
- [ ] Update SHA-1 fingerprint in Firebase Console
- [ ] Test on Android emulator
- [ ] Test on physical Android device

### iOS Configuration
- [ ] Place `GoogleService-Info.plist` in Xcode project
- [ ] Update bundle ID in Xcode
- [ ] Set deployment target to 12.0+
- [ ] Configure code signing team
- [ ] Set up provisioning profiles
- [ ] Add Google Sign-In URL scheme in Info.plist
- [ ] Run `pod install --repo-update`
- [ ] Test on iOS simulator
- [ ] Test on physical iOS device

### Firebase Configuration Code
- [ ] Update `lib/firebase_options.dart` with Android API key
- [ ] Update `lib/firebase_options.dart` with Android app ID
- [ ] Update `lib/firebase_options.dart` with iOS API key
- [ ] Update `lib/firebase_options.dart` with iOS app ID
- [ ] Update project ID in all configs
- [ ] Update storage bucket names
- [ ] Update messaging sender ID

### Firestore Setup
- [ ] Create `users` collection
- [ ] Create `items` collection
- [ ] Create `chats` collection with messages subcollection
- [ ] Set up Firestore rules:
  - [ ] Users collection rules
  - [ ] Items collection rules
  - [ ] Chats collection rules
  - [ ] Messages subcollection rules

### Storage Setup
- [ ] Create storage rules for items/
- [ ] Create storage rules for users/
- [ ] Test image upload
- [ ] Verify image access

### Code Review
- [ ] Review all screens for functionality
- [ ] Check error handling in services
- [ ] Verify Riverpod providers
- [ ] Test navigation flow
- [ ] Check form validation
- [ ] Review image handling

### Testing
- [ ] Sign up with email/password
- [ ] Sign in with email/password
- [ ] Sign in with Google
- [ ] Create item with images
- [ ] View item details
- [ ] Search for items
- [ ] Send chat message
- [ ] View user profile
- [ ] Delete item
- [ ] Sign out
- [ ] Test on different screen sizes

### Performance
- [ ] Test with slow network
- [ ] Verify image loading optimization
- [ ] Check memory usage
- [ ] Test on low-end device
- [ ] Verify Firebase latency
- [ ] Profile app performance

### Security
- [ ] Verify Firebase rules are correct
- [ ] Check API key restrictions
- [ ] Validate user inputs
- [ ] Test authentication flow
- [ ] Verify data access control
- [ ] Test error messages don't expose data

### Build & Release
- [ ] Clean project: `flutter clean`
- [ ] Run: `flutter pub get`
- [ ] Format code: `dart format lib/`
- [ ] Analyze: `flutter analyze`
- [ ] Build debug APK
- [ ] Build release APK
- [ ] Build iOS app
- [ ] Test debug and release builds

### Documentation
- [ ] Update README with project specifics
- [ ] Document API endpoints (if using backend)
- [ ] Create user guide
- [ ] Document known issues
- [ ] Add contribution guidelines
- [ ] Document development setup

### Deployment (Android)
- [ ] Create Google Play Developer account
- [ ] Set up app signing key
- [ ] Build release app bundle
- [ ] Create app listing
- [ ] Add screenshots (landscape and portrait)
- [ ] Add app description
- [ ] Set content rating
- [ ] Set privacy policy
- [ ] Submit for review

### Deployment (iOS)
- [ ] Create Apple Developer account
- [ ] Create distribution certificate
- [ ] Create app ID
- [ ] Create distribution provisioning profile
- [ ] Build release IPA
- [ ] Create App Store listing
- [ ] Add screenshots (all screen sizes)
- [ ] Add app preview video
- [ ] Set rating
- [ ] Add privacy policy
- [ ] Submit for review

### Post-Launch
- [ ] Monitor Firebase Console for errors
- [ ] Check user feedback
- [ ] Monitor app performance
- [ ] Check crash logs
- [ ] Plan updates/improvements
- [ ] Set up beta testing group
- [ ] Configure release notes
- [ ] Set up push notifications (if needed)

## Feature Checklists

### Authentication Feature
- [ ] Email validation working
- [ ] Password strength validation
- [ ] Password confirmation matching
- [ ] Sign up creates Firestore user doc
- [ ] Google Sign-In popup shows
- [ ] Google Sign-In creates user doc
- [ ] Session persists on app restart
- [ ] Logout clears user data
- [ ] Error messages display correctly

### Items (Marketplace) Feature
- [ ] Items load from Firestore
- [ ] Image picker works
- [ ] Multiple images can be selected
- [ ] Images upload to Storage
- [ ] Item card displays correctly
- [ ] Search filters items
- [ ] Item details page loads
- [ ] Image carousel works
- [ ] Type badge shows correctly
- [ ] Categories dropdown populated

### Chat Feature
- [ ] Chat initiation from item page
- [ ] Messages appear in real-time
- [ ] Message timestamps correct
- [ ] User names display
- [ ] Scroll to bottom on new message
- [ ] Chat list shows recent chats
- [ ] Message input clears after send
- [ ] Chat history loads on open

### Profile Feature
- [ ] User info displays correctly
- [ ] User's items list shows
- [ ] Can view own item details
- [ ] Can delete own items
- [ ] Logout works
- [ ] Delete account removes data

### Activity Feature
- [ ] Activity screen loads
- [ ] New requests show
- [ ] New messages indicator
- [ ] Navigation to chat from activity

## Common Issues Checklist

### If Firebase doesn't connect
- [ ] Check internet connection
- [ ] Verify Firebase credentials in firebase_options.dart
- [ ] Check google-services.json exists (Android)
- [ ] Check GoogleService-Info.plist exists (iOS)
- [ ] Check Firebase project is active
- [ ] Check API keys have right permissions

### If images don't upload
- [ ] Verify Storage bucket exists
- [ ] Check Storage rules allow write
- [ ] Verify file size isn't too large
- [ ] Check device storage permissions
- [ ] Check network connection

### If messages don't sync
- [ ] Check Firestore rules
- [ ] Verify chat collection exists
- [ ] Check user IDs match exactly
- [ ] Restart app to refresh connection
- [ ] Check internet connectivity

### If Google Sign-In fails
- [ ] Verify SHA-1 in Firebase Console (Android)
- [ ] Check OAuth client ID is correct
- [ ] Verify google-services.json is latest
- [ ] Check GoogleService-Info.plist is added (iOS)

## Performance Optimization Checklist

- [ ] Use CachedNetworkImage for all images
- [ ] Implement pagination for item feed
- [ ] Limit Firestore queries to needed fields
- [ ] Use `.select()` in Riverpod for specific updates
- [ ] Lazy load chat messages
- [ ] Optimize images before upload
- [ ] Use release build for performance testing
- [ ] Remove debug prints in production
- [ ] Enable ProGuard/R8 (Android release)

## Maintenance Checklist

- [ ] Regular Firebase backups
- [ ] Monitor Firestore usage/costs
- [ ] Review user feedback regularly
- [ ] Update dependencies monthly
- [ ] Fix reported bugs promptly
- [ ] Monitor Firebase security alerts
- [ ] Review access logs
- [ ] Update privacy policy as needed
- [ ] Implement analytics (optional)
- [ ] Plan feature releases

---

## Quick Reference

### File Locations
- Firebase config: `lib/firebase_options.dart`
- Services: `lib/services/`
- Screens: `lib/screens/`
- Widgets: `lib/widgets/`
- Providers: `lib/providers/`
- Android config: `android/app/build.gradle.kts`
- iOS config: `ios/Runner.xcworkspace`

### Important Commands
```bash
flutter clean && flutter pub get
flutter run -d android/ios/web
flutter build apk --release
flutter build ios --release
dart format lib/
flutter analyze
flutter test
```

### Contact & Support
For issues:
1. Check documentation files
2. Review Firebase console
3. Check Flutter/Dart versions
4. Review error logs
5. Check Riverpod documentation

---

**Last Updated**: January 2026
**Project Status**: Production Ready ✅
