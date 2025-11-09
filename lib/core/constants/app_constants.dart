/// AppConstants - Application-wide constants
class AppConstants {
  AppConstants._();
  
  // App Info
  static const String appName = 'TryWear AI';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Virtual Try-On Experience';
  
  // API Endpoints (Mock for now)
  static const String baseUrl = 'https://api.trywear.ai/v1';
  static const String aiTryOnEndpoint = '/try-on';
  static const String clothingCatalogEndpoint = '/clothing';
  
  // Storage Keys
  static const String themeKey = 'theme_mode';
  static const String userKey = 'user_data';
  static const String authTokenKey = 'auth_token';
  static const String onboardingKey = 'onboarding_completed';
  
  // Animation Durations
  static const Duration shortDuration = Duration(milliseconds: 200);
  static const Duration mediumDuration = Duration(milliseconds: 400);
  static const Duration longDuration = Duration(milliseconds: 600);
  
  // UI Constants
  static const double borderRadius = 16.0;
  static const double cardElevation = 0.0;
  static const double padding = 16.0;
  static const double glassOpacity = 0.15;
  static const double blurSigma = 10.0;
  
  // Image Constraints
  static const int maxImageSizeMB = 5;
  static const int imageQuality = 85;
  
  // Categories
  static const List<String> clothingCategories = [
    'All',
    'Shirts',
    'Pants',
    'Dresses',
    'Jackets',
    'Shoes',
    'Accessories',
  ];
  
  // Colors (for filters)
  static const List<String> colors = [
    'All',
    'Black',
    'White',
    'Red',
    'Blue',
    'Green',
    'Yellow',
    'Pink',
    'Purple',
  ];
  
  // Genders
  static const List<String> genders = [
    'All',
    'Men',
    'Women',
    'Unisex',
  ];
  
  // Error Messages
  static const String networkError = 'Network error. Please check your connection.';
  static const String authError = 'Authentication failed. Please try again.';
  static const String uploadError = 'Failed to upload image. Please try again.';
  static const String tryOnError = 'AI processing failed. Please try again.';
  
  // Success Messages
  static const String loginSuccess = 'Login successful!';
  static const String signupSuccess = 'Account created successfully!';
  static const String uploadSuccess = 'Image uploaded successfully!';
  static const String saveSuccess = 'Saved to your collection!';
}
