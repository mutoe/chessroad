import 'dart:io';

import 'package:chessroad/routes/main-menu.dart';
import 'package:chessroad/services/audios.dart';
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

class ChessRoadApp extends StatefulWidget {
  static const StatusBarHeight = 28.0;

  @override
  _ChessRoadAppState createState() => _ChessRoadAppState();
}

class _ChessRoadAppState extends State<ChessRoadApp> {
  @override
  void initState() {
    super.initState();
    Audios.loopBgm('bg_music.mp3');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.brown,
        fontFamily: 'QiTi',
      ),
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async {
          Audios.release();
          return true;
        },
        child: MainMenu(),
      ),
    );
  }
}
