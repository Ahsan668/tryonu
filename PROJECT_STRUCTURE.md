# 📁 TryWear AI - Project Structure Documentation

This document provides a comprehensive overview of the project structure and code organization.

---

## 📂 Directory Structure

```
tryonu/
├── android/                    # Android native code
├── ios/                        # iOS native code
├── lib/                        # Main Flutter application code
│   ├── core/                   # Core functionality and utilities
│   │   ├── constants/
│   │   │   └── app_constants.dart
│   │   ├── di/
│   │   │   └── service_locator.dart
│   │   ├── theme/
│   │   │   ├── app_colors.dart
│   │   │   └── app_theme.dart
│   │   └── utils/
│   │       ├── extensions.dart
│   │       └── validators.dart
│   ├── data/                   # Data layer
│   │   ├── models/
│   │   │   ├── clothing_item_model.dart
│   │   │   ├── try_on_result_model.dart
│   │   │   └── user_model.dart
│   │   └── repositories/
│   │       ├── ai_tryon_repository.dart
│   │       ├── auth_repository.dart
│   │       └── clothing_repository.dart
│   ├── presentation/           # Presentation layer
│   │   ├── blocs/
│   │   │   ├── auth/
│   │   │   │   ├── auth_bloc.dart
│   │   │   │   ├── auth_event.dart
│   │   │   │   └── auth_state.dart
│   │   │   ├── clothing/
│   │   │   │   ├── clothing_bloc.dart
│   │   │   │   ├── clothing_event.dart
│   │   │   │   └── clothing_state.dart
│   │   │   ├── theme/
│   │   │   │   ├── theme_bloc.dart
│   │   │   │   ├── theme_event.dart
│   │   │   │   └── theme_state.dart
│   │   │   └── tryon/
│   │   │       ├── tryon_bloc.dart
│   │   │       ├── tryon_event.dart
│   │   │       └── tryon_state.dart
│   │   ├── views/
│   │   │   ├── auth/
│   │   │   │   ├── login_screen.dart
│   │   │   │   └── register_screen.dart
│   │   │   ├── explore/
│   │   │   │   └── explore_screen.dart
│   │   │   ├── home/
│   │   │   │   └── home_screen.dart
│   │   │   ├── profile/
│   │   │   │   └── profile_screen.dart
│   │   │   ├── tryon/
│   │   │   │   └── tryon_screen.dart
│   │   │   └── splash_screen.dart
│   │   └── widgets/
│   │       ├── clothing_card.dart
│   │       ├── custom_text_field.dart
│   │       ├── glass_card.dart
│   │       ├── loading_indicator.dart
│   │       └── primary_button.dart
│   ├── firebase_options.dart   # Firebase configuration
│   └── main.dart               # App entry point
├── assets/                     # Static assets
│   ├── animations/
│   ├── images/
│   └── icons/
├── test/                       # Unit and widget tests
├── pubspec.yaml               # Dependencies and assets
├── README.md                  # Project documentation
├── SETUP_GUIDE.md            # Setup instructions
└── PROJECT_STRUCTURE.md      # This file
```

---

## 🏗️ Architecture Layers

### 1. **Core Layer** (`lib/core/`)

Contains application-wide utilities and configurations.

#### **Theme** (`core/theme/`)
- `app_colors.dart`: Color palette and gradients
- `app_theme.dart`: Theme configuration for light/dark modes

#### **Constants** (`core/constants/`)
- `app_constants.dart`: App-wide constants (names, durations, categories)

#### **Utils** (`core/utils/`)
- `validators.dart`: Input validation functions
- `extensions.dart`: Utility extensions for BuildContext, String, DateTime

#### **Dependency Injection** (`core/di/`)
- `service_locator.dart`: GetIt configuration for DI

---

### 2. **Data Layer** (`lib/data/`)

Handles data operations and business logic.

#### **Models** (`data/models/`)

Data transfer objects with JSON serialization:

- **`user_model.dart`**: User profile data
  ```dart
  UserModel(uid, email, displayName, photoUrl, createdAt)
  ```

- **`clothing_item_model.dart`**: Clothing catalog items
  ```dart
  ClothingItemModel(id, name, description, imageUrl, category, price, ...)
  ```

