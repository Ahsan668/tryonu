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
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      return await _getUserData(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }
  
  /// Sign up with email and password
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
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
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
