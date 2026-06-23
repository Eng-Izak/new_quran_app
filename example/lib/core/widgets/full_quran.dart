import 'package:flutter/material.dart';
import 'package:quran_library/quran.dart';

class FullQuran extends StatelessWidget {
  const FullQuran({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return QuranLibraryScreen(
      parentContext: context,
      isDark: true,
      isShowTabBar: true,
      isFontsLocal: false,
      useDefaultAppBar: true,
      enableWordSelection: true,
      isShowDisplayModeBar: true,
      showAyahBookmarkedIcon: true,
      appLanguageCode: 'ar',
      ayahMenuStyle:
          AyahMenuStyle.defaults(isDark: false, context: context).copyWith(
        customMenuItems: [
          const Icon(Icons.share, size: 28, color: Colors.teal),
        ],
      ),
    );
  }
}
