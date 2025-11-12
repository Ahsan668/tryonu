import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:share_plus/share_plus.dart';

abstract class TryOnResultState extends Equatable {
  const TryOnResultState();
  @override
  List<Object?> get props => [];
}

class TryOnResultIdle extends TryOnResultState {
  const TryOnResultIdle();
}

class TryOnResultSaving extends TryOnResultState {
  const TryOnResultSaving();
}

class TryOnResultSaved extends TryOnResultState {
  final String downloadUrl;
  const TryOnResultSaved(this.downloadUrl);
  @override
  List<Object?> get props => [downloadUrl];
}

class TryOnResultSharing extends TryOnResultState {
  const TryOnResultSharing();
}

class TryOnResultShared extends TryOnResultState {
  const TryOnResultShared();
}

class TryOnResultError extends TryOnResultState {
  final String message;
  const TryOnResultError(this.message);
  @override
  List<Object?> get props => [message];
}

class TryOnResultCubit extends Cubit<TryOnResultState> {
  TryOnResultCubit() : super(const TryOnResultIdle());

  Future<void> save(Uint8List bytes) async {
    emit(const TryOnResultSaving());
    try {
      final fileName = 'tryon_${DateTime.now().millisecondsSinceEpoch}.png';
      final ref = FirebaseStorage.instance
          .ref()
          .child('generated_results/$fileName');
      await ref.putData(bytes, SettableMetadata(contentType: 'image/png'));
      final url = await ref.getDownloadURL();
      emit(TryOnResultSaved(url));
    } catch (e) {
      emit(TryOnResultError('Save failed: $e'));
    }
  }

  Future<void> share(Uint8List bytes) async {
    emit(const TryOnResultSharing());
    try {
      final xfile = XFile.fromData(bytes, name: 'tryon_result.png', mimeType: 'image/png');
      await Share.shareXFiles([xfile], text: 'My AI Try-On result');
      emit(const TryOnResultShared());
    } catch (e) {
      emit(TryOnResultError('Share failed: $e'));
    }
  }
}
