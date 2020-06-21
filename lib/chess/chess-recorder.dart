import 'package:chessroad/chess/chess-base.dart';
import 'package:chessroad/chess/phase.dart';

class ChessRecorder {
  int halfMove, fullMove;
  String lastCapturedPhase;
  final _history = <Move>[];

  ChessRecorder({
    this.halfMove = 0,
    this.fullMove = 0,
    this.lastCapturedPhase,
  });

  ChessRecorder.fromCounterMarks(String marks) {
    var segments = marks.split(' ');
    if (segments.length != 2) {
      throw 'Error: Invalid Counter Marks: $marks';
    }

    halfMove = int.parse(segments[0]);
    fullMove = int.parse(segments[1]);

    if (halfMove == null || fullMove == null) {
      throw 'Error: Invalid Counter Marks: $marks';
    }
  }

  Move get last => _history.isEmpty ? null : _history.last;

  get stepsCounter => _history.length;

  stepAt(int index) => _history[index];

  @override
  String toString() {
    return '$halfMove $fullMove';
  }

  void stepIn(Move move, Phase phase) {
    if (move.captured != Piece.Empty) {
      halfMove = 0;
    } else {
      halfMove++;
    }

    if (fullMove == 0 || phase.side != Side.Black) {
      fullMove++;
    }

    _history.add(move);

    if (move.captured != Piece.Empty) {
      lastCapturedPhase = phase.toFen();
    }
  }

  Move removeLast() {
    if (_history.isEmpty) return null;
    return _history.removeLast();
  }

  List<Move> reverseMovesToPreviousCapture() {
    List<Move> moves = [];

    for (var i = _history.length - 1; i >= 0; i--) {
      if (_history[i].captured != Piece.Empty) break;
      moves.add(_history[i]);
    }

    return moves;
  }

  String buildManualText({columns = 2}) {
    var manualText = '';
    for (var i = 0; i < _history.length; i++) {
      manualText += '${i < 9 ? ' ' : ''}${i + 1}. ${_history[i].stepName} ';
      if ((i + 1) % columns == 0) manualText += '\n';
    }

    if (manualText.isEmpty) {
      manualText = '<暂无招法>';
    }

    return manualText;
  }
}
