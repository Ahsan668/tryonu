import 'package:equatable/equatable.dart';
import '../../../data/models/clothing_item_model.dart';

/// Clothing States
abstract class ClothingState extends Equatable {
  const ClothingState();
  
  @override
  List<Object?> get props => [];
}

/// Initial state
class ClothingInitial extends ClothingState {
  const ClothingInitial();
}

/// Loading state
class ClothingLoading extends ClothingState {
  const ClothingLoading();
}

/// Loaded state
class ClothingLoaded extends ClothingState {
  final List<ClothingItemModel> items;
  final String? activeCategory;
  final String? activeColor;
  final String? activeGender;
  
  const ClothingLoaded({
    required this.items,
    this.activeCategory,
    this.activeColor,
    this.activeGender,
  });
  
  @override
  List<Object?> get props => [items, activeCategory, activeColor, activeGender];
}

/// Detail loaded
class ClothingDetailLoaded extends ClothingState {
  final ClothingItemModel item;
  
  const ClothingDetailLoaded({required this.item});
  
  @override
  List<Object?> get props => [item];
}

/// Error state
class ClothingError extends ClothingState {
  final String message;
  
  const ClothingError({required this.message});
  
  @override
  List<Object?> get props => [message];
}

/// Empty state (no items found)
class ClothingEmpty extends ClothingState {
  const ClothingEmpty();
}
