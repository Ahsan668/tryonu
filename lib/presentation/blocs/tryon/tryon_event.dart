import 'dart:io';
import 'package:equatable/equatable.dart';

/// TryOn Events
abstract class TryOnEvent extends Equatable {
  const TryOnEvent();
  
  @override
  List<Object?> get props => [];
}

/// Upload user photo
class TryOnUploadPhotoRequested extends TryOnEvent {
  final File imageFile;
  
  const TryOnUploadPhotoRequested({required this.imageFile});
  
  @override
  List<Object?> get props => [imageFile];
}

/// Process try-on with clothing item
class TryOnProcessRequested extends TryOnEvent {
  final String clothingItemId;
  
  const TryOnProcessRequested({required this.clothingItemId});
  
  @override
  List<Object?> get props => [clothingItemId];
}

/// Get try-on history
class TryOnHistoryRequested extends TryOnEvent {
  const TryOnHistoryRequested();
}

/// Save try-on result
class TryOnSaveRequested extends TryOnEvent {
  final String resultId;
  
  const TryOnSaveRequested({required this.resultId});
  
  @override
  List<Object?> get props => [resultId];
}

/// Remove saved result
class TryOnRemoveSavedRequested extends TryOnEvent {
  final String resultId;
  
  const TryOnRemoveSavedRequested({required this.resultId});
  
  @override
  List<Object?> get props => [resultId];
}

/// Delete try-on result
class TryOnDeleteRequested extends TryOnEvent {
  final String resultId;
  
  const TryOnDeleteRequested({required this.resultId});
  
  @override
  List<Object?> get props => [resultId];
}

/// Reset try-on state
class TryOnResetRequested extends TryOnEvent {
  const TryOnResetRequested();
}
