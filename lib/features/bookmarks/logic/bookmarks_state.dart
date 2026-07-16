import '../data/models/bookmark_model.dart';

class BookmarksState {
  final Map<int, List<BookmarkModel>> bookmarks;
  final Set<int> bookmarksAyahsSet;

  BookmarksState({
    required this.bookmarks,
    required this.bookmarksAyahsSet,
  });

  BookmarksState copyWith({
    Map<int, List<BookmarkModel>>? bookmarks,
    Set<int>? bookmarksAyahsSet,
  }) {
    return BookmarksState(
      bookmarks: bookmarks ?? this.bookmarks,
      bookmarksAyahsSet: bookmarksAyahsSet ?? this.bookmarksAyahsSet,
    );
  }
}
