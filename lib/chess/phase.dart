import 'package:chessroad/chess/chess-recorder.dart';
import 'package:chessroad/chess/steps-validate.dart';

import 'chess-base.dart';

class Phase {
  BattleResult result = BattleResult.Pending;
  String _side;
  List<String> _pieces;
  ChessRecorder _recorder;

  get halfMove => _recorder.halfMove;

  get fullMove => _recorder.fullMove;

  Move get lastMove => _recorder.last;

  get lastCapturedPhase => _recorder.lastCapturedPhase;

  String get side => _side;

  turnSide() => _side = Side.exchange(_side);

  String pieceAt(int index) => _pieces[index];

  String move(int from, int to) {
    if (!validateMove(from, to)) return null;
    final captured = _pieces[to];

    _pieces[to] = _pieces[from];
    _pieces[from] = Piece.Empty;

    _recorder.stepIn(Move(from, to, captured: captured), this);

    _side = Side.exchange(_side);

    return captured;
  }

  bool validateMove(int from, int to) {
    if (Side.of(_pieces[from]) != _side) return false;
    return StepValidate.validate(this, Move(from, to));
  }

  String toFen() {
    String fen = '';
    for (var row = 0; row < 10; row++) {
      var emptyCounter = 0;
      for (var column = 0; column < 9; column++) {
        final piece = pieceAt(row * 9 + column);
        if (piece == Piece.Empty) {
          emptyCounter++;
        } else {
          if (emptyCounter > 0) {
            fen += emptyCounter.toString();
            emptyCounter = 0;
          }
          fen += piece;
        }
      }

      if (emptyCounter > 0) fen += emptyCounter.toString();
      if (row < 9) fen += '/';
    }
    fen += ' $side';
    fen += ' - - ';
    fen += '${_recorder?.halfMove ?? 0} ${_recorder?.fullMove ?? 0}';
    return fen;
  }

  Phase.defaultPhase() {
    initDefaultPhase();
  }

  void initDefaultPhase() {
    _side = Side.Red;
    _pieces = List<String>(90);

    _pieces[0 * 9 + 0] = Piece.BlackRook;
    _pieces[0 * 9 + 1] = Piece.BlackKnight;
    _pieces[0 * 9 + 2] = Piece.BlackBishop;
    _pieces[0 * 9 + 3] = Piece.BlackAdviser;
    _pieces[0 * 9 + 4] = Piece.BlackKing;
    _pieces[0 * 9 + 5] = Piece.BlackAdviser;
    _pieces[0 * 9 + 6] = Piece.BlackBishop;
    _pieces[0 * 9 + 7] = Piece.BlackKnight;
    _pieces[0 * 9 + 8] = Piece.BlackRook;

    _pieces[2 * 9 + 1] = Piece.BlackCannon;
    _pieces[2 * 9 + 7] = Piece.BlackCannon;

    _pieces[3 * 9 + 0] = Piece.BlackPawn;
    _pieces[3 * 9 + 2] = Piece.BlackPawn;
    _pieces[3 * 9 + 4] = Piece.BlackPawn;
    _pieces[3 * 9 + 6] = Piece.BlackPawn;
    _pieces[3 * 9 + 8] = Piece.BlackPawn;

    _pieces[9 * 9 + 0] = Piece.RedRook;
    _pieces[9 * 9 + 1] = Piece.RedKnight;
    _pieces[9 * 9 + 2] = Piece.RedBishop;
    _pieces[9 * 9 + 3] = Piece.RedAdviser;
    _pieces[9 * 9 + 4] = Piece.RedKing;
    _pieces[9 * 9 + 5] = Piece.RedAdviser;
    _pieces[9 * 9 + 6] = Piece.RedBishop;
    _pieces[9 * 9 + 7] = Piece.RedKnight;
    _pieces[9 * 9 + 8] = Piece.RedRook;

    _pieces[7 * 9 + 1] = Piece.RedCannon;
    _pieces[7 * 9 + 7] = Piece.RedCannon;

    _pieces[6 * 9 + 0] = Piece.RedPawn;
    _pieces[6 * 9 + 2] = Piece.RedPawn;
    _pieces[6 * 9 + 4] = Piece.RedPawn;
    _pieces[6 * 9 + 6] = Piece.RedPawn;
    _pieces[6 * 9 + 8] = Piece.RedPawn;

    for (var i = 0; i < 90; i++) {
      _pieces[i] ??= Piece.Empty;
    }

    _recorder = ChessRecorder(lastCapturedPhase: toFen());
  }

  Phase.clone(Phase other) {
    _pieces = List<String>();
    other._pieces.forEach((piece) => _pieces.add(piece));
    _side = other._side;
    _recorder = other._recorder;
  }

  void moveTest(Move move, {turnSide = false}) {
    _pieces[move.to] = _pieces[move.from];
    _pieces[move.from] = Piece.Empty;
    if (turnSide) _side = Side.exchange(_side);
  }

  String movesSinceLastCaptured() {
    var steps = '';
    var positionAfterLastCaptured = 0;

    for (var i = _recorder.stepsCounter - 1; i >= 0; i--) {
      if (_recorder.stepAt(i).captured != Piece.Empty) break;
      positionAfterLastCaptured = i;
    }

    for (var i = positionAfterLastCaptured; i < _recorder.stepsCounter; i++) {
      steps += ' ${_recorder.stepAt(i).step}';
    }

    return steps.length > 0 ? steps.substring(1) : '';
  }

  bool regret() {
    final lastMove = _recorder.removeLast();
    if (lastMove == null) return false;

    _pieces[lastMove.from] = _pieces[lastMove.to];
    _pieces[lastMove.to] = lastMove.captured;

    _side = Side.exchange(_side);

    final counterMarks = ChessRecorder.fromCounterMarks(lastMove.counterMarks);
    _recorder.halfMove = counterMarks.halfMove;
    _recorder.fullMove = counterMarks.fullMove;

    if (lastMove.captured != Piece.Empty) {
      final tempPhase = Phase.clone(this);
      final moves = _recorder.reverseMovesToPreviousCapture();
      moves.forEach((move) {
        tempPhase._pieces[move.from] = tempPhase._pieces[move.to];
        tempPhase._pieces[move.to] = move.captured;

        tempPhase._side = Side.exchange(_side);
      });

      _recorder.lastCapturedPhase = tempPhase.toFen();
    }

    result = BattleResult.Pending;

    return true;
  }
}
