import 'package:flutter/material.dart';
import 'package:quran_library/quran.dart';

class QuranPages extends StatelessWidget {
  const QuranPages({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: QuranPagesScreen(
        parentContext: context,
        enableMultiSelect: true,
        // highlightedAyahNumbersBySurah: {
        //   2: [7, 8, 9, 10, 11, 12],
        // },
        // page: 6,
        startPage: 6,
        endPage: 60, // النطاق شامل
        // highlightedAyahNumbersInPages: [
        //   (
        //     start: 3,
        //     end: 5,
        //     ayahs: [7, 8, 9, 10, 11, 12],
        //   )
        // ],
        highlightedRanges: const [
          (startSurah: 2, startAyah: 30, endSurah: 2, endAyah: 35)
        ],
        withPageView: true, // تمكين/تعطيل السحب بين الصفحات
      ),
    );
  }
}
