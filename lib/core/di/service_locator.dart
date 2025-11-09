import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/ai_tryon_repository.dart';
import '../../data/repositories/clothing_repository.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/tryon/tryon_bloc.dart';
import '../../presentation/blocs/clothing/clothing_bloc.dart';
import '../../presentation/blocs/theme/theme_bloc.dart';

/// Service Locator - Dependency Injection container
final getIt = GetIt.instance;

/// Setup all dependencies
Future<void> setupServiceLocator() async {
  // External Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  
  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      firebaseAuth: getIt<FirebaseAuth>(),
      firestore: getIt<FirebaseFirestore>(),
    ),
  );
  
  getIt.registerLazySingleton<AiTryOnRepository>(
    () => AiTryOnRepository(
      storage: getIt<FirebaseStorage>(),
      firestore: getIt<FirebaseFirestore>(),
    ),
  );
  
  getIt.registerLazySingleton<ClothingRepository>(
    () => ClothingRepository(),
  );
  
  // BLoCs
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(authRepository: getIt<AuthRepository>()),
  );
  
  getIt.registerFactory<TryOnBloc>(
    () => TryOnBloc(aiTryOnRepository: getIt<AiTryOnRepository>()),
  );
  
  getIt.registerFactory<ClothingBloc>(
    () => ClothingBloc(clothingRepository: getIt<ClothingRepository>()),
  );
  
  getIt.registerFactory<ThemeBloc>(
    () => ThemeBloc(prefs: getIt<SharedPreferences>()),
  );
}
