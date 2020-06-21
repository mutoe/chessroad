import 'package:chessroad/chess/chess-base.dart';
import 'package:chessroad/chess/chess-rules.dart';
import 'package:chessroad/chess/phase.dart';
import 'package:chessroad/services/audios.dart';

class Battle {
  static Battle _instance;

  Phase _phase;
  int _focusIndex;
  int _blurIndex;

  static Battle get shared {
    _instance ??= Battle();
    return _instance;
  }

  Phase get phase => _phase;

  int get focusIndex => _focusIndex;

  int get blurIndex => _blurIndex;

  init() {
    _phase = Phase.defaultPhase();
    _focusIndex = _blurIndex = Move.InvalidIndex;
  }

  newGame() {
    Battle.shared.phase.initDefaultPhase();
    _focusIndex = _blurIndex = Move.InvalidIndex;
  }

  String toString() {
    return 'Battle: {focusIndex: $_focusIndex, blurIndex: $_blurIndex}';
  }

  BattleResult scanBattleResult() {
    final forPerson = (_phase.side == Side.Red);
    if (scanLongCatch()) {
      return forPerson ? BattleResult.Win : BattleResult.Lose;
    }
    if (ChessRules.beKilled(_phase)) {
      return forPerson ? BattleResult.Lose : BattleResult.Win;
    }
    return _phase.halfMove > 120 ? BattleResult.Draw : BattleResult.Pending;
  }

  bool scanLongCatch() {
    // TODO
    return false;
  }

  select(int position) {
    _focusIndex = position;
    _blurIndex = Move.InvalidIndex;
    Audios.playTone('click.mp3');
  }

  move(int from, int to) {
    final captured = _phase.move(from, to);
    if (captured == null) {
      Audios.playTone('invalid.mp3');
      return false;
    }

    _blurIndex = from;
    _focusIndex = to;

    if (ChessRules.checked(_phase)) {
      Audios.playTone('check.mp3');
    } else {
      Audios.playTone(captured != Piece.Empty ? 'capture.mp3' : 'move.mp3');
    }

    return true;
  }

  clear() {
    _blurIndex = _focusIndex = Move.InvalidIndex;
  }
}
