# 🚀 TryWear AI - Complete Setup Guide

This guide will help you set up and run the TryWear AI application.

---

## 📋 Prerequisites Checklist

Before you begin, ensure you have:

- ✅ Flutter SDK (3.9.2 or higher) installed
- ✅ Dart SDK installed
- ✅ Android Studio or Xcode (for mobile development)
- ✅ VS Code or Android Studio (IDE)
- ✅ Firebase account (free tier is sufficient)
- ✅ Git installed

---

## 🔥 Firebase Configuration (IMPORTANT)

### Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: `trywear-ai` (or your choice)
4. Disable Google Analytics (optional)
5. Click "Create project"

### Step 2: Add Apps to Firebase

#### For Android:

1. In Firebase Console, click Android icon
2. Enter package name: `com.example.tryonu`
3. Download `google-services.json`
4. Place it in: `android/app/google-services.json`

#### For iOS:

1. In Firebase Console, click iOS icon
2. Enter bundle ID: `com.example.tryonu`
3. Download `GoogleService-Info.plist`
4. Place it in: `ios/Runner/GoogleService-Info.plist`

### Step 3: Enable Firebase Services

#### Authentication:
1. Go to Authentication → Sign-in method
2. Enable **Email/Password**
3. Enable **Google Sign-In**
   - Add your email as test user if needed

#### Cloud Firestore:
1. Go to Firestore Database → Create database
2. Start in **test mode** (we'll secure it later)
3. Choose a location (e.g., us-central1)

#### Storage:
1. Go to Storage → Get started
2. Start in **test mode**
3. Your storage bucket will be auto-created

### Step 4: Update Firebase Options

Open `lib/firebase_options.dart` and replace the placeholder values with your actual Firebase credentials:

```dart
// Get these from Firebase Console → Project Settings → Your apps

static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ANDROID_API_KEY',           // From google-services.json
  appId: 'YOUR_ANDROID_APP_ID',             // From google-services.json
  messagingSenderId: 'YOUR_SENDER_ID',      // From google-services.json
  projectId: 'YOUR_PROJECT_ID',             // Your Firebase project ID
  storageBucket: 'YOUR_PROJECT_ID.appspot.com',
);

// Similar for iOS, web, and macOS
```

### Step 5: Security Rules (Production)

#### Firestore Rules:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /try_on_results/{resultId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

#### Storage Rules:
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /user_photos/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

---

## 💻 Installation Steps

### 1. Clone Repository

```bash
cd /Users/ahsanraza/StudioProjects/tryonu
# Repository is already cloned
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Verify Flutter Setup

```bash
flutter doctor
```

Fix any issues shown by `flutter doctor` before proceeding.

### 4. Update Android Configuration (if needed)

Edit `android/app/build.gradle`:

```gradle
android {
    compileSdk 34
    
    defaultConfig {
        applicationId "com.example.tryonu"
        minSdk 21
        targetSdk 34
        // ... rest of config
    }
}
```

Add at the bottom of the file:
```gradle
apply plugin: 'com.google.gms.google-services'
```

Edit `android/build.gradle`:
```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.4.0'
}
```

### 5. iOS Configuration (if developing for iOS)

1. Open `ios/Runner.xcworkspace` in Xcode
2. Set your team in Signing & Capabilities
3. Ensure `GoogleService-Info.plist` is added to the project

---

## 🏃‍♂️ Running the App

### Option 1: Using Command Line

```bash
# Run on connected device
flutter run

# Run on specific device
flutter devices
flutter run -d <device_id>

# Run in debug mode with hot reload
flutter run --debug

