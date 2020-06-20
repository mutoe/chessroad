import 'package:chessroad/routes/battle-page.dart';
import 'package:chessroad/routes/main-menu.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ChessRoadApp());
}

class ChessRoadApp extends StatelessWidget {
  static const StatusBarHeight = 28.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.brown,
        fontFamily: 'QiTi',
      ),
      debugShowCheckedModeBanner: false,
      home: MainMenu(),
    );
  }
}
