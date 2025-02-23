import 'dart:async';
import 'package:bubbles/pages/pick_interests.dart';
import 'package:flutter/material.dart';

sealed class App {
  const App._();

  static Future<void> startup() async {
    await runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();

        runApp(const MyApp());
      },
      (error, stack) {
        debugPrint('Error: $error');
        debugPrint('Stack trace: $stack');
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bubbles',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const PickInterests(),
    );
  }
}
