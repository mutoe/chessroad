import 'dart:math';

import 'package:chessroad/board/board-widget.dart';
import 'package:chessroad/chess/chess-base.dart';
import 'package:chessroad/chess/step-name.dart';
import 'package:chessroad/common/color-constants.dart';
import 'package:chessroad/common/toast.dart';
import 'package:chessroad/engine/analysis.dart';
import 'package:chessroad/engine/cloud-engine.dart';
import 'package:chessroad/game/battle.dart';
import 'package:chessroad/main.dart';
import 'package:chessroad/routes/setting-page.dart';
import 'package:chessroad/services/audios.dart';
import 'package:flutter/material.dart';

class BattlePage extends StatefulWidget {
  static double borderMargin = 10.0;
  static double screenPaddingHorizontal = 10.0;

  @override
  _BattlePageState createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage> {
  String _status = '';
  bool _analyzing = false;

  @override
  void initState() {
    super.initState();
    Battle.shared.init();
  }

  newGame() {
    confirm() {
      Navigator.of(context).pop();
      Battle.shared.newGame();
      setState(() {});
    }

    cancel() => Navigator.of(context).pop();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('放弃对局？', style: TextStyle(color: ColorConstants.Primary)),
        content: SingleChildScrollView(child: Text('你确定要放弃当前对局吗？')),
        actions: [
          FlatButton(child: Text('确定'), onPressed: confirm),
          FlatButton(child: Text('取消'), onPressed: cancel),
        ],
      ),
    );
  }

  void gotWin() {
    Audios.playTone('win.mp3');
    Battle.shared.phase.result = BattleResult.Win;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('赢了', style: TextStyle(color: ColorConstants.Primary)),
        content: Text('恭喜！'),
        actions: [
          FlatButton(child: Text('再来一盘'), onPressed: newGame),
          FlatButton(
              child: Text('关闭'), onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }

  void gotLose() {
    Audios.playTone('lose.mp3');
    Battle.shared.phase.result = BattleResult.Lose;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('输了', style: TextStyle(color: ColorConstants.Primary)),
        actions: [
          FlatButton(child: Text('再来一盘'), onPressed: newGame),
          FlatButton(
              child: Text('关闭'), onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }

  void gotDraw() {
    Battle.shared.phase.result = BattleResult.Draw;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('和了', style: TextStyle(color: ColorConstants.Primary)),
        actions: [
          FlatButton(child: Text('再来一盘'), onPressed: newGame),
          FlatButton(
              child: Text('关闭'), onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }

  engineToGo() async {
    changeStatus('对方思考中...');
    var engineResponse = await CloudEngine().search(Battle.shared.phase);
    if (engineResponse.type == 'move') {
      final step = engineResponse.value;
      Battle.shared.move(step.from, step.to);
      final result = Battle.shared.scanBattleResult();

      switch (result) {
        case BattleResult.Pending:
          changeStatus('清走棋...');
          break;
        case BattleResult.Win:
          gotWin();
          break;
        case BattleResult.Lose:
          gotLose();
          break;
        case BattleResult.Draw:
          gotDraw();
          break;
      }
    } else {
      changeStatus('Error: ${engineResponse.type}');
    }
  }

  changeStatus(String status) => setState(() => _status = status);

  void calcScreenPaddingHorizontal() {
    final windowSize = MediaQuery.of(context).size;
    double height = windowSize.height;
    double width = windowSize.width;

    if (height / width < 16.0 / 9.0) {
      width = height * 9 / 16;
      BattlePage.screenPaddingHorizontal =
          max(10, (windowSize.width - width) / 2 - BattlePage.borderMargin);
    }
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
              onPressed: () => Navigator.of(context).pop(),
            ),
            Expanded(child: SizedBox()),
            Hero(
              tag: 'logo',
              child: Image.asset('assets/images/logo-mini.png'),
            ),
            SizedBox(width: 10),
            Text(
              '单机对战',
              style: titleStyle,
            ),
            Expanded(child: SizedBox()),
            IconButton(
              icon: Icon(Icons.settings, color: ColorConstants.DarkTextPrimary),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => SettingPage()),
              ),
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
            child: Text(_status, maxLines: 1, style: subTitleStyle),
          ),
        ],
      ),
    );
  }

  Widget createBoard() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: BattlePage.screenPaddingHorizontal,
        vertical: BattlePage.borderMargin,
      ),
      child: BoardWidget(
        width: MediaQuery.of(context).size.width -
            BattlePage.screenPaddingHorizontal * 2,
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
          EdgeInsets.symmetric(horizontal: BattlePage.screenPaddingHorizontal),
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(children: [
        Expanded(child: SizedBox()),
        FlatButton(
          child: Text('新对局', style: buttonStyle),
          onPressed: newGame,
        ),
        Expanded(child: SizedBox()),
        FlatButton(
          child: Text('悔棋', style: buttonStyle),
          onPressed: () {
            Battle.shared.regret(steps: 2);
            setState(() {});
          },
        ),
        Expanded(child: SizedBox()),
        FlatButton(
          child: Text('分析局面', style: buttonStyle),
          onPressed: _analyzing ? null : analysisPhase,
        ),
        Expanded(child: SizedBox()),
      ]),
    );
  }

  Widget buildFooter() {
    final size = MediaQuery
        .of(context)
        .size;
    final manualText = Battle.shared.phase.manualText;

    if (size.height / size.width > 16 / 9) {
      return buildManualPanel(manualText);
    } else {
      return buildExpandableManualPanel(manualText);
    }
  }

  onBoardTap(BuildContext context, int position) {
    final phase = Battle.shared.phase;
    if (phase.side != Side.Red) return;

    final tapedPiece = phase.pieceAt(position);
    if (Battle.shared.focusIndex != Move.InvalidIndex &&
        Side.of(phase.pieceAt(Battle.shared.focusIndex)) == Side.Red) {
      if (Battle.shared.focusIndex == position) return;

      final focusPiece = phase.pieceAt(Battle.shared.focusIndex);
      if (Side.sameSide(focusPiece, tapedPiece)) {
        Battle.shared.select(position);
      } else if (Battle.shared.move(Battle.shared.focusIndex, position)) {
        final result = Battle.shared.scanBattleResult();
        switch (result) {
          case BattleResult.Pending:
            engineToGo();
            break;
          case BattleResult.Win:
            gotWin();
            break;
          case BattleResult.Lose:
            gotLose();
            break;
          case BattleResult.Draw:
            gotDraw();
            break;
        }
      }
    } else {
      if (tapedPiece != Piece.Empty) Battle.shared.select(position);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    calcScreenPaddingHorizontal();

    final header = createPageHeader();
    final board = createBoard();
    final operatorBar = createOperatorBar();
    final footer = buildFooter();

    return Scaffold(
      backgroundColor: ColorConstants.DarkBackground,
      body: Column(children: [
        header,
        board,
        operatorBar,
        footer,
      ]),
    );
  }

  Widget buildManualPanel(String text) {
    final manualStyle = TextStyle(
      fontSize: 18,
      color: ColorConstants.DarkTextSecondary,
      height: 1.5,
    );

    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 16),
        child: SingleChildScrollView(
          child: Text(text, style: manualStyle),
        ),
      ),
    );
  }

  Widget buildExpandableManualPanel(String text) {
    final manualStyle = TextStyle(
      fontSize: 18,
      height: 1.5,
    );

    return Expanded(
        child: IconButton(
      icon: Icon(Icons.expand_less, color: ColorConstants.DarkTextPrimary),
      onPressed: () => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text('棋谱', style: TextStyle(color: ColorConstants.Primary)),
          content: SingleChildScrollView(child: Text(text, style: manualStyle)),
          actions: [
            FlatButton(
              child: Text('好的'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
        ));
  }

  analysisPhase() async {
    Toast.toast(context, message: '正在分析局面...', position: ToastPosition.bottom);
    setState(() {
      _analyzing = true;
    });
    try {
      final result = await CloudEngine.analysis(Battle.shared.phase);
      print(result);
      if (result.type == 'analysis') {
        List<AnalysisItem> items = result.value;
        items.forEach((item) =>
        item.stepName = StepName.translate(
          Battle.shared.phase,
          Move.fromEngineStep(item.move),
        ));
        showAnalysisItems(
          context,
          title: '推荐招法',
          items: result.value,
          callback: (index) => Navigator.of(context).pop(),
        );
      } else if (result.type == 'no-result') {
        Toast.toast(
          context,
          message: '已请求服务器计算，请稍后查看',
          position: ToastPosition.bottom,
        );
      } else {
        Toast.toast(context,
            message: '错误：${result.type}', position: ToastPosition.bottom);
      }
    } catch (error) {
      print('Error: $error');
      Toast.toast(context,
          message: '错误：$error', position: ToastPosition.bottom);
    } finally {
      setState(() {
        _analyzing = false;
      });
    }
  }

  void showAnalysisItems(BuildContext context,
      {String title,
        List<AnalysisItem> items,
        Function(AnalysisItem item) callback}) {
    final List<Widget> children = [];
    for (var item in items) {
      children.add(ListTile(
        title: Text(item.stepName, style: TextStyle(fontSize: 18)),
        subtitle: Text('胜率: ${item.winrate}%'),
        trailing: Text('分数: ${item.score}'),
        onTap: () => callback(item),
      ));
      children.add(Divider());
    }
    children.insert(0, SizedBox(height: 10));
    children.add(SizedBox(height: 56));

    showModalBottomSheet(
      context: context,
      builder: (_) =>
          SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: children),
          ),
    );
  }
}
