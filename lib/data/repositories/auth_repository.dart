import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

/// AuthRepository - Handles authentication operations
class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  
  AuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;
  
  /// Get current user stream
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  
  /// Get current user
  User? get currentUser => _firebaseAuth.currentUser;
  
  /// Sign in with email and password
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final sanitizedEmail = email.trim();
      final sanitizedPassword = password.trim();
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: sanitizedEmail,
        password: sanitizedPassword,
      );
      
      final user = userCredential.user!;
      // Ensure Firestore user document exists; create minimal one if missing
      final userDocRef = _firestore.collection('users').doc(user.uid);
      final userDoc = await userDocRef.get();
      if (!userDoc.exists) {
        final userModel = UserModel(
          uid: user.uid,
          email: user.email!,
          displayName: user.displayName,
          photoUrl: user.photoURL,
          createdAt: DateTime.now(),
        );
        await userDocRef.set(userModel.toJson());
        return userModel;
      }
      
      return UserModel.fromJson(userDoc.data()!);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      // Surface non-auth exceptions (e.g., Firestore/user document issues)
      throw Exception('Failed to sign in: $e');
    }
  }
  
  /// Sign up with email and password
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final sanitizedEmail = email.trim();
      final sanitizedPassword = password.trim();
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: sanitizedEmail,
        password: sanitizedPassword,
      );
      
      final user = userCredential.user!;
      
      // Update display name if provided
      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }
      
      // Create user document in Firestore
      final userModel = UserModel(
        uid: user.uid,
        email: user.email!,
        displayName: displayName,
        createdAt: DateTime.now(),
      );
      
      await _firestore.collection('users').doc(user.uid).set(userModel.toJson());
      
      return userModel;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }
  
  /// Sign in with Google
  Future<UserModel> signInWithGoogle() async {
    try {
      final provider = GoogleAuthProvider();
      provider.setCustomParameters({'prompt': 'select_account'});
      final userCredential = await _firebaseAuth.signInWithProvider(provider);
      final user = userCredential.user!;
      
      // Check if user document exists
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      
      if (!userDoc.exists) {
        // Create new user document
        final userModel = UserModel(
          uid: user.uid,
          email: user.email!,
          displayName: user.displayName,
          photoUrl: user.photoURL,
          createdAt: DateTime.now(),
        );
        
        await _firestore.collection('users').doc(user.uid).set(userModel.toJson());
        return userModel;
      }
      
      return await _getUserData(user.uid);
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }
  
  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }
  
  /// Sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }
  
  /// Get user data from Firestore (public method)
  Future<UserModel> getUserData(String uid) async {
    return _getUserData(uid);
  }
  
  /// Get user data from Firestore (private implementation)
  Future<UserModel> _getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        throw Exception('User data not found');
      }
      return UserModel.fromJson(doc.data()!);
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }
  
  /// Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'network-request-failed':
        return 'Network error. Check your internet connection and try again.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is disabled for this project. Enable it in Firebase Console.';
      case 'invalid-api-key':
        return 'Invalid Firebase API key. Verify your configuration.';
      case 'app-not-authorized':
        return 'App is not authorized to use Firebase Authentication for this project.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method for this email.';
      case 'internal-error':
        return 'An internal error occurred. Please try again.';
      default:
        return 'Authentication failed (${e.code}). ${e.message ?? 'Please try again.'}';
    }
  }
}
