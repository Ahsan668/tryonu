# 🎨 TryWear AI - Virtual Try-On Application

<div align="center">

**A futuristic virtual try-on application built with Flutter**

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

</div>

---

## 📱 About

TryWear AI is a cutting-edge virtual try-on application that allows users to upload their photos and virtually try on clothes from different stores using AI-generated overlays. Built with modern Flutter architecture and featuring a futuristic glassmorphism UI with neon gradient accents.

### ✨ Key Features

- **🔐 Authentication**: Email/Password and Google Sign-In
- **📸 Virtual Try-On**: Upload photos and apply AI-generated clothing overlays
- **🛍️ Explore Catalog**: Browse clothing items with advanced filters
- **❤️ Favorites**: Save and manage try-on results
- **📜 History**: View past try-on sessions
- **🌗 Theme Modes**: Beautiful Light and Dark modes
- **🎨 Glassmorphism UI**: Modern, futuristic interface design
- **⚡ Smooth Animations**: Seamless transitions and interactions

---

## 🏗️ Architecture

This app follows **Clean Architecture** principles with **Bloc + MVI** pattern:

```
lib/
├── core/
│   ├── theme/              # Theme system (colors, styles)
│   ├── constants/          # App-wide constants
│   ├── utils/              # Utilities (validators, extensions)
│   └── di/                 # Dependency Injection setup
├── data/
│   ├── models/             # Data models
│   └── repositories/       # Data repositories
├── domain/
│   └── usecases/           # Business logic (future expansion)
├── presentation/
│   ├── blocs/              # State management (BLoC)
│   ├── views/              # UI screens
│   └── widgets/            # Reusable widgets
└── main.dart               # App entry point
```

### 🔧 Design Patterns

- **Bloc + MVI**: Model-View-Intent pattern for predictable state management
- **Repository Pattern**: Abstraction layer for data sources
- **Dependency Injection**: Using `get_it` for loose coupling
- **Clean Architecture**: Separation of concerns across layers

---

## 🎨 UI/UX Design

### Design Principles

- **Glassmorphism**: Frosted glass effect with blur and transparency
- **Neon Gradients**: Purple-blue gradient with cyan accents
- **Modern Typography**: Poppins/Inter fonts for readability
- **Smooth Animations**: Implicit animations and custom transitions
- **Responsive**: Adapts to different screen sizes

### Color Palette

```dart
Primary: #5E5CE6 (Purple)
Secondary: #8E8DFF (Light Purple)
Accent: #00F0FF (Neon Cyan)
Background Dark: #0F0F1A
Background Light: #F4F6FB
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.9.2)
- Dart SDK
- Android Studio / Xcode
- Firebase Account

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd tryonu
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication (Email/Password and Google)
   - Enable Cloud Firestore
   - Enable Storage
   - Download configuration files:
     - Android: `google-services.json` → `android/app/`
     - iOS: `GoogleService-Info.plist` → `ios/Runner/`
   - Update `lib/firebase_options.dart` with your project credentials

4. **Run the app**
   ```bash
   flutter run
   ```

---

## 📦 Dependencies

### State Management & Architecture
- `flutter_bloc: ^8.1.3` - BLoC pattern implementation
- `equatable: ^2.0.5` - Value equality
- `get_it: ^7.6.4` - Dependency injection

### Firebase
- `firebase_core: ^2.24.2` - Firebase core SDK
- `firebase_auth: ^4.15.3` - Authentication
- `cloud_firestore: ^4.13.6` - Database
- `firebase_storage: ^11.5.6` - File storage
- `google_sign_in: ^6.1.6` - Google authentication

### UI/UX
- `google_fonts: ^6.1.0` - Custom fonts
- `lottie: ^2.7.0` - Animations
- `animations: ^2.0.8` - Page transitions
- `flutter_glow: ^0.2.0` - Glow effects
- `cached_network_image: ^3.3.0` - Image caching

### Other
- `dio: ^5.3.3` - HTTP client
- `image_picker: ^1.0.4` - Image selection
- `shared_preferences: ^2.2.2` - Local storage

---

## 🧩 Key Components

### Custom Widgets

- **`PrimaryButton`**: Gradient button with glow effects
- **`CustomTextField`**: Glassmorphic input field
- **`GlassCard`**: Reusable glassmorphism card
- **`ClothingCard`**: Product display card
- **`LoadingIndicator`**: Animated loading state

### Screens

- **Splash Screen**: Animated app launch
- **Login/Register**: Authentication flow
- **Home**: Main navigation hub
- **Explore**: Browse clothing catalog
- **Try-On**: Virtual try-on interface
- **Profile**: User settings and preferences

---

## 🔥 Firebase Setup Guide

### 1. Authentication

Enable in Firebase Console:
- Email/Password
- Google Sign-In

### 2. Firestore Structure

```
users/
├── {uid}/
│   ├── email: string
│   ├── displayName: string
│   ├── photoUrl: string
│   ├── createdAt: timestamp
│   └── updatedAt: timestamp

try_on_results/
├── {resultId}/
│   ├── userId: string
│   ├── userPhotoUrl: string
│   ├── clothingItemId: string
│   ├── resultImageUrl: string
│   ├── createdAt: timestamp
│   └── isSaved: boolean
```

### 3. Storage Buckets

```
user_photos/
└── {userId}_{timestamp}.jpg

try_on_results/
└── {resultId}.jpg
```

---

## 🤖 AI Integration

Currently using **mock AI processing**. To integrate real AI:

1. Choose an AI service:
   - HuggingFace
   - DeepFashion2
   - Custom ML model

2. Update `lib/data/repositories/ai_tryon_repository.dart`:
   ```dart
   Future<TryOnResultModel> tryOnClothing({
     required String userId,
     required String userPhotoUrl,
     required String clothingItemId,
   }) async {
     // Replace with actual API call
     final response = await dio.post(
       'YOUR_AI_API_ENDPOINT',
       data: {
         'user_photo': userPhotoUrl,
         'clothing_id': clothingItemId,
       },
     );
     // Process response...
   }
   ```

---

## 🎯 Roadmap

- [ ] Integrate real AI try-on API
- [ ] Add social sharing features
- [ ] Implement clothing recommendations
- [ ] Add AR try-on mode
- [ ] Multi-language support
- [ ] Shopping cart and checkout
- [ ] User reviews and ratings

---

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test

# Generate coverage
flutter test --coverage
```

---

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS  
- ✅ Web (with limitations)
- ⚠️ macOS (experimental)

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Your Name**
- GitHub: [@yourusername](https://github.com/yourusername)

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Design inspiration from Apple VisionOS and Tesla UI

---

<div align="center">

**Made with ❤️ and Flutter**

⭐ Star this repo if you find it helpful!

</div>
