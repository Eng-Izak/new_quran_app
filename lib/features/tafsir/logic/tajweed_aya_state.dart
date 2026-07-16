class TajweedAyaState {
  final bool isPreparingDownload;
  final bool isDownloading;
  final double downloadProgress;
  final bool isAvailable;

  TajweedAyaState({
    required this.isPreparingDownload,
    required this.isDownloading,
    required this.downloadProgress,
    required this.isAvailable,
  });

  TajweedAyaState copyWith({
    bool? isPreparingDownload,
    bool? isDownloading,
    double? downloadProgress,
    bool? isAvailable,
  }) {
    return TajweedAyaState(
      isPreparingDownload: isPreparingDownload ?? this.isPreparingDownload,
      isDownloading: isDownloading ?? this.isDownloading,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
