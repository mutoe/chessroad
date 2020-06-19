import 'package:chessroad/routes/battle-page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ChessRoadApp());
}

class ChessRoadApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.brown),
      debugShowCheckedModeBanner: false,
      home: BattlePage(),
    );
  }
}
