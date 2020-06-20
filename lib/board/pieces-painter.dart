import 'package:chessroad/board/board-widget.dart';
import 'package:chessroad/board/painter-base.dart';
import 'package:chessroad/chess/chess-base.dart';
import 'package:chessroad/chess/phase.dart';
import 'package:chessroad/common/color-constants.dart';
import 'package:flutter/material.dart';

class PiecesPainter extends PainterBase {
  final Phase phase;
  final int focusIndex, blurIndex;
  double pieceSide;

  PiecesPainter({
    @required double width,
    @required this.phase,
    this.focusIndex = -1,
    this.blurIndex = -1,
  }) : super(width: width) {
    pieceSide = squareSide * .9;
  }

  @override
  void paint(Canvas canvas, Size size) {
    doPaint(
      canvas,
      thePaint,
      phase: phase,
      gridWidth: gridWidth,
      squareSide: squareSide,
      pieceSide: pieceSide,
      offsetX: BoardWidget.Padding + squareSide / 2,
      offsetY: BoardWidget.Padding + BoardWidget.DigitsHeight + squareSide / 2,
      focusIndex: focusIndex,
      blurIndex: blurIndex,
    );
  }

  static doPaint(
    Canvas canvas,
    Paint paint, {
    Phase phase,
    double gridWidth,
    double squareSide,
    double pieceSide,
    double offsetX,
    double offsetY,
    int focusIndex = -1,
    int blurIndex = -1,
  }) {
    final left = offsetX;
    final top = offsetY;
    final shadowPath = Path();
    final List<PiecePaintStub> piecesToDraw = [];

    for (var row = 0; row < 10; row++) {
      for (var column = 0; column < 9; column++) {
        final piece = phase.pieceAt(row * 9 + column);
        if (piece == Piece.Empty) continue;

        var position = Offset(
          left + squareSide * column,
          top + squareSide * row,
        );
        piecesToDraw.add(PiecePaintStub(piece: piece, position: position));

        shadowPath.addOval(Rect.fromCenter(
            center: position, width: pieceSide, height: pieceSide));
      }
    }

    canvas.drawShadow(shadowPath, Colors.black, 2, true);

    final textStyle = TextStyle(
      color: ColorConstants.PieceTextColor,
      fontSize: pieceSide * 0.8,
      fontFamily: 'QiTi',
      height: 1.0,
    );

    piecesToDraw.forEach((piecePaintStub) {
      paint.style = PaintingStyle.fill;
      paint.color = Piece.isRed(piecePaintStub.piece)
          ? ColorConstants.RedPieceBorderColor
          : ColorConstants.BlackPieceBorderColor;
      canvas.drawCircle(piecePaintStub.position, pieceSide / 2, paint);

      paint.color = Piece.isRed(piecePaintStub.piece)
          ? ColorConstants.RedPieceColor
          : ColorConstants.BlackPieceColor;
      canvas.drawCircle(piecePaintStub.position, pieceSide * 0.8 / 2, paint);

      final textSpan = TextSpan(
        text: Piece.Names[piecePaintStub.piece],
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )
        ..layout();
      final metric = textPainter.computeLineMetrics()[0];
      final textSize = textPainter.size;
      final textOffset = piecePaintStub.position -
          Offset(textSize.width / 2, metric.baseline - textSize.height / 3);
      textPainter.paint(canvas, textOffset);

      // focus and blur effect
      if (focusIndex != -1) {
        final int row = focusIndex ~/ 9;
        final int column = focusIndex % 9;

        paint.color = ColorConstants.FocusPosition;
        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = 2;

        canvas.drawCircle(
          Offset(left + squareSide * column, top + squareSide * row),
          pieceSide / 2,
          paint,
        );
      }
      if (blurIndex != -1) {
        final int row = blurIndex ~/ 9;
        final int column = blurIndex % 9;

        paint.color = ColorConstants.BlurPosition;
        paint.style = PaintingStyle.fill;

        canvas.drawCircle(
          Offset(left + squareSide * column, top + squareSide * row),
          pieceSide / 2 * 0.8,
          paint,
        );
      }
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class PiecePaintStub {
  final String piece;
  final Offset position;

  PiecePaintStub({this.piece, this.position});
}
