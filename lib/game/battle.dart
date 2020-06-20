import 'package:chessroad/chess/chess-base.dart';
import 'package:chessroad/chess/phase.dart';

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

  String toString() {
    return 'Battle: {focusIndex: $_focusIndex, blurIndex: $_blurIndex}';
  }

  BattleResult scanBattleResult() {
    // TODO
    return BattleResult.Pending;
  }

  select(int position) {
    _focusIndex = position;
    _blurIndex = Move.InvalidIndex;
  }

  move(int from, int to) {
    if (!_phase.move(from, to)) return false;

    _blurIndex = from;
    _focusIndex = to;

    return true;
  }

  clear() {
    _blurIndex = _focusIndex = Move.InvalidIndex;
  }
}
