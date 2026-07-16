// Custom Quran Library Entry Point

export 'dart:async';
export 'dart:convert' hide Codec;
export 'dart:developer' hide Flow;
export 'dart:math' hide log;
export 'dart:ui' hide Codec, Gradient, decodeImageFromList, ImageDecoderCallback, StrutStyle, TextStyle, Image;
export 'dart:io' hide HeaderValue, File, Directory, Platform, FileSystemEntity;
export 'package:flutter/foundation.dart';
export 'package:flutter/material.dart' hide SnackBarTheme, Flow;
export 'package:flutter/services.dart';
export 'package:get/get.dart' hide Response, FormData, MultipartFile, StringExtension;
export 'package:get_storage/get_storage.dart';
export 'package:dio/dio.dart';
export 'package:preload_page_view/preload_page_view.dart' hide PageScrollPhysics, PageMetrics;
export 'package:just_audio/just_audio.dart';
export 'package:just_audio_media_kit/just_audio_media_kit.dart';
export 'package:connectivity_plus/connectivity_plus.dart';

// Core Layer
export 'core/theme/quran_library_theme.dart';
export 'core/utils/app_colors.dart';
export 'core/utils/assets_path.dart';
export 'core/utils/toast_utils.dart';
export 'core/utils/ui_helper.dart';
export 'core/widgets/custom_app_bar.dart';
export 'core/widgets/download_button_widget.dart';
export 'core/widgets/header_dialog_widget.dart';
export 'core/widgets/patched_preload_page_view.dart';
export 'core/dependancy_injection/di.dart';
export 'core/services/connectivity_service.dart';
export 'core/services/gzip_json_asset_service.dart';
export 'core/services/internet_connection_cubit.dart';
export 'core/platform/file_system.dart';
export 'core/platform/file_system_platform.dart';
export 'core/platform/io_helpers.dart';
export 'core/platform/platform_info.dart';

// Features - Quran Core & Data & Logic
export 'features/quran/core/extensions/context_extensions.dart';
export 'features/quran/core/extensions/convert_arabic_to_english_numbers_extension.dart';
export 'features/quran/core/extensions/convert_number_extension.dart';
export 'features/quran/core/extensions/font_size_extension.dart';
export 'features/quran/core/extensions/fonts_extension.dart';
export 'features/quran/core/extensions/sajda_extension.dart';
export 'features/quran/core/extensions/string_extensions.dart';
export 'features/quran/core/extensions/surah_info_extension.dart';
export 'features/quran/core/extensions/text_span_extension.dart';
export 'features/quran/core/helpers/page_font_size.dart';
export 'features/quran/core/helpers/responsive.dart';
export 'features/quran/core/services/quran_fonts_service.dart';
export 'features/quran/core/services/sura_json_files_service.dart';
export 'features/quran/core/services/word_audio_service.dart';
export 'features/quran/core/services/zip_download_service.dart';
export 'features/quran/core/utils/storage_constants.dart';
export 'features/quran/core/utils/tajweed_rules_list.dart';

export 'features/quran/data/models/auto_scroll_stop_condition.dart';
export 'features/quran/data/models/ayah_model.dart';
export 'features/quran/data/models/display_mode.dart';
export 'features/quran/data/models/quran_constants.dart';
export 'features/quran/data/models/quran_fonts_models/download_fonts_dialog_style.dart';
export 'features/quran/data/models/quran_fonts_models/sajda_model.dart';
export 'features/quran/data/models/quran_page.dart';
export 'features/quran/data/models/quran_recitation.dart';
export 'features/quran/data/models/styles_models/auto_scroll_style.dart';
export 'features/quran/data/models/styles_models/ayah_menu_style.dart';
export 'features/quran/data/models/styles_models/ayah_tafsir_inline_style.dart';
export 'features/quran/data/models/styles_models/banner_style.dart';
export 'features/quran/data/models/styles_models/basmala_style.dart';
export 'features/quran/data/models/styles_models/bookmarks_tab_style.dart';
export 'features/quran/data/models/styles_models/display_mode_bar_style.dart';
export 'features/quran/data/models/styles_models/index_tab_style.dart';
export 'features/quran/data/models/styles_models/quran_tafsir_side_style.dart';
export 'features/quran/data/models/styles_models/quran_top_bar_style.dart';
export 'features/quran/data/models/styles_models/search_tab_style.dart';
export 'features/quran/data/models/styles_models/snackbar_style.dart';
export 'features/quran/data/models/styles_models/surah_info_style.dart';
export 'features/quran/data/models/styles_models/surah_name_style.dart';
export 'features/quran/data/models/styles_models/tajweed_menu_style.dart';
export 'features/quran/data/models/styles_models/top_bottom_quran_style.dart';
export 'features/quran/data/models/styles_models/word_info_bottom_sheet_style.dart';
export 'features/quran/data/models/surah_names_model.dart';
export 'features/quran/data/models/word_info_models.dart';
export 'features/quran/data/qpc_v4/qpc_hafs_word_by_word_assets_loader.dart';
export 'features/quran/data/qpc_v4/qpc_v4_assets_loader.dart';
export 'features/quran/data/qpc_v4/qpc_v4_models.dart';
export 'features/quran/data/qpc_v4/qpc_v4_page_renderer.dart';
export 'features/quran/data/repositories/quran_repository.dart';
export 'features/quran/data/repositories/word_info_repository.dart';

