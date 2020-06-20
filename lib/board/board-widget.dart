import 'package:chessroad/board/board-painter.dart';
import 'package:chessroad/board/pieces-painter.dart';
import 'package:chessroad/board/words-on-board.dart';
import 'package:chessroad/common/color-constants.dart';
import 'package:chessroad/game/battle.dart';
import 'package:flutter/material.dart';

class BoardWidget extends StatelessWidget {
  static const Padding = 5.0;
  static const DigitsHeight = 36.0;

  final double width, height;
  final Function(BuildContext, int) onBoardTap;

  BoardWidget({
    @required this.width,
    @required this.onBoardTap,
  }) : height = (width - Padding * 2) / 9 * 10 + (Padding + DigitsHeight) * 2;

  @override
  Widget build(BuildContext context) {
    final boardContainer = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: ColorConstants.BoardBackground,
      ),
      child: CustomPaint(
        painter: BoardPainter(width: width),
        foregroundPainter: PiecesPainter(
          width: width,
          phase: Battle.shared.phase,
          focusIndex: Battle.shared.focusIndex,
          blurIndex: Battle.shared.blurIndex,
        ),
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: Padding,
            horizontal: (width - Padding * 2) / 9 / 2 +
                Padding -
                WordsOnBoard.DigitsFontSize / 2,
          ),
          child: WordsOnBoard(),
        ),
      ),
    );

    return GestureDetector(
      child: boardContainer,
      onTapUp: (d) {
        final gridWidth = (width - Padding * 2) * 8 / 9;
        final squareSide = gridWidth / 8;

        final dx = d.localPosition.dx;
        final dy = d.localPosition.dy;

        final row = (dy - Padding - DigitsHeight) ~/ squareSide;
        final column = (dx - Padding) ~/ squareSide;

        if (row < 0 || row > 9) return;
        if (column < 0 || column > 8) return;

        onBoardTap(context, row * 9 + column);
      },
    );
  }
}