- **`try_on_result_model.dart`**: Try-on results
  ```dart
  TryOnResultModel(id, userId, userPhotoUrl, resultImageUrl, ...)
  ```

#### **Repositories** (`data/repositories/`)

Data sources and API integrations:

- **`auth_repository.dart`**: Authentication operations
  - Sign in/up with email
  - Google Sign-In
  - Password reset
  - Sign out

- **`clothing_repository.dart`**: Clothing catalog management
  - Get all items (mock data)
  - Filter by category/color/gender
  - Search functionality

- **`ai_tryon_repository.dart`**: AI try-on operations
  - Upload user photos
  - Process try-on (mock AI)
  - Save/delete results
  - Get history

---

### 3. **Presentation Layer** (`lib/presentation/`)

UI components and state management.

#### **BLoCs** (`presentation/blocs/`)

State management following BLoC + MVI pattern:

**Auth Bloc**:
- Events: SignIn, SignUp, SignOut, ResetPassword
- States: Initial, Loading, Authenticated, Unauthenticated, Error

**Clothing Bloc**:
- Events: Load, Filter, Search, GetDetail
- States: Initial, Loading, Loaded, Empty, Error

**TryOn Bloc**:
- Events: UploadPhoto, Process, Save, Delete
- States: Initial, Loading, PhotoUploaded, Processing, Success, Error

**Theme Bloc**:
- Events: Toggle, Change, Load
- States: ThemeState (with ThemeMode)

#### **Views** (`presentation/views/`)

Screen implementations:

- **`splash_screen.dart`**: Animated app launch
- **`auth/login_screen.dart`**: Email and Google sign-in
- **`auth/register_screen.dart`**: User registration
- **`home/home_screen.dart`**: Bottom navigation hub
- **`explore/explore_screen.dart`**: Clothing catalog browser
- **`tryon/tryon_screen.dart`**: Virtual try-on interface
- **`profile/profile_screen.dart`**: User profile and settings

#### **Widgets** (`presentation/widgets/`)

Reusable UI components:

- **`primary_button.dart`**: Gradient button with glow
- **`custom_text_field.dart`**: Glassmorphic input field
- **`glass_card.dart`**: Glassmorphism container
- **`clothing_card.dart`**: Product display card
- **`loading_indicator.dart`**: Loading animation

---

## 🔄 Data Flow (MVI Pattern)

```
User Action → Event → Bloc → Repository → Firebase/API
                ↓
              State
                ↓
           UI Update
```

### Example: Login Flow

1. User enters credentials and taps "Sign In"
2. UI dispatches `AuthSignInWithEmailRequested` event
3. `AuthBloc` receives event and emits `AuthLoading` state
4. `AuthBloc` calls `AuthRepository.signInWithEmail()`
5. `AuthRepository` communicates with Firebase Auth
6. On success: `AuthBloc` emits `AuthAuthenticated` state
7. On error: `AuthBloc` emits `AuthError` state
8. UI reacts to state changes and updates accordingly

---

## 🎨 Theme System

### Color Management

All colors defined in `app_colors.dart`:

```dart
// Primary colors
AppColors.primary
AppColors.secondary
AppColors.accent

// Backgrounds
AppColors.backgroundDark
AppColors.backgroundLight

// Glassmorphism
AppColors.glassLight
AppColors.glassDark

// Gradients
AppColors.primaryGradient
AppColors.neonGradient
```

### Theme Switching

Managed by `ThemeBloc`:

```dart
// Toggle dark/light mode
context.read<ThemeBloc>().add(ThemeToggled());

// Set specific mode
context.read<ThemeBloc>().add(
  ThemeChanged(themeMode: ThemeMode.dark)
);
```

---

## 🔐 Authentication Flow

```
App Start
    ↓
AuthBloc checks auth status
    ↓
├─ User logged in → HomeScreen
└─ User not logged in → LoginScreen
    ↓
User signs in
    ↓
Firebase authenticates
    ↓
UserModel created/fetched from Firestore
    ↓
HomeScreen (with bottom navigation)
```

---

## 📸 Try-On Flow

