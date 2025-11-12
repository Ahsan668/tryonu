import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/try_on_result_model.dart';
import '../models/clothing_item_model.dart';
import '../repositories/clothing_repository.dart';
import '../services/huggingface_service.dart';

/// AiTryOnRepository - Handles AI try-on operations
class AiTryOnRepository {
  final FirebaseStorage _storage;
  final FirebaseFirestore _firestore;
  final ClothingRepository _clothingRepository;
  final VirtualTryOnService _virtualTryOnService;
  
  AiTryOnRepository({
    FirebaseStorage? storage,
    FirebaseFirestore? firestore,
    required ClothingRepository clothingRepository,
    required VirtualTryOnService virtualTryOnService,
  })  : _storage = storage ?? FirebaseStorage.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _clothingRepository = clothingRepository,
        _virtualTryOnService = virtualTryOnService;
  
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
  
  /// Process virtual try-on (calls AI service and persists result)
  Future<TryOnResultModel> tryOnClothing({
    required String userId,
    required String userPhotoUrl,
    required String clothingItemId,
  }) async {
    try {
      final ClothingItemModel? clothing =
          await _clothingRepository.getClothingById(clothingItemId);
      if (clothing == null) {
        throw Exception('Clothing item not found');
      }

      final base64Image = await _virtualTryOnService
          .generateTryOn(userPhotoUrl, clothing.imageUrl);

      if (base64Image == null || base64Image.isEmpty) {
        final msg = _virtualTryOnService.lastError ?? 'Unknown error';
        throw Exception('Failed to generate try-on: $msg');
      }

      final bytes = _decodeBase64ToBytes(base64Image);
      final downloadUrl = await _uploadGeneratedImage(bytes, userId);

      final result = TryOnResultModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        userPhotoUrl: userPhotoUrl,
        clothingItemId: clothingItemId,
        resultImageUrl: downloadUrl,
        createdAt: DateTime.now(),
        isSaved: false,
      );

      await _firestore
          .collection('try_on_results')
          .doc(result.id)
          .set(result.toJson());

      return result;
    } catch (e) {
      throw Exception('Failed to process try-on: $e');
    }
  }

  Uint8List _decodeBase64ToBytes(String data) {
    final clean = data.contains(',') ? data.split(',').last : data;
    return base64Decode(clean);
  }

  Future<String> _uploadGeneratedImage(Uint8List bytes, String userId) async {
    final fileName =
        'generated_results/${userId}_${DateTime.now().millisecondsSinceEpoch}.png';
    final ref = _storage.ref().child(fileName);
    await ref.putData(bytes, SettableMetadata(contentType: 'image/png'));
    return await ref.getDownloadURL();
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
