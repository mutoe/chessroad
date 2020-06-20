import 'package:chessroad/board/board-widget.dart';
import 'package:chessroad/chess/chess-base.dart';
import 'package:chessroad/game/battle.dart';
import 'package:flutter/material.dart';

class BattlePage extends StatefulWidget {
  static const BoardMarginVertical = 10.0;
  static const BoardMarginHorizontal = 10.0;

  @override
  _BattlePageState createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage> {
  @override
  void initState() {
    super.initState();
    Battle.shared.init();
  }

  onBoardTap(BuildContext context, int position) {
    final phase = Battle.shared.phase;
    if (phase.side != Side.Red) return;

    final tapedPiece = phase.pieceAt(position);
    if (Battle.shared.focusIndex != -1 &&
        Side.of(phase.pieceAt(Battle.shared.focusIndex)) == Side.Red) {
      if (Battle.shared.focusIndex == position) return;

      final focusPiece = phase.pieceAt(Battle.shared.focusIndex);
      if (Side.sameSide(focusPiece, tapedPiece)) {
        Battle.shared.select(position);
      } else if (Battle.shared.move(Battle.shared.focusIndex, position)) {
        // TODO
      }
    } else {
      if (tapedPiece != Piece.Empty) Battle.shared.select(position);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final windowSize = MediaQuery.of(context).size;
    final boardHeight = windowSize.width - BattlePage.BoardMarginHorizontal * 2;

    return Scaffold(
      appBar: AppBar(title: Text('Battle')),
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: BattlePage.BoardMarginHorizontal,
          vertical: BattlePage.BoardMarginVertical,
        ),
        child: BoardWidget(width: boardHeight, onBoardTap: onBoardTap),
      ),
    );
  }
}