export 'features/quran/presentation/controllers/bookmark/bookmarks_ctrl.dart';
export 'features/quran/presentation/controllers/auto_scroll/auto_scroll_ctrl.dart';
export 'features/quran/presentation/controllers/auto_scroll/auto_scroll_state.dart';
export 'features/quran/presentation/controllers/quran/quran_ctrl.dart';
export 'features/quran/presentation/controllers/quran/quran_getters.dart';
export 'features/quran/presentation/controllers/quran/quran_state.dart';
export 'features/quran/presentation/controllers/surah/surah_ctrl.dart';
export 'features/quran/presentation/controllers/word_info/word_info_ctrl.dart';

export 'features/quran/presentation/widgets/auto_scroll/auto_scroll_settings_widget.dart';
export 'features/quran/presentation/widgets/auto_scroll/auto_scroll_speed_slider.dart';
export 'features/quran/presentation/widgets/ayah_menu_dialog.dart';
export 'features/quran/presentation/widgets/bsmallah_widget.dart';
export 'features/quran/presentation/widgets/display_mode_bar.dart';
export 'features/quran/presentation/widgets/display_modes/auto_scroll_page_view.dart';
export 'features/quran/presentation/widgets/display_modes/ayah_with_tafsir_inline.dart';
export 'features/quran/presentation/widgets/display_modes/dual_page_view.dart';
export 'features/quran/presentation/widgets/display_modes/quran_with_tafsir_side.dart';
export 'features/quran/presentation/widgets/display_modes/single_scrollable_page.dart';
export 'features/quran/presentation/widgets/download_fonts_page/custom_span.dart';
export 'features/quran/presentation/widgets/download_fonts_page/page_build.dart';
export 'features/quran/presentation/widgets/download_fonts_page/qpc_v4_flowing_text.dart';
export 'features/quran/presentation/widgets/download_fonts_page/quran_fonts_page.dart';
export 'features/quran/presentation/widgets/download_fonts_page/rich_text_build.dart';
export 'features/quran/presentation/widgets/fonts_download_dialog.dart';
export 'features/quran/presentation/widgets/fonts_download_widget.dart';
export 'features/quran/presentation/widgets/jumping_between_pages_widget.dart';
export 'features/quran/presentation/widgets/page_view_build.dart';
export 'features/quran/presentation/widgets/surah_header_widget.dart';
export 'features/quran/presentation/widgets/surah_page/surah_page_view_build.dart';
export 'features/quran/presentation/widgets/tabs/bookmark_tab_widget.dart';
export 'features/quran/presentation/widgets/tabs/index_tab_widget.dart';
export 'features/quran/presentation/widgets/tabs/quran_or_ten_recitations_tab_bar.dart';
export 'features/quran/presentation/widgets/tabs/quran_top_bar.dart';
export 'features/quran/presentation/widgets/tabs/search_tab_widget.dart';
export 'features/quran/presentation/widgets/tajweed_menu_widget.dart';
export 'features/quran/presentation/widgets/top_bottom_widget/build_bottom_section.dart';
export 'features/quran/presentation/widgets/top_bottom_widget/build_top_section.dart';
export 'features/quran/presentation/widgets/top_bottom_widget/top_and_bottom_widget.dart';
export 'features/quran/presentation/widgets/word_info/marked_content_span.dart';
export 'features/quran/presentation/widgets/word_info/tap_long_press_recognizer.dart';
export 'features/quran/presentation/widgets/word_info/word_info_bottom_sheet.dart';

export 'features/quran/ui/pages/get_single_ayah/get_single_ayah.dart';
export 'features/quran/ui/pages/quran_library_screen/quran_library_screen.dart';
export 'features/quran/ui/pages/quran_pages_screen/quran_pages_screen.dart';
export 'features/quran/ui/pages/surah_display_screen/surah_display_screen.dart';
export 'features/quran/flutter_quran_utils.dart';

// Features - Bookmarks
export 'features/bookmarks/data/models/bookmark_model.dart';
export 'features/bookmarks/logic/bookmarks_cubit.dart';
export 'features/bookmarks/logic/bookmarks_state.dart';

// Features - Audio
export 'features/audio/audio.dart';

// Features - Tafsir
export 'features/tafsir/tafsir.dart';
export 'features/tafsir/logic/tajweed_aya_cubit.dart';
export 'features/tafsir/logic/tajweed_aya_state.dart';
