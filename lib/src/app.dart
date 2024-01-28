import 'package:flutter/material.dart';

import 'game/game.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Flame PingPong',
      home: GameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
