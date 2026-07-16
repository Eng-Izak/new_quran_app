import 'package:quran_library/quran.dart';
import 'item_builder_widget.dart';

class QuranPageViewLayout extends StatelessWidget {
  final bool withPageView;
  final int pageIndex;
  final QuranCtrl quranCtrl;
  final String languageCode;
  final int? surahNumber;
  final bool isDark;
  final bool isFontsLocal;
  final String? fontsName;
  final BuildContext parentContext;

  // Callbacks
  final Function(BuildContext, int, QuranCtrl) onPageChange;
  final VoidCallback? onPagePress;
  final Function(LongPressStartDetails details, AyahModel ayah)?
      onAyahLongPress;
  final void Function(SurahNamesModel)? onSurahBannerPress;

  // Styles & Colors
  final Color? ayahSelectedFontColor;
  final Color? textColor;
  final Color? ayahIconColor;
  final Color? bookmarksColor;
  final Color? ayahSelectedBackgroundColor;
  final Color? Function(AyahModel)? customBookmarksColor;
  final SurahNameStyle? surahNameStyle;
  final BannerStyle? bannerStyle;
  final BasmalaStyle? basmalaStyle;

  // Icons & Lists
  final bool showAyahBookmarkedIcon;
  final Widget? circularProgressWidget;
  final List<BookmarkModel>? bookmarkList;
  final List<int>? ayahBookmarked;
  final bool Function(AyahModel)? isAyahBookmarked;

  const QuranPageViewLayout({
    super.key,
    required this.withPageView,
    required this.pageIndex,
    required this.quranCtrl,
    required this.languageCode,
    required this.onPageChange,
    this.onPagePress,
    this.onAyahLongPress,
    this.onSurahBannerPress,
    this.circularProgressWidget,
    this.bookmarkList,
    this.ayahSelectedFontColor,
    this.textColor,
    this.ayahIconColor,
    this.showAyahBookmarkedIcon = false,
    this.bookmarksColor,
    this.customBookmarksColor,
    this.surahNameStyle,
    this.bannerStyle,
    this.basmalaStyle,
    this.surahNumber,
    this.ayahSelectedBackgroundColor,
    this.isDark = false,
    this.fontsName,
    this.ayahBookmarked,
    this.isAyahBookmarked,
    required this.parentContext,
    this.isFontsLocal = false,
  });

  @override
  Widget build(BuildContext context) {
    if (withPageView) {
      return Focus(
        focusNode: quranCtrl.state.quranPageRLFocusNode,
        autofocus: !kIsWeb,
        onKeyEvent: (node, event) => quranCtrl.controlRLByKeyboard(node, event),
        child: PatchedPreloadPageView.builder(
          preloadPagesCount: 2,
          padEnds: false,
          itemCount: 604,
          controller: quranCtrl.getPageController(context),
          physics: quranCtrl.state.isScaling.value
              ? const NeverScrollableScrollPhysics()
              : const ClampingScrollPhysics(),
          onPageChanged: (idx) => onPageChange(context, idx, quranCtrl),
          pageSnapping: true,
          itemBuilder: (ctx, index) => _buildItem(index),
        ),
      );
    }

    return _buildItem(pageIndex);
  }

  /// ميثود داخلية لمنع تكرار كود الـ ItemBuilderWidget بين الحالتين
  Widget _buildItem(int index) {
    return ItemBuilderWidget(
      index: index,
      quranCtrl: quranCtrl,
      onPagePress: onPagePress,
      circularProgressWidget: circularProgressWidget,
      languageCode: languageCode,
      bookmarkList: bookmarkList!.cast<dynamic>(),
      ayahSelectedFontColor: ayahSelectedFontColor,
      textColor: textColor,
      ayahIconColor: ayahIconColor,
      showAyahBookmarkedIcon: showAyahBookmarkedIcon,
      onAyahLongPress: onAyahLongPress,
      bookmarksColor: bookmarksColor,
      customBookmarksColor: customBookmarksColor,
      surahNameStyle: surahNameStyle,
      bannerStyle: bannerStyle,
      basmalaStyle: basmalaStyle,
      onSurahBannerPress: onSurahBannerPress,
      surahNumber: surahNumber,
      ayahSelectedBackgroundColor: ayahSelectedBackgroundColor,
      isDark: isDark,
      fontsName: fontsName,
      ayahBookmarked: ayahBookmarked,
      isAyahBookmarked: isAyahBookmarked,
      parentContext: parentContext,
      isFontsLocal: isFontsLocal,
    );
  }
}
