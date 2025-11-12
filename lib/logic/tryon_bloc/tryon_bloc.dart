import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tryonu/data/services/huggingface_service.dart';

import 'tryon_event.dart';
import 'tryon_state.dart';

class TryOnBloc extends Bloc<TryOnEvent, TryOnState> {
  final VirtualTryOnService service;

  TryOnBloc({required this.service}) : super(const TryOnInitial()) {
    on<UploadImagesEvent>(_onUploadImages);
    on<GenerateTryOnEvent>(_onGenerateTryOn);
  }

  void _onUploadImages(UploadImagesEvent event, Emitter<TryOnState> emit) {
    emit(TryOnInitial(
      personImageUrl: event.personImageUrl,
      clothImageUrl: event.clothImageUrl,
    ));
  }

  Future<void> _onGenerateTryOn(
      GenerateTryOnEvent event, Emitter<TryOnState> emit) async {
    final personUrl = state.personImageUrl;
    final clothUrl = state.clothImageUrl;

    if (personUrl == null || personUrl.isEmpty || clothUrl == null || clothUrl.isEmpty) {
      emit(TryOnFailure('Images not provided',
          personImageUrl: personUrl, clothImageUrl: clothUrl));
      return;
    }

    emit(TryOnLoading(personImageUrl: personUrl, clothImageUrl: clothUrl));

    try {
      final result = await service.generateTryOn(personUrl, clothUrl);
      if (result != null && result.isNotEmpty) {
        emit(TryOnSuccess(result,
            personImageUrl: personUrl, clothImageUrl: clothUrl));
      } else {
        emit(TryOnFailure('Failed to generate image',
            personImageUrl: personUrl, clothImageUrl: clothUrl));
      }
    } catch (e) {
      emit(TryOnFailure(e.toString(),
          personImageUrl: personUrl, clothImageUrl: clothUrl));
    }
  }
}
