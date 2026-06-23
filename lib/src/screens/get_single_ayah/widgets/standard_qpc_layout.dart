// 1. ويدجت مستقل لعرض مصحف المدينة QPC العادي بدون تحديد كلمات
import 'package:flutter/material.dart';
import 'package:quran_library/quran.dart';
import 'package:quran_library/src/core/utils/app_colors.dart';

class StandardQpcLayout extends StatelessWidget {
  final List<QpcV4WordSegment> segments;
  final double fontSize;
  final int pageNumber;
  final TextAlign? textAlign;
  final Color? textColor;
  final bool? isDark;
  final bool? showAyahNumber;
  final bool showAyahBookmarkedIcon;
  final Color? ayahIconColor;
  final Color? bookmarksColor;
  final Color? Function(AyahModel)? customBookmarksColor;
  final Color? ayahSelectedBackgroundColor;
  final bool? islocalFont;
  final String? fontsName;

  const StandardQpcLayout({
    super.key,
    required this.segments,
    required this.fontSize,
    required this.pageNumber,
    this.textAlign,
    this.textColor,
    this.isDark,
    this.showAyahNumber,
    required this.showAyahBookmarkedIcon,
    this.ayahIconColor,
    this.bookmarksColor,
    this.customBookmarksColor,
    this.ayahSelectedBackgroundColor,
    this.islocalFont,
    this.fontsName,
  });

  @override
  Widget build(BuildContext context) {
    final wordInfoCtrl = WordInfoCtrl.instance;
    final bookmarksCtrl = BookmarksCtrl.instance;
    final bookmarksAyahs = bookmarksCtrl.bookmarksAyahs;
    final allBookmarksList =
        bookmarksCtrl.bookmarks.values.expand((list) => list).toList();

    return RichText(
      textDirection: TextDirection.rtl,
      textAlign: textAlign ?? TextAlign.right,
      softWrap: true,
      overflow: TextOverflow.visible,
      maxLines: null,
      text: TextSpan(
        children: List.generate(segments.length, (segmentIndex) {
          final seg = segments[segmentIndex];
          final uq = seg.ayahUq;
          final isSelectedCombined =
              QuranCtrl.instance.selectedAyahsByUnequeNumber.contains(uq) ||
                  QuranCtrl.instance.externallyHighlightedAyahs.contains(uq);

          final ref = WordRef(
            surahNumber: seg.surahNumber,
            ayahNumber: seg.ayahNumber,
            wordNumber: seg.wordNumber,
          );

          final hasKhilaf =
              wordInfoCtrl.getRecitationsInfoSync(ref)?.hasKhilaf ?? false;

          return _qpcV4SpanSegment(
            context: context,
            pageIndex: pageNumber - 1,
            isSelected: isSelectedCombined,
            showAyahBookmarkedIcon: showAyahBookmarkedIcon,
            fontSize: fontSize,
            ayahUQNum: uq,
            ayahNumber: seg.ayahNumber,
            glyphs: seg.glyphs,
            showAyahNumber: (showAyahNumber ?? true) && seg.isAyahEnd,
            wordRef: ref,
            isWordKhilaf: hasKhilaf,
            textColor: textColor ?? AppColors.getTextColor(isDark ?? false),
            ayahIconColor: ayahIconColor,
            allBookmarksList: allBookmarksList,
            bookmarksAyahs: bookmarksAyahs,
            bookmarksColor: bookmarksColor,
            customBookmarksColor: customBookmarksColor,
            ayahSelectedBackgroundColor: ayahSelectedBackgroundColor,
            isFontsLocal: islocalFont ?? false,
            fontsName: fontsName ?? '',
            fontFamilyOverride: null,
            fontPackageOverride: null,
            usePaintColoring: true,
            ayahBookmarked: bookmarksAyahs.toList(),
            isDark: isDark ?? false,
          );
        }),
      ),
    );
  }

  TextSpan _qpcV4SpanSegment({
    required BuildContext context,
    required int pageIndex,
    required bool isSelected,
    required bool showAyahBookmarkedIcon,
    required double fontSize,
    required int ayahUQNum,
    required int ayahNumber,
    required String glyphs,
    required bool showAyahNumber,
    required WordRef wordRef,
    required bool isWordKhilaf,
    required Color textColor,
    Color? ayahIconColor,
    required List<dynamic> allBookmarksList,
    required dynamic bookmarksAyahs,
    Color? bookmarksColor,
    Color? Function(AyahModel)? customBookmarksColor,
    Color? ayahSelectedBackgroundColor,
    required bool isFontsLocal,
    required String fontsName,
    String? fontFamilyOverride,
    String? fontPackageOverride,
    required bool usePaintColoring,
    required List<int> ayahBookmarked,
    required bool isDark,
  }) {
    return TextSpan(
      text: '$glyphs${showAyahNumber ? ' $ayahNumber' : ''}',
      style: TextStyle(
        fontSize: fontSize,
        color: textColor,
        backgroundColor: isSelected
            ? ayahSelectedBackgroundColor ?? Colors.transparent
            : null,
        fontFamily: fontsName.isNotEmpty ? fontsName : null,
      ),
    );
  }
}
