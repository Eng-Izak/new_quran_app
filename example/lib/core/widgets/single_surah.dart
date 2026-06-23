import 'package:flutter/material.dart';
import 'package:quran_library/quran.dart';

class SingleSurah extends StatelessWidget {
  const SingleSurah({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SurahDisplayScreen(
      parentContext: context,
      surahNumber: 2,
      isDark: false,
      appLanguageCode: 'ar',
      useDefaultAppBar: true,
    );
  }
}
