import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/game/presentation/pages/game_page.dart';

void main() {
  runApp(const ProviderScope(child: PointsMasterApp()));
}

class PointsMasterApp extends StatelessWidget {
  const PointsMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Points Master',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const GamePage(gameId: "test_game"), // Temp entry point for dev
    );
  }
}
