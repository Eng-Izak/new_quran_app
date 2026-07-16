import 'package:flutter/gestures.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quran_library/quran.dart';

/// 3. مسؤول عن تشكيل وبناء الـ TextSpan الفردي لكل كلمة قابلة للتحديد
class WordSelectableSpanBuilder {
  static TextSpan build({
    required BuildContext context,
    required QpcV4WordSegment seg,
    required WordRef wordRef,
    required double fontSize,
    required int pageNumber,
    required bool? islocalFont,
    required String? fontsName,
    required bool? isDark,
    required Color? textColor,
    required double? textHeight,
    required bool showAyahBookmarkedIcon,
    required Color? ayahIconColor,
    required Function(WordRef) onTap,
  }) {
    final pageIndex = pageNumber - 1;
    final quranCtrl = QuranCtrl.instance;
    final withTajweed = quranCtrl.state.isTajweedEnabled.value;
    final isTenRecitations = WordInfoCtrl.instance.isTenRecitations;

    final hasKhilaf =
        WordInfoCtrl.instance.getRecitationsInfoSync(wordRef)?.hasKhilaf ??
            false;
    final bool forceRed = hasKhilaf && !withTajweed && isTenRecitations;

    final String fontFamily = islocalFont == true
        ? (fontsName ?? '')
        : (forceRed
            ? quranCtrl.getRedFontPath(pageIndex)
            : quranCtrl.getFontPath(pageIndex, isDark: isDark ?? false));

    final baseTextStyle = TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      height: textHeight ?? 1.2,
      wordSpacing: -2,
      color: textColor ?? AppColors.getTextColor(isDark ?? false),
    );

    InlineSpan? tail;
    if (seg.isAyahEnd) {
      final hasBookmark =
          BookmarksCtrl.instance.bookmarksAyahs.contains(seg.ayahUq);

      if (hasBookmark && showAyahBookmarkedIcon && !kIsWeb) {
        tail = WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: SvgPicture.asset(
              AssetsPath.assets.ayahBookmarked,
              height: 30,
              width: 30,
            ),
          ),
        );
      } else {
        tail = TextSpan(
          text:
              '${' ${seg.ayahNumber}'.convertEnglishNumbersToArabic('${seg.ayahNumber}')}\u202F\u202F',
          style: TextStyle(
            fontFamily: 'ayahNumber',
            fontSize: fontSize + 5,
            height: 1.5,
            package: 'quran_library',
            color: ayahIconColor ?? Theme.of(context).colorScheme.primary,
          ),
        );
      }
    }

    return TextSpan(
      children: <InlineSpan>[
        TextSpan(
          text: seg.glyphs,
          style: baseTextStyle,
          recognizer: TapGestureRecognizer()..onTap = () => onTap(wordRef),
        ),
        if (tail != null) tail,
      ],
    );
  }
}
