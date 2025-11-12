import 'package:equatable/equatable.dart';

abstract class TryOnState extends Equatable {
  final String? personImageUrl;
  final String? clothImageUrl;
  const TryOnState({this.personImageUrl, this.clothImageUrl});
  @override
  List<Object?> get props => [personImageUrl, clothImageUrl];
}

class TryOnInitial extends TryOnState {
  const TryOnInitial({String? personImageUrl, String? clothImageUrl})
      : super(personImageUrl: personImageUrl, clothImageUrl: clothImageUrl);
}

class TryOnLoading extends TryOnState {
  const TryOnLoading({String? personImageUrl, String? clothImageUrl})
      : super(personImageUrl: personImageUrl, clothImageUrl: clothImageUrl);
}

class TryOnSuccess extends TryOnState {
  final String base64Image;
  const TryOnSuccess(this.base64Image, {String? personImageUrl, String? clothImageUrl})
      : super(personImageUrl: personImageUrl, clothImageUrl: clothImageUrl);
  @override
  List<Object?> get props => [base64Image, personImageUrl, clothImageUrl];
}

class TryOnFailure extends TryOnState {
  final String message;
  const TryOnFailure(this.message, {String? personImageUrl, String? clothImageUrl})
      : super(personImageUrl: personImageUrl, clothImageUrl: clothImageUrl);
  @override
  List<Object?> get props => [message, personImageUrl, clothImageUrl];
}
