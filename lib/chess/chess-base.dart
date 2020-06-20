class Side {
  static const Unknown = '-';
  static const Red = 'w';
  static const Black = 'b';

  static String of(String piece) {
    // 'RNBAKCP' means that '车马象仕将炮兵', lowercase means Black
    if ('RNBAKCP'.contains(piece)) return Red;
    if ('rnbakcp'.contains(piece)) return Black;
    return Unknown;
  }

  static bool sameSide(String p1, String p2) {
    return of(p1) == of(p2);
  }

  static String exchange(String side) {
    if (side == Red) return Black;
    if (side == Black) return Red;
    return side;
  }
}

class Piece {
  static const Empty = '';

  static const RedRook = 'R';
  static const RedKnight = 'N';
  static const RedBishop = 'B';
  static const RedAdviser = 'A';
  static const RedKing = 'K';
  static const RedCannon = 'C';
  static const RedPawn = 'P';
  static const BlackRook = 'r';
  static const BlackKnight = 'n';
  static const BlackBishop = 'b';
  static const BlackAdviser = 'a';
  static const BlackKing = 'k';
  static const BlackCannon = 'c';
  static const BlackPawn = 'p';

  static const Names = {
    Empty: '',
    RedRook: '车',
    RedKnight: '马',
    RedBishop: '相',
    RedAdviser: '仕',
    RedKing: '帅',
    RedCannon: '炮',
    RedPawn: '兵',
    BlackRook: '车',
    BlackKnight: '马',
    BlackBishop: '象',
    BlackAdviser: '士',
    BlackKing: '将',
    BlackCannon: '炮',
    BlackPawn: '卒',
  };

  static bool isRed(String c) => 'RNBAKCP'.contains(c);

  static bool isBlack(String c) => 'rnbakcp'.contains(c);
}
