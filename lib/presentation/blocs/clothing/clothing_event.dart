import 'package:equatable/equatable.dart';

/// Clothing Events
abstract class ClothingEvent extends Equatable {
  const ClothingEvent();
  
  @override
  List<Object?> get props => [];
}

/// Load all clothing items
class ClothingLoadRequested extends ClothingEvent {
  const ClothingLoadRequested();
}

/// Filter clothing items
class ClothingFilterRequested extends ClothingEvent {
  final String? category;
  final String? color;
  final String? gender;
  
  const ClothingFilterRequested({
    this.category,
    this.color,
    this.gender,
  });
  
  @override
  List<Object?> get props => [category, color, gender];
}

/// Search clothing items
class ClothingSearchRequested extends ClothingEvent {
  final String query;
  
  const ClothingSearchRequested({required this.query});
  
  @override
  List<Object?> get props => [query];
}

/// Get clothing item by ID
class ClothingDetailRequested extends ClothingEvent {
  final String id;
  
  const ClothingDetailRequested({required this.id});
  
  @override
  List<Object?> get props => [id];
}