```
TryOnScreen
    ↓
User uploads photo
    ↓
TryOnBloc uploads to Firebase Storage
    ↓
PhotoUrl stored in state
    ↓
User selects clothing item
    ↓
User taps "Try On Now"
    ↓
AiTryOnRepository processes (mock 3s delay)
    ↓
Result saved to Firestore
    ↓
Result displayed in dialog
    ↓
User can save/share/dismiss
```

---

## 🛍️ Explore Flow

```
ExploreScreen
    ↓
ClothingBloc loads items
    ↓
User can:
├─ Search by name/description
├─ Filter by category
├─ Filter by color
└─ Filter by gender
    ↓
Tap item → Navigate to detail view
```

---

## 🗄️ Firebase Structure

### Firestore Collections:

```
/users/{uid}
    email: string
    displayName: string
    photoUrl: string
    createdAt: timestamp
    updatedAt: timestamp

/try_on_results/{resultId}
    userId: string
    userPhotoUrl: string
    clothingItemId: string
    resultImageUrl: string
    createdAt: timestamp
    isSaved: boolean
```

### Storage Buckets:

```
/user_photos/{userId}_{timestamp}.jpg
/try_on_results/{resultId}.jpg
```

---

## 🧩 Dependency Injection

Using `GetIt` for service location:

```dart
// Register repositories
getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());

// Register BLoCs
getIt.registerFactory<AuthBloc>(() => AuthBloc(
  authRepository: getIt<AuthRepository>()
));

// Use in app
final authBloc = getIt<AuthBloc>();
```

---

## 📝 Code Conventions

### Naming:

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables**: `camelCase`
- **Constants**: `camelCase` or `SCREAMING_SNAKE_CASE`
- **Private members**: `_leadingUnderscore`

### File Organization:

1. Imports (Flutter → package → relative)
2. Class/function documentation
3. Class definition
4. Constructor
5. Public methods
6. Private methods
7. Build method (for widgets)

### Comments:

```dart
/// Public API documentation (three slashes)
// Implementation notes (two slashes)
```

---

## 🧪 Testing Structure

```
test/
├── unit/
│   ├── models/
│   ├── repositories/
│   └── blocs/
├── widget/
│   └── widgets/
└── integration/
    └── flows/
```

---

## 🚀 Build Configurations

### Development:
```bash
flutter run --debug
```

### Staging:
```bash
flutter run --profile
```

### Production:
```bash
flutter build apk --release
flutter build ios --release
```

---

## 📊 Performance Considerations

### Optimizations Implemented:

1. **Lazy Loading**: BLoCs registered as factories
2. **Image Caching**: Using `cached_network_image`
3. **Const Constructors**: Used where possible
4. **State Optimization**: Equatable for efficient state comparison
5. **Memory Management**: Proper disposal of controllers

### Future Optimizations:

- [ ] Implement pagination for clothing list
- [ ] Add image compression before upload
- [ ] Implement proper error boundaries
- [ ] Add offline support with local database
- [ ] Optimize bundle size

---

## 🔧 Configuration Files

### `pubspec.yaml`
- Dependencies
- Assets configuration
- Flutter SDK version

### `firebase_options.dart`
- Platform-specific Firebase configuration
- API keys and project IDs

### `service_locator.dart`
- Dependency injection setup
- Service registration

---

## 📱 Platform-Specific Code

### Android (`android/`)
- `build.gradle`: Build configuration
- `AndroidManifest.xml`: Permissions and app config
- `google-services.json`: Firebase config

### iOS (`ios/`)
- `Podfile`: CocoaPods dependencies
- `Info.plist`: App configuration
- `GoogleService-Info.plist`: Firebase config

---

## 🎯 Key Features Implementation

### Glassmorphism UI:
- Implemented in `glass_card.dart`
- Uses `BackdropFilter` with `ImageFilter.blur`
- Gradient overlays for depth

### Neon Glow:
- Implemented in buttons and active states
- Uses `BoxShadow` with color opacity
- Animated transitions

### Theme Switching:
- Persistent storage via SharedPreferences
- BLoC for state management
- Instant UI updates

---

This structure ensures maintainability, scalability, and follows Flutter best practices. Each layer has a clear responsibility, making the codebase easy to understand and extend.
