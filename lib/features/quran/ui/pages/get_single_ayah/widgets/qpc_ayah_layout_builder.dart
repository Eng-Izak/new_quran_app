import 'package:quran_library/quran.dart';
import 'selectable_qpc_layout.dart';
import 'standard_qpc_layout.dart';
import 'traditional_ayah_layout.dart';

class QpcAyahLayoutBuilder extends StatelessWidget {
  final int surahNumber;
  final int ayahNumber;
  final AyahModel ayah;
  final int pageNumber;
  final bool enableWordSelection;
  final double? fontSize;
  final ({int fromWord, int toWord})? selectedWordsRange;
  final WordRef? externalSelectedWordRef;
  final Color? selectedWordColor;
  final Color? textColor;
  final bool? isDark;
  final bool? isBold;
  final double? textHeight;
  final bool? islocalFont;
  final String? fontsName;
  final bool showAyahBookmarkedIcon;
  final Color? ayahIconColor;
  final TextAlign? textAlign;
  final Function(WordRef wordRef)? onWordTap;
  final Rx<WordRef?> localSelectedWord;
  final bool? showAyahNumber;
  final Color? bookmarksColor;
  final Color? Function(AyahModel)? customBookmarksColor;
  final Color? ayahSelectedBackgroundColor;

  const QpcAyahLayoutBuilder({
    super.key,
    required this.surahNumber,
    required this.ayahNumber,
    required this.ayah,
    required this.pageNumber,
    required this.enableWordSelection,
    required this.localSelectedWord,
    required this.showAyahBookmarkedIcon,
    this.fontSize,
    this.selectedWordsRange,
    this.externalSelectedWordRef,
    this.selectedWordColor,
    this.textColor,
    this.isDark,
    this.isBold,
    this.textHeight,
    this.islocalFont,
    this.fontsName,
    this.ayahIconColor,
    this.textAlign,
    this.onWordTap,
    this.showAyahNumber,
    this.bookmarksColor,
    this.customBookmarksColor,
    this.ayahSelectedBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final quranCtrl = QuranCtrl.instance;
    final blocks = quranCtrl.getQpcLayoutBlocksForPageSync(pageNumber);

    if (blocks.isEmpty) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    // استخراج segments الخاصة بالآية المطلوبة فقط
    final List<QpcV4WordSegment> ayahSegments = [];
    for (final block in blocks) {
      if (block is QpcV4AyahLineBlock) {
        for (final seg in block.segments) {
          if (seg.surahNumber == surahNumber && seg.ayahNumber == ayahNumber) {
            ayahSegments.add(seg);
          }
        }
      }
    }

    // fallback للعرض التقليدي إذا لم يتم العثور على segments
    if (ayahSegments.isEmpty) {
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

    // عرض مع تحديد الكلمات
    if (enableWordSelection) {
      return SelectableQpcLayout(
        segments: ayahSegments,
        pageNumber: pageNumber,
        fontSize: fontSize,
        selectedWordsRange: selectedWordsRange,
        externalSelectedWordRef: externalSelectedWordRef,
        selectedWordColor: selectedWordColor,
        textColor: textColor,
        isDark: isDark,
        textHeight: textHeight,
        islocalFont: islocalFont,
        fontsName: fontsName,
        showAyahBookmarkedIcon: showAyahBookmarkedIcon,
        ayahIconColor: ayahIconColor,
        textAlign: textAlign,
        onWordTap: onWordTap,
        localSelectedWord: localSelectedWord,
      );
    }

    // العرض الأصلي القياسي بدون تحديد الكلمات
    return GetBuilder<QuranCtrl>(
      id: 'single_ayah_${ayah.ayahUQNumber}',
      builder: (_) => LayoutBuilder(
        builder: (ctx, constraints) {
          final fs =
              fontSize ?? PageFontSizeHelper.getFontSize(pageNumber - 1, ctx);
          return StandardQpcLayout(
            segments: ayahSegments,
            fontSize: fs,
            pageNumber: pageNumber,
            textAlign: textAlign,
            textColor: textColor,
            isDark: isDark,
            showAyahNumber: showAyahNumber,
            showAyahBookmarkedIcon: showAyahBookmarkedIcon,
            ayahIconColor: ayahIconColor,
            bookmarksColor: bookmarksColor,
            customBookmarksColor: customBookmarksColor,
            ayahSelectedBackgroundColor: ayahSelectedBackgroundColor,
            islocalFont: islocalFont,
            fontsName: fontsName,
          );
        },
      ),
    );
  }
}
