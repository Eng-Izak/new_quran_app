import 'package:quran_library/quran.dart';

extension SurahAudioStorage on AudioCtrl {
  /// -------- [Storage] ----------

  /// تحميل آخر سورة ومكان مستمع إليهما من التخزين المحلي
  void loadLastSurahAndPosition() {
    final int lastSurah = state.box.read(AudioStorageConstants.lastSurah) ?? 1;
    final int selectedSurah =
        state.box.read(AudioStorageConstants.selectedSurahIndex) ?? 0;
    final int lastPosition = state.box.read(AudioStorageConstants.lastPosition) ?? 0;

    state.currentAudioListSurahNum.value = lastSurah;
    state.selectedSurahIndex.value = selectedSurah;
    state.lastPosition.value = lastPosition;

    log('Loaded last Surah index: ${state.selectedSurahIndex.value + 1}, last Surah ${state.currentAudioListSurahNum.value} position: ${state.lastPosition.value}');
  }

  void saveLastSurahListen(int? surahNumber) {
    state.box.write(AudioStorageConstants.lastSurah,
        surahNumber ?? state.selectedSurahIndex.value + 1);
    state.box.write(
      AudioStorageConstants.selectedSurahIndex,
      state.selectedSurahIndex.value,
    );
    log('Saved last Surah index: ${state.selectedSurahIndex.value + 1}, last Surah ${surahNumber ?? state.selectedSurahIndex.value + 1}');
  }

  void loadReaderIndex() {
    state.surahReaderIndex.value =
        state.box.read(AudioStorageConstants.surahReaderIndex) ?? 0;
    state.ayahReaderIndex.value =
        state.box.read(AudioStorageConstants.ayahReaderIndex) ?? 0;
  }
}
