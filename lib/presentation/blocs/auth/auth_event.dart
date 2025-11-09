import 'package:equatable/equatable.dart';

/// Auth Events (Intent in MVI pattern)
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  
  @override
  List<Object?> get props => [];
}

/// Check authentication status
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Sign in with email
class AuthSignInWithEmailRequested extends AuthEvent {
  final String email;
  final String password;
  
  const AuthSignInWithEmailRequested({
    required this.email,
    required this.password,
  });
  
  @override
  List<Object?> get props => [email, password];
}

/// Sign up with email
class AuthSignUpWithEmailRequested extends AuthEvent {
  final String email;
  final String password;
  final String? displayName;
  
  const AuthSignUpWithEmailRequested({
    required this.email,
    required this.password,
    this.displayName,
  });
  
  @override
  List<Object?> get props => [email, password, displayName];
}

/// Sign in with Google
class AuthSignInWithGoogleRequested extends AuthEvent {
  const AuthSignInWithGoogleRequested();
}

/// Reset password
class AuthResetPasswordRequested extends AuthEvent {
  final String email;
  
  const AuthResetPasswordRequested({required this.email});
  
  @override
  List<Object?> get props => [email];
}

/// Sign out
class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}
