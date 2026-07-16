
abstract class _AssetsPath {
  _AssetsPath._();
  String get surahSvgBanner;
  String get surahSvgBannerDark;
  String get ayahBookmarked;
  String get sajdaIcon;
  String get suraNum;
  String get playArrow;
  String get pauseArrow;
  String get checkMark;
  String get alert;
  String get backward;
  String get rewind;
  String get surahsAudio;
  String get buttomSheet;
  String get options;
  String get backArrow;
  String get exclamation;
  String get arrowDown;
}

class AssetsPath implements _AssetsPath {
  // 1. اجعل الـ constructor خاصًا
  AssetsPath._();

  // 2. أنشئ نسخة ثابتة (singleton) للوصول إليها بسهولة
  static final AssetsPath assets = AssetsPath._();

  // 3. Flag to control whether to use the packages/quran_library/ prefix
  static bool usePackagePrefix = true;

  // 4. الدالة السحرية noSuchMethod
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.isGetter) {
      // استخراج اسم الـ getter (مثل: playArrow)
      final getterName = invocation.memberName.toString().split('"')[1];

      // تحويل اسم المتغير من camelCase (playArrow) إلى اسم الملف
      final fileName = '$getterName.svg';

      final prefix = usePackagePrefix
          ? "packages/quran_library/assets/svg/"
          : "assets/svg/";

      // إرجاع المسار الكامل
      return '$prefix$fileName';
    }
    return super.noSuchMethod(invocation);
  }
}
