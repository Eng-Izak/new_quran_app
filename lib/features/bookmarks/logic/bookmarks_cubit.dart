import 'package:flutter_bloc/flutter_bloc.dart';
import '../../quran/data/repositories/quran_repository.dart';
import '../data/models/bookmark_model.dart';
import 'bookmarks_state.dart';

class BookmarksCubit extends Cubit<BookmarksState> {
  final QuranRepository _quranRepository;

  BookmarksCubit(this._quranRepository)
      : super(BookmarksState(bookmarks: {}, bookmarksAyahsSet: {}));

  void initBookmarks(
      {Map<int, List<BookmarkModel>>? userBookmarks, bool overwrite = false}) {
    final Map<int, List<BookmarkModel>> newBookmarks = {};
    if (overwrite) {
      if (userBookmarks != null) {
        newBookmarks.addAll(userBookmarks);
      }
    } else {
      final savedBookmarks = _quranRepository.getBookmarks();
      if (savedBookmarks.isEmpty) {
        newBookmarks[0xAAFFD354] = []; // Yellow
        newBookmarks[0xAAF36077] = []; // Red
        newBookmarks[0xAA00CD00] = []; // Green
      } else {
        for (var bookmark in savedBookmarks) {
          newBookmarks.update(
            bookmark.colorCode,
            (existingList) => [...existingList, bookmark],
            ifAbsent: () => [bookmark],
          );
        }
      }
    }
    _quranRepository.saveBookmarks(_flatten(newBookmarks));
    emit(BookmarksState(
      bookmarks: newBookmarks,
      bookmarksAyahsSet: _buildCache(newBookmarks),
    ));
  }

  void saveBookmark({
    required String surahName,
    required int ayahId,
    required int ayahNumber,
    required int page,
    required int colorCode,
  }) {
    final bookmark = BookmarkModel(
      id: DateTime.now().millisecondsSinceEpoch,
      colorCode: colorCode,
      name: surahName,
      ayahNumber: ayahNumber,
      ayahId: ayahId,
      page: page,
    );

    final updatedBookmarks =
        Map<int, List<BookmarkModel>>.from(state.bookmarks);
    updatedBookmarks.update(
      colorCode,
      (existingList) => [...existingList, bookmark],
      ifAbsent: () => [bookmark],
    );

    _quranRepository.saveBookmarks(_flatten(updatedBookmarks));
    emit(BookmarksState(
      bookmarks: updatedBookmarks,
      bookmarksAyahsSet: _buildCache(updatedBookmarks),
    ));
  }

  void removeBookmark(int bookmarkId) {
    final updatedBookmarks =
        Map<int, List<BookmarkModel>>.from(state.bookmarks);
    updatedBookmarks.forEach((colorCode, list) {
      updatedBookmarks.update(
        colorCode,
        (existingList) =>
            existingList.where((b) => b.id != bookmarkId).toList(),
      );
    });

    _quranRepository.saveBookmarks(_flatten(updatedBookmarks));
    emit(BookmarksState(
      bookmarks: updatedBookmarks,
      bookmarksAyahsSet: _buildCache(updatedBookmarks),
    ));
  }

  List<BookmarkModel> _flatten(Map<int, List<BookmarkModel>> maps) {
    return maps.values.expand((list) => list).toList();
  }

  Set<int> _buildCache(Map<int, List<BookmarkModel>> maps) {
    return maps.values.expand((list) => list).map((b) => b.ayahId).toSet();
  }
}
