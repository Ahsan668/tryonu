import 'package:equatable/equatable.dart';
import '../../../data/models/try_on_result_model.dart';

/// TryOn States
abstract class TryOnState extends Equatable {
  const TryOnState();
  
  @override
  List<Object?> get props => [];
}

/// Initial state
class TryOnInitial extends TryOnState {
  const TryOnInitial();
}

/// Loading state
class TryOnLoading extends TryOnState {
  final String? message;
  
  const TryOnLoading({this.message});
  
  @override
  List<Object?> get props => [message];
}

/// Photo uploaded successfully
class TryOnPhotoUploaded extends TryOnState {
  final String photoUrl;
  
  const TryOnPhotoUploaded({required this.photoUrl});
  
  @override
  List<Object?> get props => [photoUrl];
}

/// Processing try-on
class TryOnProcessing extends TryOnState {
  const TryOnProcessing();
}

/// Try-on completed successfully
class TryOnSuccess extends TryOnState {
  final TryOnResultModel result;
  
  const TryOnSuccess({required this.result});
  
  @override
  List<Object?> get props => [result];
}

/// History loaded
class TryOnHistoryLoaded extends TryOnState {
  final List<TryOnResultModel> results;
  
  const TryOnHistoryLoaded({required this.results});
  
  @override
  List<Object?> get props => [results];
}

/// Result saved
class TryOnResultSaved extends TryOnState {
  final String resultId;
  
  const TryOnResultSaved({required this.resultId});
  
  @override
  List<Object?> get props => [resultId];
}

/// Error state
class TryOnError extends TryOnState {
  final String message;
  
  const TryOnError({required this.message});
  
  @override
  List<Object?> get props => [message];
}
