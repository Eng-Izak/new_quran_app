import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:quran_library/quran.dart';
import 'package:quran_library/src/screens/get_single_ayah/widgets/single_ayah_word_highlight.dart';
import 'package:quran_library/src/screens/get_single_ayah/widgets/word_selectable_span_builder.dart';

/// 2. ويدجت مستقل يدعم التفاعل وتحديد الكلمات المفردة أو نطاق كلمات بـ QPC Layout
class SelectableQpcLayout extends StatelessWidget {
  final List<QpcV4WordSegment> segments;
  final int pageNumber;
  final double? fontSize;
  final ({int fromWord, int toWord})? selectedWordsRange;
  final WordRef? externalSelectedWordRef;
  final Color? selectedWordColor;
  final Color? textColor;
  final bool? isDark;
  final double? textHeight;
  final bool? islocalFont;
  final String? fontsName;
  final bool showAyahBookmarkedIcon;
  final Color? ayahIconColor;
  final TextAlign? textAlign;
  final Function(WordRef wordRef)? onWordTap;
  final Rx<WordRef?> localSelectedWord;

  const SelectableQpcLayout({
    super.key,
    required this.segments,
    required this.pageNumber,
    this.fontSize,
    this.selectedWordsRange,
    this.externalSelectedWordRef,
    this.selectedWordColor,
    this.textColor,
    this.isDark,
    this.textHeight,
    this.islocalFont,
    this.fontsName,
    required this.showAyahBookmarkedIcon,
    this.ayahIconColor,
    this.textAlign,
    this.onWordTap,
    required this.localSelectedWord,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedWordsRange != null) {
      return LayoutBuilder(
        builder: (ctx, constraints) {
          final fs =
              fontSize ?? PageFontSizeHelper.getFontSize(pageNumber - 1, ctx);
          return _buildContent(context, fs, null);
        },
      );
    }

    if (externalSelectedWordRef != null) {
      localSelectedWord.value = externalSelectedWordRef;
    } else if (localSelectedWord.value == null && segments.isNotEmpty) {
      final first = segments.first;
      final firstWord = WordRef(
        surahNumber: first.surahNumber,
        ayahNumber: first.ayahNumber,
        wordNumber: first.wordNumber,
      );
      localSelectedWord.value = firstWord;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onWordTap?.call(firstWord);
      });
    }

    return Obx(() {
      final currentWord = localSelectedWord.value;
      return LayoutBuilder(
        builder: (ctx, constraints) {
          final fs =
              fontSize ?? PageFontSizeHelper.getFontSize(pageNumber - 1, ctx);
          return _buildContent(context, fs, currentWord);
        },
      );
    });
  }

  Widget _buildContent(BuildContext context, double fs, WordRef? selectedWord) {
    final effectiveColor = selectedWordColor ??
        Theme.of(context).colorScheme.primary.withValues(alpha: 0.25);
    final List<TextSelection> highlightRanges = [];
    int charOffset = 0;

    final spans = List.generate(segments.length, (i) {
      final seg = segments[i];
      final ref = WordRef(
        surahNumber: seg.surahNumber,
        ayahNumber: seg.ayahNumber,
        wordNumber: seg.wordNumber,
      );

      final span = WordSelectableSpanBuilder.build(
        context: context,
        seg: seg,
        wordRef: ref,
        fontSize: fs,
        pageNumber: pageNumber,
        islocalFont: islocalFont,
        fontsName: fontsName,
        isDark: isDark,
        textColor: textColor,
        textHeight: textHeight,
        showAyahBookmarkedIcon: showAyahBookmarkedIcon,
        ayahIconColor: ayahIconColor,
        onTap: (clickedRef) {
          localSelectedWord.value = clickedRef;
          onWordTap?.call(clickedRef);
        },
      );

      final bool isSelected = selectedWordsRange != null
          ? (seg.wordNumber >= selectedWordsRange!.fromWord &&
              seg.wordNumber <= selectedWordsRange!.toWord)
          : selectedWord == ref;

      if (isSelected) {
        highlightRanges.add(TextSelection(
          baseOffset: charOffset,
          extentOffset: charOffset + seg.glyphs.length,
        ));
      }
      charOffset += _countCharsInSpan(span);

      return span;
    });

    final richText = RichText(
      textDirection: TextDirection.rtl,
      textAlign: textAlign ?? TextAlign.right,
      softWrap: true,
      overflow: TextOverflow.visible,
      maxLines: null,
      text: TextSpan(children: spans),
    );

    if (highlightRanges.isNotEmpty) {
      return SingleAyahWordHighlight(
        wordSelectionRanges: highlightRanges,
        highlightColor: effectiveColor,
        isContiguous: selectedWordsRange != null,
        child: richText,
      );
    }

    return richText;
  }

  int _countCharsInSpan(InlineSpan span) {
    int count = 0;
    span.visitChildren((child) {
      if (child is TextSpan && child.text != null) {
        count += child.text!.length;
      }
      return true;
    });
    return count;
  }
}
