import 'package:chessroad/chess/chess-base.dart';
import 'package:chessroad/chess/phase.dart';
import 'package:chessroad/chess/steps-enum.dart';
import 'package:chessroad/chess/steps-validate.dart';

class ChessRules {
  static checked(Phase phase) {
    final myKingPosition = findKingPosition(phase);
    final exchangePhase = Phase.clone(phase);
    exchangePhase.turnSide();

    final exchangeSteps = StepsEnumerator.enumSteps(exchangePhase);
    for (var step in exchangeSteps) {
      if (step.to == myKingPosition) return true;
    }
    return false;
  }

  static findKingPosition(Phase phase) {
    for (var i = 0; i < 90; i++) {
      final piece = phase.pieceAt(i);
      if (piece == Piece.RedKing || piece == Piece.BlackKing) {
        if (phase.side == Side.of(piece)) return i;
      }
    }
    return -1;
  }

  static willBeChecked(Phase phase, Move move) {
    final tempPhase = Phase.clone(phase);
    tempPhase.moveTest(move);
    return checked(tempPhase);
  }

  static willKingsMeeting(Phase phase, Move move) {
    final tempPhase = Phase.clone(phase);
    tempPhase.moveTest(move);
    for (var col = 3; col < 6; col++) {
      var foundKingAlready = false;
      for (var row = 0; row < 10; row++) {
        final piece = tempPhase.pieceAt(row * 9 + col);
        if (!foundKingAlready) {
        } else {
          if (piece == Piece.RedKing || piece == Piece.BlackKing) return true;
          if (piece != Piece.Empty) break;
        }
      }
    }
    return false;
  }

  static bool beKilled(Phase phase) {
    List<Move> steps = StepsEnumerator.enumSteps(phase);
    for (var step in steps) {
      if (StepValidate.validate(phase, step)) return false;
    }
    return true;
  }
}
