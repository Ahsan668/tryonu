import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/di/service_locator.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/auth/auth_event.dart';
import 'presentation/blocs/auth/auth_state.dart';
import 'presentation/blocs/tryon/tryon_bloc.dart';
import 'presentation/blocs/clothing/clothing_bloc.dart';
import 'presentation/blocs/theme/theme_bloc.dart';
import 'presentation/blocs/theme/theme_event.dart';
import 'presentation/blocs/theme/theme_state.dart';
import 'presentation/views/splash_screen.dart';
import 'presentation/views/auth/login_screen.dart';
import 'presentation/views/auth/register_screen.dart';
import 'presentation/views/home/home_screen.dart';
import 'presentation/views/auth/forgot_password_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'presentation/views/explore/explore_screen.dart';
import 'data/models/clothing_item_model.dart';
import 'presentation/views/explore/clothing_detail_screen.dart';

/// Main entry point of TryWear AI application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Setup dependency injection
  await setupServiceLocator();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const TryWearApp());
}

/// Root application widget
class TryWearApp extends StatelessWidget {
  const TryWearApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Theme Bloc
        BlocProvider<ThemeBloc>(
          create: (context) => getIt<ThemeBloc>()
            ..add(const ThemeLoadRequested()),
        ),
        
        // Auth Bloc
        BlocProvider<AuthBloc>(
          create: (context) => getIt<AuthBloc>()
            ..add(const AuthCheckRequested()),
        ),
        
        // Try-On Bloc
        BlocProvider<TryOnBloc>(
          create: (context) => getIt<TryOnBloc>(),
        ),
        
        // Clothing Bloc
        BlocProvider<ClothingBloc>(
          create: (context) => getIt<ClothingBloc>(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            
            // Theme
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.themeMode,
            
            // Initial route
            home: const AppInitializer(),
            
            // Routes
            routes: {
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/home': (context) => const HomeScreen(),
              '/forgot-password': (context) => const ForgotPasswordScreen(),
              '/explore': (context) => const ExploreScreen(),
              '/clothing-detail': (context) {
                final args = ModalRoute.of(context)!.settings.arguments;
                final item = args is ClothingItemModel ? args : null;
                return ClothingDetailScreen(item: item);
              },
            },
          );
        },
      ),
    );
  }
}

/// AppInitializer - Handles initial app routing based on auth state
class AppInitializer extends StatelessWidget {
  const AppInitializer({super.key});
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial || state is AuthLoading) {
          return const SplashScreen();
        } else if (state is AuthAuthenticated) {
          return const HomeScreen();
        } else if (state is AuthUnauthenticated || state is AuthError) {
          return const LoginScreen();
        }
        
        return const SplashScreen();
      },
    );
  }
}
