import 'package:equatable/equatable.dart';

/// ClothingItem Model - Represents a clothing item in the catalog
class ClothingItemModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String category;
  final String color;
  final String gender;
  final double price;
  final String brand;
  final List<String> sizes;
  final bool isFavorite;
  
  const ClothingItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.color,
    required this.gender,
    required this.price,
    required this.brand,
    required this.sizes,
    this.isFavorite = false,
  });
  
  /// Create ClothingItemModel from JSON
  factory ClothingItemModel.fromJson(Map<String, dynamic> json) {
    return ClothingItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      color: json['color'] as String,
      gender: json['gender'] as String,
      price: (json['price'] as num).toDouble(),
      brand: json['brand'] as String,
      sizes: List<String>.from(json['sizes'] as List),
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }
  
  /// Convert ClothingItemModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'color': color,
      'gender': gender,
      'price': price,
      'brand': brand,
      'sizes': sizes,
      'isFavorite': isFavorite,
    };
  }
  
  /// Copy with method
  ClothingItemModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? category,
    String? color,
    String? gender,
    double? price,
    String? brand,
    List<String>? sizes,
    bool? isFavorite,
  }) {
    return ClothingItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      color: color ?? this.color,
      gender: gender ?? this.gender,
      price: price ?? this.price,
      brand: brand ?? this.brand,
      sizes: sizes ?? this.sizes,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
  
  @override
  List<Object?> get props => [
    id,
    name,
    description,
    imageUrl,
    category,
    color,
    gender,
    price,
    brand,
    sizes,
    isFavorite,
  ];
}
