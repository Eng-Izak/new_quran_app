part of '../../../quran.dart';

class GetSingleAyah extends StatelessWidget {
  final int surahNumber;
  final int ayahNumber;
  final Color? textColor;
  final bool? isDark;
  final bool? isBold;
  final double? fontSize;
  final AyahModel? ayahs;
  final bool? isSingleAyah;
  final bool? islocalFont;
  final String? fontsName;
  final int? pageIndex;
  final Function(LongPressStartDetails details, AyahModel ayah)?
      onAyahLongPress;
  final Color? ayahIconColor;
  final bool showAyahBookmarkedIcon;
  final Color? bookmarksColor;
  final Color? Function(AyahModel)? customBookmarksColor;
  final Color? ayahSelectedBackgroundColor;
  final TextAlign? textAlign;
  final bool? enabledTajweed;
  final bool enableWordSelection;
  final Function(WordRef wordRef)? onWordTap;
  final Color? selectedWordColor;
  final WordRef? externalSelectedWordRef;
  final ({int fromWord, int toWord})? selectedWordsRange;
  final bool? showAyahNumber;
  final double? textHeight;

  GetSingleAyah({
    super.key,
    required this.surahNumber,
    required this.ayahNumber,
    this.textColor,
    this.isDark = false,
    this.fontSize,
    this.isBold = true,
    this.ayahs,
    this.isSingleAyah = true,
    this.islocalFont = false,
    this.fontsName,
    this.pageIndex,
    this.onAyahLongPress,
    this.ayahIconColor,
    this.showAyahBookmarkedIcon = false,
    this.bookmarksColor,
    this.customBookmarksColor,
    this.ayahSelectedBackgroundColor,
    this.textAlign,
    this.enabledTajweed,
    this.enableWordSelection = false,
    this.onWordTap,
    this.selectedWordColor,
    this.externalSelectedWordRef,
    this.selectedWordsRange,
    this.showAyahNumber = true,
    this.textHeight,
  });

  final QuranCtrl quranCtrl = QuranCtrl.instance;
  final Rx<WordRef?> _localSelectedWord = Rx<WordRef?>(null);
  @override
  Widget build(BuildContext context) {
    // تحديث الإعدادات وحفظها عبر GetStorage
    QuranCtrl.instance.state.isTajweedEnabled.value = enabledTajweed ?? false;
    GetStorage().write(_StorageConstants().isTajweed,
        QuranCtrl.instance.state.isTajweedEnabled.value);

    if (surahNumber < 1 || surahNumber > 114) {
      return Text(
        'رقم السورة غير صحيح',
        style: TextStyle(
          fontSize: fontSize ?? 22,
          color: textColor ?? AppColors.getTextColor(isDark!),
        ),
        textAlign: textAlign,
      );
    }

    final ayah = ayahs ??
        quranCtrl.getSingleAyahByAyahAndSurahNumber(ayahNumber, surahNumber);
    final pageNumber = pageIndex ??
        quranCtrl.getPageNumberByAyahAndSurahNumber(ayahNumber, surahNumber);

    QuranFontsService.ensurePagesLoaded(pageNumber, radius: 0).then((_) {
      quranCtrl.update(['single_ayah_$surahNumber-$ayahNumber']);
    });

    log('surahNumber: $surahNumber, ayahNumber: $ayahNumber, pageNumber: $pageNumber');

    if (ayah.text.isEmpty) {
      return Text(
        'الآية غير موجودة',
        style: TextStyle(
          fontSize: fontSize ?? 22,
          color: textColor ?? AppColors.getTextColor(isDark!),
        ),
        textAlign: textAlign,
      );
    }

    if (quranCtrl.isQpcLayoutEnabled) {
      return QpcAyahLayoutBuilder(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        ayah: ayah,
        pageNumber: pageNumber,
        enableWordSelection: enableWordSelection,
        localSelectedWord: _localSelectedWord,
        fontSize: fontSize,
        selectedWordsRange: selectedWordsRange,
        externalSelectedWordRef: externalSelectedWordRef,
        selectedWordColor: selectedWordColor,
        textColor: textColor,
        isDark: isDark,
        isBold: isBold,
        textHeight: textHeight,
        islocalFont: islocalFont,
        fontsName: fontsName,
        showAyahBookmarkedIcon: showAyahBookmarkedIcon,
        ayahIconColor: ayahIconColor,
        textAlign: textAlign,
        onWordTap: onWordTap,
        showAyahNumber: showAyahNumber,
        bookmarksColor: bookmarksColor,
        customBookmarksColor: customBookmarksColor,
        ayahSelectedBackgroundColor: ayahSelectedBackgroundColor,
      );
    }

    return TraditionalAyahLayout(
      ayah: ayah,
      pageNumber: pageNumber,
      fontSize: fontSize,
      isDark: isDark,
      isBold: isBold,
      textColor: textColor,
      fontsName: fontsName,
      islocalFont: islocalFont,
      ayahIconColor: ayahIconColor,
    );
  }
}
