import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/try_on_result_model.dart';

/// AiTryOnRepository - Handles AI try-on operations
class AiTryOnRepository {
  final FirebaseStorage _storage;
  final FirebaseFirestore _firestore;
  
  AiTryOnRepository({
    FirebaseStorage? storage,
    FirebaseFirestore? firestore,
  })  : _storage = storage ?? FirebaseStorage.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;
  
  /// Upload user photo to Firebase Storage
  Future<String> uploadUserPhoto(File imageFile, String userId) async {
    try {
      final fileName = 'user_photos/${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child(fileName);
      
      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload photo: $e');
    }
  }
  
  /// Process virtual try-on (Mock implementation - Replace with actual AI API)
  Future<TryOnResultModel> tryOnClothing({
    required String userId,
    required String userPhotoUrl,
    required String clothingItemId,
  }) async {
    try {
      // Simulate AI processing delay
      await Future.delayed(const Duration(seconds: 3));
      
      // MOCK: In production, this would call an AI API like HuggingFace, DeepFashion2, etc.
      // For now, we'll just return the user photo as the result
      // You would replace this with actual API call:
      // final response = await dio.post('https://api.ai-service.com/try-on', data: {...});
      
      final result = TryOnResultModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        userPhotoUrl: userPhotoUrl,
        clothingItemId: clothingItemId,
        resultImageUrl: userPhotoUrl, // Mock: using same photo as result
        createdAt: DateTime.now(),
        isSaved: false,
      );
      
      // Save result to Firestore
      await _firestore
          .collection('try_on_results')
          .doc(result.id)
          .set(result.toJson());
      
      return result;
    } catch (e) {
      throw Exception('Failed to process try-on: $e');
    }
  }
  
  /// Get user's try-on history
  Future<List<TryOnResultModel>> getTryOnHistory(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('try_on_results')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => TryOnResultModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get try-on history: $e');
    }
  }
  
  /// Save try-on result to favorites
  Future<void> saveTryOnResult(String resultId) async {
    try {
      await _firestore
          .collection('try_on_results')
          .doc(resultId)
          .update({'isSaved': true});
    } catch (e) {
      throw Exception('Failed to save result: $e');
    }
  }
  
  /// Remove try-on result from favorites
  Future<void> removeTryOnResult(String resultId) async {
    try {
      await _firestore
          .collection('try_on_results')
          .doc(resultId)
          .update({'isSaved': false});
    } catch (e) {
      throw Exception('Failed to remove result: $e');
    }
  }
  
  /// Get saved try-on results
  Future<List<TryOnResultModel>> getSavedResults(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('try_on_results')
          .where('userId', isEqualTo: userId)
          .where('isSaved', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => TryOnResultModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get saved results: $e');
    }
  }
  
  /// Delete try-on result
  Future<void> deleteTryOnResult(String resultId) async {
    try {
      await _firestore.collection('try_on_results').doc(resultId).delete();
    } catch (e) {
      throw Exception('Failed to delete result: $e');
    }
  }
}
