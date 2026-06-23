import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

class SingleAyahWordHighlightRenderBox extends RenderProxyBox {
  SingleAyahWordHighlightRenderBox({
    required List<TextSelection> wordRanges,
    required Color highlightColor,
    required bool isContiguous,
  })  : _wordRanges = wordRanges,
        _highlightColor = highlightColor,
        _isContiguous = isContiguous;

  List<TextSelection> _wordRanges;
  set wordRanges(List<TextSelection> value) {
    if (listEquals(_wordRanges, value)) return;
    _wordRanges = value;
    markNeedsPaint();
  }

  Color _highlightColor;
  set highlightColor(Color value) {
    if (_highlightColor == value) return;
    _highlightColor = value;
    markNeedsPaint();
  }

  bool _isContiguous;
  set isContiguous(bool value) {
    if (_isContiguous == value) return;
    _isContiguous = value;
    markNeedsPaint();
  }

  static const _radius = Radius.circular(16);
  static const _padding =
      EdgeInsets.only(left: 4, right: 4, top: 0, bottom: -6);

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child is RenderParagraph && _wordRanges.isNotEmpty) {
      final paragraph = child! as RenderParagraph;
      final paint = Paint()..color = _highlightColor;

      if (_isContiguous) {
        _paintContiguous(paragraph, context, offset, paint);
      } else {
        _paintIndividual(paragraph, context, offset, paint);
      }
    }
    super.paint(context, offset);
  }

  void _paintContiguous(RenderParagraph paragraph, PaintingContext context,
      Offset offset, Paint paint) {
    final allBoxes = <TextBox>[];
    for (final range in _wordRanges) {
      allBoxes.addAll(paragraph.getBoxesForSelection(range,
          boxHeightStyle: BoxHeightStyle.max));
    }
    if (allBoxes.isEmpty) return;

    final lineRects = <Rect>[];
    Rect? current;
    double? currentTop;
    const lineTolerance = 2.0;

    for (final box in allBoxes) {
      final rect = box.toRect();
      if (current == null) {
        current = rect;
        currentTop = rect.top;
      } else if ((rect.top - currentTop!).abs() < lineTolerance) {
        current = Rect.fromLTRB(
          math.min(current.left, rect.left),
          math.min(current.top, rect.top),
          math.max(current.right, rect.right),
          math.max(current.bottom, rect.bottom),
        );
      } else {
        lineRects.add(current);
        current = rect;
        currentTop = rect.top;
      }
    }
    if (current != null) lineRects.add(current);

    for (int i = 0; i < lineRects.length; i++) {
      final padded = _padding.inflateRect(lineRects[i]).shift(offset);
      final bool isFirst = i == 0;
      final bool isLast = i == lineRects.length - 1;

      final RRect rRect;
      if (lineRects.length == 1) {
        rRect = RRect.fromRectAndRadius(padded, _radius);
      } else if (isFirst) {
        rRect = RRect.fromRectAndCorners(padded,
            topRight: _radius, bottomRight: _radius);
      } else if (isLast) {
        rRect = RRect.fromRectAndCorners(padded,
            topLeft: _radius, bottomLeft: _radius);
      } else {
        rRect = RRect.fromRectAndRadius(padded, Radius.zero);
      }

      context.canvas.drawRRect(rRect, paint);
    }
  }

  void _paintIndividual(RenderParagraph paragraph, PaintingContext context,
      Offset offset, Paint paint) {
    for (final range in _wordRanges) {
      final boxes = paragraph.getBoxesForSelection(range,
          boxHeightStyle: BoxHeightStyle.max);
      if (boxes.isEmpty) continue;

      final mergedRects = <Rect>[];
      Rect? current;
      double? currentTop;
      const lineTolerance = 2.0;

      for (final box in boxes) {
        final rect = box.toRect();
        if (current == null) {
          current = rect;
          currentTop = rect.top;
        } else if ((rect.top - currentTop!).abs() < lineTolerance) {
          current = Rect.fromLTRB(
            math.min(current.left, rect.left),
            math.min(current.top, rect.top),
            math.max(current.right, rect.right),
            math.max(current.bottom, rect.bottom),
          );
        } else {
          mergedRects.add(current);
          current = rect;
          currentTop = rect.top;
        }
      }
      if (current != null) mergedRects.add(current);

      for (final rect in mergedRects) {
        final padded = _padding.inflateRect(rect).shift(offset);
        context.canvas
            .drawRRect(RRect.fromRectAndRadius(padded, _radius), paint);
      }
    }
  }
}
