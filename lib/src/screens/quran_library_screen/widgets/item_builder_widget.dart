import 'package:flutter/material.dart';
import 'package:quran_library/quran.dart';

class ItemBuilderWidget extends StatelessWidget {
  const ItemBuilderWidget({
    super.key,
    required this.index,
    required this.quranCtrl,
    required this.onPagePress,
    required this.circularProgressWidget,
    required this.languageCode,
    required this.bookmarkList,
    required this.ayahSelectedFontColor,
    required this.textColor,
    required this.ayahIconColor,
    required this.showAyahBookmarkedIcon,
    required this.onAyahLongPress,
    required this.bookmarksColor,
    this.customBookmarksColor,
    required this.surahNameStyle,
    required this.bannerStyle,
    required this.basmalaStyle,
    required this.onSurahBannerPress,
    required this.surahNumber,
    required this.ayahSelectedBackgroundColor,
    required this.isDark,
    required this.fontsName,
    required this.ayahBookmarked,
    required this.isAyahBookmarked,
    required this.parentContext,
    required this.isFontsLocal,
  });

  final int index;
  final QuranCtrl quranCtrl;
  final VoidCallback? onPagePress;
  final Widget? circularProgressWidget;
  final String languageCode;
  final List<dynamic> bookmarkList;
  final Color? ayahSelectedFontColor;
  final Color? textColor;
  final Color? ayahIconColor;
  final bool showAyahBookmarkedIcon;
  final void Function(LongPressStartDetails details, AyahModel ayah)?
      onAyahLongPress;
  final Color? bookmarksColor;
  final Color? Function(AyahModel)? customBookmarksColor;
  final SurahNameStyle? surahNameStyle;
  final BannerStyle? bannerStyle;
  final BasmalaStyle? basmalaStyle;
  final void Function(SurahNamesModel surah)? onSurahBannerPress;
  final int? surahNumber;
  final Color? ayahSelectedBackgroundColor;
  final bool isDark;
  final String? fontsName;
  final List<int>? ayahBookmarked;
  final bool Function(AyahModel ayah)? isAyahBookmarked;
  final BuildContext parentContext;
  final bool? isFontsLocal;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onPagePress != null) {
          onPagePress!();
        } else {
          quranCtrl.showControlToggle();
          QuranCtrl.instance.state.isShowMenu.value = false;
        }
      },
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: RepaintBoundary(
        key: ValueKey('quran_page_$index'),
        child: PageViewBuild(
          circularProgressWidget: circularProgressWidget,
          languageCode: languageCode,
          bookmarkList: bookmarkList,
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
          onPagePress: onPagePress,
          isDark: isDark,
          fontsName: fontsName,
          ayahBookmarked: ayahBookmarked,
          isAyahBookmarked: isAyahBookmarked,
          userContext: parentContext,
          pageIndex: index,
          quranCtrl: quranCtrl,
          isFontsLocal: isFontsLocal!,
        ),
      ),
    );
  }
}
