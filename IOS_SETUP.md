# iOS Configuration Guide

## Cocoapods Setup

1. **Install Cocoapods (if not already installed)**
   ```bash
   sudo gem install cocoapods
   ```

2. **Update Pods**
   ```bash
   cd ios
   pod repo update
   pod install --repo-update
   cd ..
   ```

## Firebase Configuration

1. **Download GoogleService-Info.plist**
   - Go to Firebase Console > Project Settings
   - Download `GoogleService-Info.plist`
   - Open Xcode: `open ios/Runner.xcworkspace`
   - Drag `GoogleService-Info.plist` into Runner project
   - Check "Copy items if needed" and "Add to targets: Runner"

2. **Update ios/Podfile**
   
   The minimum deployment target should be 12.0:
   
   ```ruby
   post_install do |installer|
     installer.pods_project.targets.each do |target|
       flutter_additional_ios_build_settings(target)
       
       # Ensure iOS deployment target is 12.0+
       target.build_configurations.each do |config|
        config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
          '$(inherited)',
          'FIREBASE_ANALYTICS_COLLECTION_ENABLED=1'
        ]
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end
    end
  end
   ```

## Code Signing & Provisioning

1. **Update Bundle ID**
   - Open `ios/Runner.xcworkspace` in Xcode
   - Select Runner project
   - Select Runner target
   - General tab > Bundle Identifier
   - Update to your domain (e.g., `com.yourcompany.don-tro`)

2. **Code Signing**
   - Signing & Capabilities tab
   - Ensure "Automatically manage signing" is checked
   - Select your Team

3. **Add Google Sign-In Configuration**
   - Go to `ios/Runner/Info.plist`
   - Add Google Sign-In URL scheme:
   ```xml
   <key>CFBundleURLTypes</key>
   <array>
     <dict>
       <key>CFBundleTypeRole</key>
       <string>Editor</string>
       <key>CFBundleURLSchemes</key>
       <array>
         <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
       </array>
     </dict>
   </array>
   ```

## Running on iOS

```bash
# Clean build
flutter clean
cd ios
rm -rf Pods Podfile.lock
pod install --repo-update
cd ..

# Run
flutter run -d ios

# Build release IPA
flutter build ios --release
```

## Physical Device Testing

```bash
# List connected devices
flutter devices

# Run on device
flutter run -d <device-id>
```

## Troubleshooting

### Pod Installation Issues
```bash
cd ios
rm -rf Pods Podfile.lock .symlinks/ Flutter/Flutter.podspec
pod install --repo-update
cd ..
```

### Build Cache Issues
```bash
flutter clean
cd ios
rm -rf Pods Podfile.lock
pod install --repo-update
cd ..
flutter pub get
```

### Version Compatibility
- Minimum iOS: 12.0
- Target iOS: Latest stable
- Firebase requires iOS 11.0+

## Key Files

- `ios/Runner/Info.plist` - App configuration
- `ios/Podfile` - Cocoapods dependencies
- `ios/Runner.xcworkspace` - Xcode workspace (use this, not .xcodeproj)
- `ios/Runner/GeneratedPluginRegistrant.m` - Auto-generated plugin registry
