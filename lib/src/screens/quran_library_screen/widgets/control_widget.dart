import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:quran_library/quran_library.dart';
import 'package:quran_library/src/core/utils/app_colors.dart';

class ControlWidget extends StatelessWidget {
  const ControlWidget({
    super.key,
    required this.isShowAudioSlider,
    required this.ayahStyle,
    required this.isDark,
    required this.languageCode,
    required this.ayahDownloadManagerStyle,
    required this.backgroundColor,
    required this.textColor,
    required this.appBar,
    required this.useDefaultAppBar,
    required this.surahStyle,
    required this.downloadFontsDialogStyle,
    required this.isFontsLocal,
    required this.isShowTabBar,
    required this.topBarStyle,
    required this.isShowDisplayModeBar,
    required this.autoScrollStyle,
  });

  final bool? isShowAudioSlider;
  final AyahAudioStyle? ayahStyle;
  final bool isDark;
  final String languageCode;
  final AyahDownloadManagerStyle? ayahDownloadManagerStyle;
  final Color? backgroundColor;
  final Color? textColor;
  final PreferredSizeWidget? appBar;
  final bool useDefaultAppBar;
  final SurahAudioStyle? surahStyle;
  final DownloadFontsDialogStyle? downloadFontsDialogStyle;
  final bool? isFontsLocal;
  final bool? isShowTabBar;
  final bool? isShowDisplayModeBar;
  final QuranTopBarStyle? topBarStyle;
  final AutoScrollStyle? autoScrollStyle;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuranCtrl>(
      id: 'isShowControl',
      builder: (quranCtrl) {
        return Obx(() {
          final visible = quranCtrl.isShowControl.value;
          // إخفاء كل عناصر التحكم أثناء السكرول التلقائي النشط (غير المتوقف)
          final autoScroll = AutoScrollCtrl.instance;
          final isAutoScrollRunning = autoScroll.state.isActive.value &&
              !autoScroll.state.isPaused.value;
          final shouldShow = visible && !isAutoScrollRunning;

          return RepaintBoundary(
            child: IgnorePointer(
              ignoring: !shouldShow,
              child: AnimatedOpacity(
                opacity: shouldShow ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeInOut,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // السلايدر السفلي - يظهر من الأسفل للأعلى
                    // Bottom slider - appears from bottom to top
                    isShowAudioSlider!
                        ? AyahsAudioWidget(
                            style: ayahStyle ??
                                AyahAudioStyle.defaults(
                                    isDark: isDark, context: context),
                            isDark: isDark,
                            languageCode: languageCode,
                            downloadManagerStyle: ayahDownloadManagerStyle,
                          )
                        : const SizedBox.shrink(),
                    kIsWeb
                        ? JumpingPageControllerWidget(
                            backgroundColor: backgroundColor,
                            isDark: isDark,
                            textColor: textColor,
                            quranCtrl: quranCtrl,
                          )
                        : const SizedBox.shrink(),
                    appBar == null && useDefaultAppBar && visible
                        ? QuranTopBar(
                            languageCode,
                            isDark,
                            style: surahStyle ?? SurahAudioStyle(),
                            backgroundColor: backgroundColor,
                            downloadFontsDialogStyle: downloadFontsDialogStyle,
                            isFontsLocal: isFontsLocal,
                          )
                        : const SizedBox.shrink(),
                    isShowTabBar!
                        ? Positioned(
                            top: 70,
                            child: QuranOrTenRecitationsTabBar(
                                bgColor: backgroundColor ??
                                    AppColors.getBackgroundColor(isDark),
                                defaults: topBarStyle ??
                                    QuranTopBarStyle.defaults(
                                        context: context, isDark: isDark),
                                isDark: isDark),
                          )
                        : const SizedBox.shrink(),
                    // شريط اختيار وضع العرض - يظهر على الجانب
                    // Display mode selector bar - appears on the side
                    if (isShowDisplayModeBar!)
                      Positioned(
                        right: 8,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: DisplayModeBar(
                            isDark: isDark,
                            languageCode: languageCode,
                          ),
                        ),
                      ),
                    // شريط التحكم بسرعة السكرول التلقائي — يبقى ظاهرًا بشكل مستقل
                    AutoScrollSpeedSlider(
                      isDark: isDark,
                      autoScrollStyle: autoScrollStyle ??
                          AutoScrollStyle.defaults(
                              isDark: isDark, context: context),
                      languageCode: languageCode,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
