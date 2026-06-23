import 'package:flutter/material.dart';
import 'package:quran_library/quran.dart';

class SingleAyah extends StatelessWidget {
  const SingleAyah({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GetSingleAyah(
        surahNumber: 1,
        ayahNumber: 2,
        fontSize: 30,
        isBold: false,
        islocalFont: false,
        isDark: true,
        textHeight: 1.5,
        enabledTajweed: true,
        enableWordSelection: true,
        onWordTap: (ref) {
          print(
              'سورة: ${ref.surahNumber}, آية: ${ref.ayahNumber}, كلمة: ${ref.wordNumber}');
        },
        selectedWordColor: Colors.amber.withValues(alpha: 0.3),
      ),
    );
  }
}
