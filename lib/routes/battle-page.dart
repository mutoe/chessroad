import 'package:chessroad/board/board-widget.dart';
import 'package:chessroad/chess/chess-base.dart';
import 'package:chessroad/common/color-constants.dart';
import 'package:chessroad/game/battle.dart';
import 'package:chessroad/main.dart';
import 'package:flutter/material.dart';

class BattlePage extends StatefulWidget {
  static const BoardMarginVertical = 10.0;
  static const BoardMarginHorizontal = 10.0;

  @override
  _BattlePageState createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage> {
  @override
  void initState() {
    super.initState();
    Battle.shared.init();
  }

  Widget createPageHeader() {
    final titleStyle =
        TextStyle(fontSize: 28, color: ColorConstants.DarkTextPrimary);
    final subTitleStyle =
        TextStyle(fontSize: 16, color: ColorConstants.DarkTextSecondary);

    return Container(
      margin: EdgeInsets.only(top: ChessRoadApp.StatusBarHeight),
      child: Column(
        children: [
          Row(children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: ColorConstants.DarkTextPrimary,
              ),
              onPressed: () {},
            ),
            Expanded(child: SizedBox()),
            Text(
              '单机对战',
              style: titleStyle,
            ),
            Expanded(child: SizedBox()),
            IconButton(
              icon: Icon(Icons.settings, color: ColorConstants.DarkTextPrimary),
              onPressed: () {},
            ),
          ]),
          Container(
            height: 4,
            width: 180,
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: ColorConstants.BoardBackground,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('[游戏状态]', maxLines: 1, style: subTitleStyle),
          ),
        ],
      ),
    );
  }

  Widget createBoard() {
    final windowSize = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: BattlePage.BoardMarginHorizontal,
        vertical: BattlePage.BoardMarginVertical,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: ColorConstants.BoardBackground,
      ),
      child: BoardWidget(
        width: windowSize.width - BattlePage.BoardMarginHorizontal * 2,
        onBoardTap: onBoardTap,
      ),
    );
  }

  Widget createOperatorBar() {
    final buttonStyle = TextStyle(color: ColorConstants.Primary, fontSize: 20);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: ColorConstants.BoardBackground,
      ),
      margin:
          EdgeInsets.symmetric(horizontal: BattlePage.BoardMarginHorizontal),
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(children: [
        Expanded(child: SizedBox()),
        FlatButton(
          child: Text('新对局', style: buttonStyle),
          onPressed: () {},
        ),
        Expanded(child: SizedBox()),
        FlatButton(
          child: Text('悔棋', style: buttonStyle),
          onPressed: () {},
        ),
        Expanded(child: SizedBox()),
        FlatButton(
          child: Text('分析局面', style: buttonStyle),
          onPressed: () {},
        ),
        Expanded(child: SizedBox()),
      ]),
    );
  }

  onBoardTap(BuildContext context, int position) {
    final phase = Battle.shared.phase;
    if (phase.side != Side.Red) return;

    final tapedPiece = phase.pieceAt(position);
    if (Battle.shared.focusIndex != -1 &&
        Side.of(phase.pieceAt(Battle.shared.focusIndex)) == Side.Red) {
      if (Battle.shared.focusIndex == position) return;

      final focusPiece = phase.pieceAt(Battle.shared.focusIndex);
      if (Side.sameSide(focusPiece, tapedPiece)) {
        Battle.shared.select(position);
      } else if (Battle.shared.move(Battle.shared.focusIndex, position)) {
        // TODO
      }
    } else {
      if (tapedPiece != Piece.Empty) Battle.shared.select(position);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final header = createPageHeader();
    final board = createBoard();
    final operatorBar = createOperatorBar();

    return Scaffold(
      backgroundColor: ColorConstants.DarkBackground,
      body: Column(children: [
        header,
        board,
        operatorBar,
      ]),
    );
  }
}
