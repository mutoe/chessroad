import 'package:chessroad/board/board-widget.dart';
import 'package:flutter/material.dart';

class BattlePage extends StatelessWidget {
  static const BoardMarginVertical = 10.0;
  static const BoardMarginHorizontal = 10.0;

  @override
  Widget build(BuildContext context) {
    final windowSize = MediaQuery.of(context).size;
    final boardHeight = windowSize.width - BoardMarginHorizontal * 2;

    return Scaffold(
      appBar: AppBar(title: Text('Battle')),
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: BoardMarginHorizontal,
          vertical: BoardMarginVertical,
        ),
        child: BoardWidget(width: boardHeight),
      ),
    );
  }
}
