// 5. رندرة مستقلة ومخصصة لتظليل الكلمات المحددة بأبعاد مرنة
import 'package:flutter/material.dart';
import 'package:quran_library/src/screens/get_single_ayah/widgets/single_ayah_word_highlight_render_box.dart';

class SingleAyahWordHighlight extends SingleChildRenderObjectWidget {
  final List<TextSelection> wordSelectionRanges;
  final Color highlightColor;
  final bool isContiguous;

  const SingleAyahWordHighlight({
    super.key,
    required this.wordSelectionRanges,
    required this.highlightColor,
    this.isContiguous = false,
    required super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return SingleAyahWordHighlightRenderBox(
      wordRanges: wordSelectionRanges,
      highlightColor: highlightColor,
      isContiguous: isContiguous,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, SingleAyahWordHighlightRenderBox renderObject) {
    renderObject
      ..wordRanges = wordSelectionRanges
      ..highlightColor = highlightColor
      ..isContiguous = isContiguous;
  }
}
