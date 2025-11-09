import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/clothing_repository.dart';
import 'clothing_event.dart';
import 'clothing_state.dart';

/// ClothingBloc - Handles clothing catalog business logic
class ClothingBloc extends Bloc<ClothingEvent, ClothingState> {
  final ClothingRepository _clothingRepository;
  
  ClothingBloc({required ClothingRepository clothingRepository})
      : _clothingRepository = clothingRepository,
        super(const ClothingInitial()) {
    on<ClothingLoadRequested>(_onLoadClothing);
    on<ClothingFilterRequested>(_onFilterClothing);
    on<ClothingSearchRequested>(_onSearchClothing);
    on<ClothingDetailRequested>(_onGetDetail);
  }
  
  /// Load all clothing items
  Future<void> _onLoadClothing(
    ClothingLoadRequested event,
    Emitter<ClothingState> emit,
  ) async {
    emit(const ClothingLoading());
    try {
      final items = await _clothingRepository.getAllClothingItems();
      if (items.isEmpty) {
        emit(const ClothingEmpty());
      } else {
        emit(ClothingLoaded(items: items));
      }
    } catch (e) {
      emit(ClothingError(message: e.toString()));
    }
  }
  
  /// Filter clothing items
  Future<void> _onFilterClothing(
    ClothingFilterRequested event,
    Emitter<ClothingState> emit,
  ) async {
    emit(const ClothingLoading());
    try {
      final items = await _clothingRepository.getFilteredClothing(
        category: event.category,
        color: event.color,
        gender: event.gender,
      );
      
      if (items.isEmpty) {
        emit(const ClothingEmpty());
      } else {
        emit(ClothingLoaded(
          items: items,
          activeCategory: event.category,
          activeColor: event.color,
          activeGender: event.gender,
        ));
      }
    } catch (e) {
      emit(ClothingError(message: e.toString()));
    }
  }
  
  /// Search clothing items
  Future<void> _onSearchClothing(
    ClothingSearchRequested event,
    Emitter<ClothingState> emit,
  ) async {
    emit(const ClothingLoading());
    try {
      final allItems = await _clothingRepository.getAllClothingItems();
      final query = event.query.toLowerCase();
      
      final filteredItems = allItems.where((item) {
        return item.name.toLowerCase().contains(query) ||
            item.description.toLowerCase().contains(query) ||
            item.category.toLowerCase().contains(query) ||
            item.brand.toLowerCase().contains(query);
      }).toList();
      
      if (filteredItems.isEmpty) {
        emit(const ClothingEmpty());
      } else {
        emit(ClothingLoaded(items: filteredItems));
      }
    } catch (e) {
      emit(ClothingError(message: e.toString()));
    }
  }
  
  /// Get clothing detail
  Future<void> _onGetDetail(
    ClothingDetailRequested event,
    Emitter<ClothingState> emit,
  ) async {
    emit(const ClothingLoading());
    try {
      final item = await _clothingRepository.getClothingById(event.id);
      if (item != null) {
        emit(ClothingDetailLoaded(item: item));
      } else {
        emit(const ClothingError(message: 'Item not found'));
      }
    } catch (e) {
      emit(ClothingError(message: e.toString()));
    }
  }
}
