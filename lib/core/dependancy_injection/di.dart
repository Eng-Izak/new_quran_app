import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import '../../features/bookmarks/logic/bookmarks_cubit.dart';
import '../../features/quran/data/repositories/quran_repository.dart';
import '../../features/tafsir/data/repositories/tajweed_aya_repository.dart';
import '../../features/tafsir/logic/tajweed_aya_cubit.dart';
import '../services/connectivity_service.dart';
import '../services/gzip_json_asset_service.dart';
import '../services/internet_connection_cubit.dart';
import 'package:get/get.dart';
import '../../features/quran/presentation/controllers/quran/quran_ctrl.dart';
import '../../features/quran/presentation/controllers/auto_scroll/auto_scroll_ctrl.dart';
import '../../features/tafsir/controller/tafsir_ctrl.dart';
import '../../features/quran/presentation/controllers/bookmark/bookmarks_ctrl.dart';
import '../../features/quran/presentation/controllers/word_info/word_info_ctrl.dart';
import '../../features/quran/presentation/controllers/surah/surah_ctrl.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../utils/assets_path.dart';

final getIt = GetIt.instance;
final sl = getIt;

Future<void> setupDependencyInjection() async {
  // Detect if we should use package-prefixed asset paths or local paths
  try {
    await rootBundle.load('packages/quran_library/assets/svg/playArrow.svg');
    AssetsPath.usePackagePrefix = true;
  } catch (_) {
    AssetsPath.usePackagePrefix = false;
  }

  // Storage
  await GetStorage.init();
  getIt.registerLazySingleton<GetStorage>(() => GetStorage());

  // GetX Controllers / Services
  Get.put(QuranCtrl(quranRepository: QuranRepository(gzipJsonAssetService: const GzipJsonAssetService())));
  Get.lazyPut(() => AutoScrollCtrl(), fenix: true);
  TafsirCtrl.instance;
  BookmarksCtrl.instance;
  WordInfoCtrl.instance;
  SurahCtrl.instance;


  // Services
  final connectivityService = InternetConnectionService();
  await connectivityService.init();
  getIt.registerSingleton<InternetConnectionService>(connectivityService);

  getIt.registerLazySingleton<GzipJsonAssetService>(
    () => const GzipJsonAssetService(),
  );

  // Repositories
  getIt.registerLazySingleton<QuranRepository>(
    () => QuranRepository(gzipJsonAssetService: getIt<GzipJsonAssetService>()),
  );

  getIt.registerLazySingleton<TajweedAyaRepository>(
    () => TajweedAyaRepository(),
  );

  // Cubits / Blocs (Global)
  getIt.registerLazySingleton<InternetConnectionCubit>(
    () => InternetConnectionCubit(getIt<InternetConnectionService>()),
  );

  getIt.registerLazySingleton<BookmarksCubit>(
    () => BookmarksCubit(getIt<QuranRepository>()),
  );

  getIt.registerLazySingleton<TajweedAyaCubit>(
    () => TajweedAyaCubit(getIt<TajweedAyaRepository>()),
  );
}
