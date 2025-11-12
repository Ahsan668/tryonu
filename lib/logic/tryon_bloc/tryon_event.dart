import 'package:equatable/equatable.dart';

abstract class TryOnEvent extends Equatable {
  const TryOnEvent();
  @override
  List<Object?> get props => [];
}

class UploadImagesEvent extends TryOnEvent {
  final String personImageUrl;
  final String clothImageUrl;
  const UploadImagesEvent({required this.personImageUrl, required this.clothImageUrl});
  @override
  List<Object?> get props => [personImageUrl, clothImageUrl];
}

class GenerateTryOnEvent extends TryOnEvent {
  const GenerateTryOnEvent();
}
