import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// AuthBloc - Handles authentication business logic
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  
  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthInitial()) {
    
    // Listen to auth state changes
    _authRepository.authStateChanges.listen((user) {
      if (user != null) {
        add(const AuthCheckRequested());
      } else {
        emit(const AuthUnauthenticated());
      }
    });
    
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignInWithEmailRequested>(_onSignInWithEmail);
    on<AuthSignUpWithEmailRequested>(_onSignUpWithEmail);
    on<AuthSignInWithGoogleRequested>(_onSignInWithGoogle);
    on<AuthResetPasswordRequested>(_onResetPassword);
    on<AuthSignOutRequested>(_onSignOut);
  }
  
  /// Check authentication status
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = _authRepository.currentUser;
      if (user != null) {
        final userModel = await _authRepository.getUserData(user.uid);
        emit(AuthAuthenticated(user: userModel));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e, st) {
      debugPrint('Auth check failed: $e');
      debugPrintStack(stackTrace: st);
      emit(AuthError(message: e.toString()));
    }
  }
  
  /// Sign in with email
  Future<void> _onSignInWithEmail(
    AuthSignInWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.signInWithEmail(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user: user));
    } catch (e, st) {
      debugPrint('Sign in with email failed for ${event.email}: $e');
      debugPrintStack(stackTrace: st);
      emit(AuthError(message: e.toString()));
    }
  }
  
  /// Sign up with email
  Future<void> _onSignUpWithEmail(
    AuthSignUpWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.signUpWithEmail(
        email: event.email,
        password: event.password,
        displayName: event.displayName,
      );
      emit(AuthAuthenticated(user: user));
    } catch (e, st) {
      debugPrint('Sign up failed for ${event.email}: $e');
      debugPrintStack(stackTrace: st);
      emit(AuthError(message: e.toString()));
    }
  }
  
  /// Sign in with Google
  Future<void> _onSignInWithGoogle(
    AuthSignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.signInWithGoogle();
      emit(AuthAuthenticated(user: user));
    } catch (e, st) {
      debugPrint('Sign in with Google failed: $e');
      debugPrintStack(stackTrace: st);
      emit(AuthError(message: e.toString()));
    }
  }
  
  /// Reset password
  Future<void> _onResetPassword(
    AuthResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _authRepository.resetPassword(event.email);
      emit(const AuthPasswordResetEmailSent());
    } catch (e, st) {
      debugPrint('Password reset failed for ${event.email}: $e');
      debugPrintStack(stackTrace: st);
      emit(AuthError(message: e.toString()));
    }
  }
  
  /// Sign out
  Future<void> _onSignOut(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authRepository.signOut();
      emit(const AuthUnauthenticated());
    } catch (e, st) {
      debugPrint('Sign out failed: $e');
      debugPrintStack(stackTrace: st);
      emit(AuthError(message: e.toString()));
    }
  }
}
