import 'dart:math';

import 'package:chessroad/board/board-widget.dart';
import 'package:chessroad/common/color-constants.dart';
import 'package:flutter/material.dart';

class BoardPainter extends CustomPainter {
  final double width;
  final double gridWidth;
  final double squareSide;
  final thePaint = Paint();

  BoardPainter({@required this.width})
      : gridWidth = (width - BoardWidget.Padding * 2) * 8 / 9,
        squareSide = (width - BoardWidget.Padding * 2) / 9;

  static doPaint(
    Canvas canvas,
    Paint paint,
    double gridWidth,
    double squareSide, {
    double offsetX,
    double offsetY,
  }) {
    paint.color = ColorConstants.BoardLine;
    paint.style = PaintingStyle.stroke;

    var left = offsetX;
    var top = offsetY;

    // outer border
    paint.strokeWidth = 2;
    canvas.drawRect(Rect.fromLTWH(left, top, gridWidth, squareSide * 9), paint);

    // center axis
    paint.strokeWidth = 1;
    canvas.drawLine(
      Offset(left + gridWidth / 2, top),
      Offset(
        left + gridWidth / 2,
        top + squareSide * 9,
      ),
      paint,
    );

    // 8x horizontal line
    for (var i = 0; i < 9; ++i) {
      canvas.drawLine(
        Offset(left, top + squareSide * i),
        Offset(left + gridWidth, top + squareSide * i),
        paint,
      );
    }

    // 6x short vertical line
    for (var i = 0; i < 8; ++i) {
      if (i == 4) continue;

      canvas.drawLine(
        Offset(left + squareSide * i, top),
        Offset(left + squareSide * i, top + squareSide * 4),
        paint,
      );
      canvas.drawLine(
        Offset(left + squareSide * i, top + squareSide * 5),
        Offset(left + squareSide * i, top + squareSide * 9),
        paint,
      );
    }

    // 4x slash in the nine-block
    canvas.drawLine(
      Offset(left + squareSide * 3, top),
      Offset(left + squareSide * 5, top + squareSide * 2),
      paint,
    );
    canvas.drawLine(
      Offset(left + squareSide * 5, top),
      Offset(left + squareSide * 3, top + squareSide * 2),
      paint,
    );
    canvas.drawLine(
      Offset(left + squareSide * 3, top + squareSide * 7),
      Offset(left + squareSide * 5, top + squareSide * 9),
      paint,
    );
    canvas.drawLine(
      Offset(left + squareSide * 5, top + squareSide * 7),
      Offset(left + squareSide * 3, top + squareSide * 9),
      paint,
    );

    // cannon / batman position
    final List<Offset> positions = [
      // cannon position
      Offset(left + squareSide * 1, top + squareSide * 2),
      Offset(left + squareSide * 7, top + squareSide * 2),
      Offset(left + squareSide * 1, top + squareSide * 7),
      Offset(left + squareSide * 7, top + squareSide * 7),
      // batman position
      Offset(left + squareSide * 2, top + squareSide * 3),
      Offset(left + squareSide * 4, top + squareSide * 3),
      Offset(left + squareSide * 6, top + squareSide * 3),
      Offset(left + squareSide * 2, top + squareSide * 6),
      Offset(left + squareSide * 4, top + squareSide * 6),
      Offset(left + squareSide * 6, top + squareSide * 6),
    ];
    positions.forEach((pos) => canvas.drawCircle(pos, 5, paint));
    final List<Offset> leftPositions = [
      Offset(left, top + squareSide * 3),
      Offset(left, top + squareSide * 6),
    ];
    final List<Offset> rightPositions = [
      Offset(left + squareSide * 8, top + squareSide * 3),
      Offset(left + squareSide * 8, top + squareSide * 6),
    ];
    leftPositions.forEach((pos) {
      var rect = Rect.fromCenter(center: pos, width: 10, height: 10);
      canvas.drawArc(rect, -pi / 2, pi, true, paint);
    });
    rightPositions.forEach((pos) {
      var rect = Rect.fromCenter(center: pos, width: 10, height: 10);
      canvas.drawArc(rect, pi / 2, pi, true, paint);
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    doPaint(
      canvas,
      thePaint,
      gridWidth,
      squareSide,
      offsetX: BoardWidget.Padding + squareSide / 2,
      offsetY: BoardWidget.Padding + BoardWidget.DigitsHeight + squareSide / 2,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
