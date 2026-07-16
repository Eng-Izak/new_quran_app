import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/tajweed_aya_models.dart';
import '../data/repositories/tajweed_aya_repository.dart';
import 'tajweed_aya_state.dart';

class TajweedAyaCubit extends Cubit<TajweedAyaState> {
  final TajweedAyaRepository _repository;

  TajweedAyaCubit(this._repository)
      : super(TajweedAyaState(
          isPreparingDownload: false,
          isDownloading: false,
          downloadProgress: 0.0,
          isAvailable: _repository.isDownloaded(),
        ));

  Future<void> download() async {
    if (state.isDownloading) return;

    try {
      emit(state.copyWith(
        isPreparingDownload: true,
        isDownloading: true,
        downloadProgress: 0.0,
      ));

      await _repository.download(
        onProgress: (p) {
          emit(state.copyWith(
            isPreparingDownload: false,
            downloadProgress: p,
          ));
        },
      );

      emit(state.copyWith(
        isPreparingDownload: false,
        isDownloading: false,
        downloadProgress: 100.0,
        isAvailable: true,
      ));
    } catch (_) {
      emit(state.copyWith(
        isPreparingDownload: false,
        isDownloading: false,
        downloadProgress: 0.0,
      ));
      rethrow;
    }
  }

  Future<TajweedAyahInfo?> getAyahInfo({
    required int surahNumber,
    required int ayahNumber,
  }) =>
      _repository.getAyahInfo(surahNumber: surahNumber, ayahNumber: ayahNumber);

  Future<void> prewarmSurah(int surahNumber) async {
    await _repository.prewarmSurah(surahNumber);
  }
}
