import 'package:equatable/equatable.dart';

/// TryOnResult Model - Represents the result of a virtual try-on
class TryOnResultModel extends Equatable {
  final String id;
  final String userId;
  final String userPhotoUrl;
  final String clothingItemId;
  final String resultImageUrl;
  final DateTime createdAt;
  final bool isSaved;
  
  const TryOnResultModel({
    required this.id,
    required this.userId,
    required this.userPhotoUrl,
    required this.clothingItemId,
    required this.resultImageUrl,
    required this.createdAt,
    this.isSaved = false,
  });
  
  /// Create TryOnResultModel from JSON
  factory TryOnResultModel.fromJson(Map<String, dynamic> json) {
    return TryOnResultModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userPhotoUrl: json['userPhotoUrl'] as String,
      clothingItemId: json['clothingItemId'] as String,
      resultImageUrl: json['resultImageUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isSaved: json['isSaved'] as bool? ?? false,
    );
  }
  
  /// Convert TryOnResultModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userPhotoUrl': userPhotoUrl,
      'clothingItemId': clothingItemId,
      'resultImageUrl': resultImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'isSaved': isSaved,
    };
  }
  
  /// Copy with method
  TryOnResultModel copyWith({
    String? id,
    String? userId,
    String? userPhotoUrl,
    String? clothingItemId,
    String? resultImageUrl,
    DateTime? createdAt,
    bool? isSaved,
  }) {
    return TryOnResultModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
      clothingItemId: clothingItemId ?? this.clothingItemId,
      resultImageUrl: resultImageUrl ?? this.resultImageUrl,
      createdAt: createdAt ?? this.createdAt,
      isSaved: isSaved ?? this.isSaved,
    );
  }
  
  @override
  List<Object?> get props => [
    id,
    userId,
    userPhotoUrl,
    clothingItemId,
    resultImageUrl,
    createdAt,
    isSaved,
  ];
}
