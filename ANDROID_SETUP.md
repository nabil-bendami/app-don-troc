# Android Configuration Guide

## Build Configuration (android/app/build.gradle.kts)

The Android build is pre-configured for Flutter and Firebase. Key settings:

```kotlin
android {
    namespace = "com.example.don_tro"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.example.don_tro"
        minSdk = 23  // Firebase requires API 23+
        targetSdk = 34
        versionCode = 1
        versionName = "1.0.0"
    }
}

dependencies {
    // Firebase and other dependencies are managed by pubspec.yaml
}
```

## Google Services Configuration

1. **Download google-services.json**
   - Go to Firebase Console > Project Settings
   - Download `google-services.json`
   - Place in `android/app/` directory

2. **Update Package Name (if needed)**
   - Current: `com.example.don_tro`
   - Update in:
     - `android/app/build.gradle.kts` (applicationId)
     - `android/app/AndroidManifest.xml`

3. **Gradle Setup**
   - Google Services plugin is already configured in `android/build.gradle.kts`

## Running on Android

```bash
# Build and run
flutter run -d android

# Build release APK
flutter build apk --release

# Build app bundle for Play Store
flutter build appbundle --release
```

## Permissions

Required permissions in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.CAMERA" />
```

## Testing on Emulator

```bash
# List available devices
flutter devices

# Run on emulator
flutter run -d emulator-5554
```

## Key Files

- `android/app/build.gradle.kts` - App-level build config
- `android/build.gradle.kts` - Project-level build config
- `android/app/src/main/AndroidManifest.xml` - App manifest
- `android/gradle/wrapper/gradle-wrapper.properties` - Gradle version
