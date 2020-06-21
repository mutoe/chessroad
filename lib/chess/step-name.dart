import 'package:chessroad/chess/chess-base.dart';
import 'package:chessroad/chess/phase.dart';
import 'package:chessroad/common/math-ext.dart';

class StepName {
  static const RedColumnNames = '九八七六五四三二一';
  static const BlackColumnNames = '１２３４５６７８９';

  static const RedDigits = '零一二三四五六七八九';
  static const BlackDigits = '０１２３４５６７８９';

  StepName();

  static translate(Phase phase, Move step) {
    final columnNames = [RedColumnNames, BlackColumnNames];
    final digits = [RedDigits, BlackDigits];

    final side = Side.of(phase.pieceAt(step.from));
    final sideIndex = (side == Side.Red) ? 0 : 1;

    final chessName = nameOf(phase, step);
    String result = chessName;

    if (step.ty == step.fy) {
      result += '平${columnNames[sideIndex][step.tx]}';
    } else {
      final direction = (side == Side.Red) ? -1 : 1;
      final dir = ((step.ty - step.fy) * direction > 0) ? '进' : '退';
      final piece = phase.pieceAt(step.from);
      final specialPieces = [
        Piece.RedKnight,
        Piece.BlackKnight,
        Piece.RedBishop,
        Piece.BlackBishop,
        Piece.RedAdviser,
        Piece.BlackAdviser,
      ];

      String targetPosition;
      if (specialPieces.contains(piece)) {
        targetPosition = '${columnNames[sideIndex][step.tx]}';
      } else {
        targetPosition = '${digits[sideIndex][abs(step.ty - step.fy)]}';
      }
      result += '$dir$targetPosition';
    }
    return step.stepName = result;
  }

  static nameOf(Phase phase, Move step) {
    final columnNames = [RedColumnNames, BlackColumnNames];
    final digits = [RedDigits, BlackDigits];

    final side = Side.of(phase.pieceAt(step.from));
    final sideIndex = (side == Side.Red) ? 0 : 1;

    final piece = phase.pieceAt(step.from);
    final chessName = Piece.Names[piece];

    if ([
      Piece.RedAdviser,
      Piece.RedBishop,
      Piece.BlackAdviser,
      Piece.BlackBishop
    ].contains(piece)) {
      return '$chessName${columnNames[sideIndex][step.fx]}';
    }

    final Map<int, List<int>> columns = findPieceSameColumn(phase, piece);
    final fyIndexes = columns[step.fx];
    if (fyIndexes == null) {
      return '$chessName${columnNames[sideIndex][step.fx]}';
    }

    if (columns.length == 1) {
      var order = fyIndexes.indexOf(step.fy);
      if (side == Side.Black) order = fyIndexes.length - 1 - order;
      if (fyIndexes.length == 2) {
        return '${'前后'[order]}$chessName';
      }
      if (fyIndexes.length == 3) {
        return '${'前中后'[order]}$chessName';
      }
      return '${digits[sideIndex][order]}$chessName';
    }

    if (columns.length == 2) {
      final fxIndexes = columns.keys.toList();
      fxIndexes.sort((a, b) => a - b);
      final currentColumnStart = (step.fx == fxIndexes[1 - sideIndex]);
      if (currentColumnStart) {
        var order = fyIndexes.indexOf(step.fy);
        if (side == Side.Black) order = fyIndexes.length - 1 - order;
        return '${digits[sideIndex][order]}$chessName';
      } else {
        final fxOtherCol = fxIndexes[sideIndex];
        var order = fyIndexes.indexOf(step.fy);
        if (side == Side.Black) order = fyIndexes.length - 1 - order;
        return '${digits[sideIndex][columns[fxOtherCol].length + order]}$chessName';
      }
    }
    return '错误招法';
  }

  static Map<int, List<int>> findPieceSameColumn(Phase phase, String piece) {
    final map = Map<int, List<int>>();

    for (var row = 0; row < 10; row++) {
      for (var col = 0; col < 9; col++) {
        if (phase.pieceAt(row * 9 + col) == piece) {
          var fyIndexes = map[col] ?? [];
          fyIndexes.add(row);
          map[col] = fyIndexes;
        }
      }
    }

    final Map<int, List<int>> result = {};
    map.forEach((key, value) {
      if (value.length > 1) result[key] = value;
    });
    return result;
  }
}
