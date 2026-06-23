import 'package:example/core/widgets/full_quran.dart';
import 'package:flutter/material.dart';

class quranApp extends StatefulWidget {
  const quranApp({super.key});

  @override
  State<quranApp> createState() => _quranAppState();
}

class _quranAppState extends State<quranApp> {
  @override
  Widget build(BuildContext context) {
    const TextScaler fixedScaler = TextScaler.linear(1.0);
    return MaterialApp(
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
      home: const Scaffold(
        body: FullQuran(),
      ),
    );
  }
}
