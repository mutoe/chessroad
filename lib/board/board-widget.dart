import 'package:chessroad/board/board-painter.dart';
import 'package:chessroad/board/pieces-painter.dart';
import 'package:chessroad/board/words-on-board.dart';
import 'package:chessroad/chess/phase.dart';
import 'package:chessroad/common/color-constants.dart';
import 'package:flutter/material.dart';

class BoardWidget extends StatelessWidget {
  static const Padding = 5.0;
  static const DigitsHeight = 36.0;

  final double width, height;

  BoardWidget({@required this.width})
      : height = (width - Padding * 2) / 9 * 10 + (Padding + DigitsHeight) * 2;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          phase: Phase.defaultPhase(),
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
  }
}
