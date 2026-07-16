import 'package:quran_library/quran.dart';

/// 4. ويدجت مستقل ومسؤول عن العرض التقليدي للخطوط العادية (غير QPC Layout)
class TraditionalAyahLayout extends StatelessWidget {
  final AyahModel ayah;
  final int pageNumber;
  final double? fontSize;
  final bool? isDark;
  final bool? isBold;
  final Color? textColor;
  final String? fontsName;
  final bool? islocalFont;
  final Color? ayahIconColor;

  const TraditionalAyahLayout({
    super.key,
    required this.ayah,
    required this.pageNumber,
    this.fontSize,
    this.isDark,
    this.isBold,
    this.textColor,
    this.fontsName,
    this.islocalFont,
    this.ayahIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.justify,
      softWrap: true,
      overflow: TextOverflow.visible,
      maxLines: null,
      text: TextSpan(
        style: TextStyle(
          fontFamily: islocalFont == true
              ? fontsName
              : QuranCtrl.instance
                  .getFontPath(pageNumber - 1, isDark: isDark ?? false),
          package: 'quran_library',
          fontSize: fontSize ?? 22,
          height: 2.0,
          fontWeight: isBold! ? FontWeight.bold : FontWeight.normal,
          color: textColor ?? AppColors.getTextColor(isDark!),
        ),
        children: [
          TextSpan(
            text: '${ayah.text.replaceAll('\n', '').split(' ').join(' ')} ',
          ),
          TextSpan(
            text: '${ayah.ayahNumber}'
                .convertEnglishNumbersToArabic('${ayah.ayahNumber}'),
            style: TextStyle(
              fontFamily: 'ayahNumber',
              package: 'quran_library',
              color: ayahIconColor ?? Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
