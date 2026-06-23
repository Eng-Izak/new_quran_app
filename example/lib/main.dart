import 'package:example/app/quran_app.dart';
import 'package:flutter/material.dart';

import 'package:quran_library/quran_library.dart';

Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await QuranLibrary.init();
  QuranLibrary.initWordAudio();
  runApp(
    const quranApp(),
  );
}
