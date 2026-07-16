import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/dependancy_injection/di.dart';
import '../core/routing/app_router.dart';
import '../core/routing/route_names.dart';
import '../core/services/internet_connection_cubit.dart';
import '../features/bookmarks/logic/bookmarks_cubit.dart';
import '../features/tafsir/logic/tajweed_aya_cubit.dart';

class QuranApp extends StatelessWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    const TextScaler fixedScaler = TextScaler.linear(1.0);
    return MultiBlocProvider(
      providers: [
        BlocProvider<InternetConnectionCubit>(
          create: (_) => getIt<InternetConnectionCubit>(),
        ),
        BlocProvider<BookmarksCubit>(
          create: (_) => getIt<BookmarksCubit>()..initBookmarks(),
        ),
        BlocProvider<TajweedAyaCubit>(
          create: (_) => getIt<TajweedAyaCubit>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(
            primary: Colors.teal,
          ),
          primaryColor: Colors.teal,
          useMaterial3: false,
        ),
        builder: (context, child) {
          final mq = MediaQuery.of(context);
          return MediaQuery(
            data: mq.copyWith(textScaler: fixedScaler),
            child: child!,
          );
        },
        initialRoute: RouteNames.initial,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