# Run in release mode
flutter run --release
```

### Option 2: Using IDE

#### VS Code:
1. Open Command Palette (Cmd/Ctrl + Shift + P)
2. Select "Flutter: Select Device"
3. Press F5 to run

#### Android Studio:
1. Select device from device dropdown
2. Click Run button (green play icon)

---

## 🧪 Testing the App

### Test Authentication:

1. Launch app → should show login screen
2. Click "Sign Up" → create account with email
3. Try Google Sign-In (if configured)
4. Verify you're redirected to Home screen

### Test Explore Feature:

1. Go to Explore tab
2. Browse clothing items
3. Try search functionality
4. Test category filters

### Test Try-On (Mock):

1. Go to Try-On tab
2. Upload a photo (camera or gallery)
3. Select a clothing item
4. Click "Try On Now"
5. Wait for processing (3 seconds mock delay)
6. View result and save

### Test Profile:

1. Go to Profile tab
2. Toggle Dark/Light mode
3. Try Sign Out

---

## 🐛 Troubleshooting

### Common Issues:

#### 1. Firebase Not Initialized
```
Error: Firebase not initialized
```
**Solution**: Ensure `google-services.json` and `GoogleService-Info.plist` are in the correct locations.

#### 2. Google Sign-In Not Working
```
PlatformException: sign_in_failed
```
**Solution**: 
- Add SHA-1 certificate to Firebase Console
- Enable Google Sign-In in Firebase Authentication
- For Android: `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey`

#### 3. Build Errors
```
Gradle build failed
```
**Solution**:
- Run `flutter clean`
- Run `flutter pub get`
- Invalidate caches in Android Studio

#### 4. Dependency Conflicts
```
Version solving failed
```
**Solution**:
- Check `pubspec.yaml` for conflicts
- Run `flutter pub upgrade --major-versions`

---

## 📱 Building for Release

### Android APK:

```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### iOS IPA:

```bash
# Build for iOS
flutter build ios --release
```

Then archive in Xcode for App Store submission.

---

## 🎨 Customization Guide

### Change App Colors:

Edit `lib/core/theme/app_colors.dart`:

```dart
static const primary = Color(0xFF5E5CE6);  // Change this
static const accent = Color(0xFF00F0FF);   // And this
```

### Change App Name:

1. Edit `pubspec.yaml`: `name: your_app_name`
2. Android: `android/app/src/main/AndroidManifest.xml`
3. iOS: Open in Xcode → General → Display Name

### Add New Screen:

1. Create file in `lib/presentation/views/your_feature/`
2. Add route in `lib/main.dart`
3. Navigate using `Navigator.pushNamed()`

---

## 🔐 Security Best Practices

### Before Production:

1. ✅ Update Firebase security rules (see Step 5 above)
2. ✅ Enable App Check in Firebase
3. ✅ Use environment variables for API keys
4. ✅ Enable ProGuard for Android (release builds)
5. ✅ Test all authentication flows
6. ✅ Implement rate limiting
7. ✅ Add crash reporting (Firebase Crashlytics)

---

## 📊 Performance Optimization

### Tips:

1. Use `const` constructors where possible
2. Implement pagination for clothing list
3. Optimize images before upload
4. Use Firebase Storage caching
5. Enable code splitting for web
6. Profile with Flutter DevTools

---

## 🆘 Getting Help

### Resources:

- **Flutter Docs**: https://docs.flutter.dev
- **Firebase Docs**: https://firebase.google.com/docs
- **BLoC Library**: https://bloclibrary.dev
- **Stack Overflow**: Tag with `flutter` and `firebase`

### Project Structure:

```
lib/
├── core/              # Shared utilities, theme, constants
├── data/              # Models and repositories
├── presentation/      # UI and state management
│   ├── blocs/        # BLoC files
│   ├── views/        # Screens
│   └── widgets/      # Reusable widgets
├── firebase_options.dart
└── main.dart         # App entry point
```

---

## ✅ Verification Checklist

Before running:

- [ ] Firebase project created
- [ ] `google-services.json` added (Android)
- [ ] `GoogleService-Info.plist` added (iOS)
- [ ] `lib/firebase_options.dart` updated with your credentials
- [ ] Authentication, Firestore, and Storage enabled in Firebase
- [ ] `flutter pub get` executed successfully
- [ ] `flutter doctor` shows no critical issues
- [ ] Device/emulator connected

---

## 🎉 Next Steps

Once the app is running:

1. Test all features thoroughly
2. Customize the UI to match your brand
3. Integrate a real AI try-on API
4. Add analytics and crash reporting
5. Implement in-app purchases (if applicable)
6. Prepare for App Store/Play Store submission

---

## 📝 Notes

- The AI try-on feature currently uses **mock data**
- Replace mock implementation in `lib/data/repositories/ai_tryon_repository.dart`
- See README.md for detailed AI integration guide
- All clothing images use Unsplash URLs (free to use)

---

**Good luck with your TryWear AI app! 🚀**

For issues, check the troubleshooting section or create an issue on GitHub.
