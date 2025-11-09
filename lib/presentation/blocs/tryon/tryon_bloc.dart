import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/ai_tryon_repository.dart';
import 'tryon_event.dart';
import 'tryon_state.dart';

/// TryOnBloc - Handles virtual try-on business logic
class TryOnBloc extends Bloc<TryOnEvent, TryOnState> {
  final AiTryOnRepository _aiTryOnRepository;
  String? _uploadedPhotoUrl;
  String? _currentUserId;
  
  TryOnBloc({required AiTryOnRepository aiTryOnRepository})
      : _aiTryOnRepository = aiTryOnRepository,
        super(const TryOnInitial()) {
    on<TryOnUploadPhotoRequested>(_onUploadPhoto);
    on<TryOnProcessRequested>(_onProcessTryOn);
    on<TryOnHistoryRequested>(_onGetHistory);
    on<TryOnSaveRequested>(_onSaveResult);
    on<TryOnRemoveSavedRequested>(_onRemoveSaved);
    on<TryOnDeleteRequested>(_onDeleteResult);
    on<TryOnResetRequested>(_onReset);
  }
  
  /// Set current user ID
  void setUserId(String userId) {
    _currentUserId = userId;
  }
  
  /// Upload user photo
  Future<void> _onUploadPhoto(
    TryOnUploadPhotoRequested event,
    Emitter<TryOnState> emit,
  ) async {
    if (_currentUserId == null) {
      emit(const TryOnError(message: 'User not authenticated'));
      return;
    }
    
    emit(const TryOnLoading(message: 'Uploading photo...'));
    try {
      final photoUrl = await _aiTryOnRepository.uploadUserPhoto(
        event.imageFile,
        _currentUserId!,
      );
      _uploadedPhotoUrl = photoUrl;
      emit(TryOnPhotoUploaded(photoUrl: photoUrl));
    } catch (e) {
      emit(TryOnError(message: e.toString()));
    }
  }
  
  /// Process try-on
  Future<void> _onProcessTryOn(
    TryOnProcessRequested event,
    Emitter<TryOnState> emit,
  ) async {
    if (_currentUserId == null) {
      emit(const TryOnError(message: 'User not authenticated'));
      return;
    }
    
    if (_uploadedPhotoUrl == null) {
      emit(const TryOnError(message: 'Please upload a photo first'));
      return;
    }
    
    emit(const TryOnProcessing());
    try {
      final result = await _aiTryOnRepository.tryOnClothing(
        userId: _currentUserId!,
        userPhotoUrl: _uploadedPhotoUrl!,
        clothingItemId: event.clothingItemId,
      );
      emit(TryOnSuccess(result: result));
    } catch (e) {
      emit(TryOnError(message: e.toString()));
    }
  }
  
  /// Get try-on history
  Future<void> _onGetHistory(
    TryOnHistoryRequested event,
    Emitter<TryOnState> emit,
  ) async {
    if (_currentUserId == null) {
      emit(const TryOnError(message: 'User not authenticated'));
      return;
    }
    
    emit(const TryOnLoading(message: 'Loading history...'));
    try {
      final results = await _aiTryOnRepository.getTryOnHistory(_currentUserId!);
      emit(TryOnHistoryLoaded(results: results));
    } catch (e) {
      emit(TryOnError(message: e.toString()));
    }
  }
  
  /// Save result
  Future<void> _onSaveResult(
    TryOnSaveRequested event,
    Emitter<TryOnState> emit,
  ) async {
    try {
      await _aiTryOnRepository.saveTryOnResult(event.resultId);
      emit(TryOnResultSaved(resultId: event.resultId));
    } catch (e) {
      emit(TryOnError(message: e.toString()));
    }
  }
  
  /// Remove saved result
  Future<void> _onRemoveSaved(
    TryOnRemoveSavedRequested event,
    Emitter<TryOnState> emit,
  ) async {
    try {
      await _aiTryOnRepository.removeTryOnResult(event.resultId);
      emit(const TryOnInitial());
    } catch (e) {
      emit(TryOnError(message: e.toString()));
    }
  }
  
  /// Delete result
  Future<void> _onDeleteResult(
    TryOnDeleteRequested event,
    Emitter<TryOnState> emit,
  ) async {
    try {
      await _aiTryOnRepository.deleteTryOnResult(event.resultId);
      emit(const TryOnInitial());
    } catch (e) {
      emit(TryOnError(message: e.toString()));
    }
  }
  
  /// Reset state
  Future<void> _onReset(
    TryOnResetRequested event,
    Emitter<TryOnState> emit,
  ) async {
    _uploadedPhotoUrl = null;
    emit(const TryOnInitial());
  }
}
