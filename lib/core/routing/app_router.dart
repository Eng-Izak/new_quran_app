import 'package:flutter/material.dart';
import '../../features/quran/ui/pages/quran_library_screen/quran_library_screen.dart';
import 'route_names.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.initial:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: QuranLibraryScreen(
              parentContext: context,
            ),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
