import 'dart:io';

import 'package:chessroad/routes/battle-page.dart';
import 'package:chessroad/routes/main-menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(ChessRoadApp());

  // allow vertical screen only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // hidden system status bar
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
  }
  SystemChrome.setEnabledSystemUIOverlays([]);
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
