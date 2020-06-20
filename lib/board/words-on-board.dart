import 'package:chessroad/common/color-constants.dart';
import 'package:flutter/material.dart';

class WordsOnBoard extends StatelessWidget {
  static const DigitsFontSize = 18.0;

  @override
  Widget build(BuildContext context) {
    final blackColumns = '１２３４５６７８９';
    final redColumns = '九八七六五四三二一';
    final List<Widget> blackChildren = [];
    final List<Widget> redChildren = [];

    final digitsStyle = TextStyle(fontSize: DigitsFontSize);
    final riverTipsStyle = TextStyle(fontSize: 28.0);

    for (var i = 0; i < 9; ++i) {
      blackChildren.add(Text(blackColumns[i], style: digitsStyle));
      redChildren.add(Text(redColumns[i], style: digitsStyle));

      if (i < 8) {
        blackChildren.add(Expanded(child: SizedBox()));
        redChildren.add(Expanded(child: SizedBox()));
      }
    }

    final riverTips = Row(
      children: [
        Expanded(child: SizedBox()),
        Text('楚河', style: riverTipsStyle),
        Expanded(child: SizedBox(), flex: 2),
        Text('汉界', style: riverTipsStyle),
        Expanded(child: SizedBox()),
      ],
    );

    return DefaultTextStyle(
      style: TextStyle(
        color: ColorConstants.BoardTips,
        fontFamily: 'QiTi',
      ),
      child: Column(
        children: [
          Row(children: blackChildren),
          Expanded(child: SizedBox()),
          riverTips,
          Expanded(child: SizedBox()),
          Row(children: redChildren),
        ],
      ),
    );
  }
}
