import 'package:chessroad/common/color-constants.dart';
import 'package:chessroad/main.dart';
import 'package:chessroad/routes/battle-page.dart';
import 'package:chessroad/routes/setting-page.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> with TickerProviderStateMixin {
  AnimationController inController, shadowController;
  Animation inAnimation, shadowAnimation;

  @override
  void initState() {
    super.initState();

    // title scale animation
    inController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    inAnimation = CurvedAnimation(parent: inController, curve: Curves.bounceIn);
    inAnimation = Tween(begin: 1.6, end: 1.0).animate(inController);

    // shadow depth animation
    shadowController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    shadowAnimation = Tween(begin: 0.0, end: 12.0).animate(shadowController);

    inController.addStatusListener((status) {
      if (status == AnimationStatus.completed) shadowController.forward();
    });

    shadowController.addStatusListener((status) {
      if (status == AnimationStatus.completed) shadowController.reverse();
    });

    inAnimation.addListener(() {
      try {
        setState(() {});
      } catch (e) {}
    });
    shadowAnimation.addListener(() {
      try {
        setState(() {});
      } catch (e) {}
    });
    inController.forward();
  }

  @override
  void dispose() {
    inController.dispose();
    shadowController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nameStyle = TextStyle(
      fontSize: 64,
      color: Colors.black,
      shadows: [
        Shadow(
          color: Color(0x99660000),
          offset: Offset(0, shadowAnimation.value / 2),
          blurRadius: shadowAnimation.value,
        )
      ],
    );
    final menuItemStyle = TextStyle(
      fontSize: 28,
      color: ColorConstants.Primary,
      shadows: [
        Shadow(
          color: Color(0x7f000000),
          offset: Offset(0, shadowAnimation.value / 6),
          blurRadius: shadowAnimation.value / 3,
        )
      ],
    );

    final menuItems = Center(
      child: Column(
        children: [
          Expanded(child: SizedBox(), flex: 4),
          Hero(
            tag: 'logo',
            child: Image.asset('assets/images/logo.png'),
          ),
          Expanded(child: SizedBox()),
          Transform.scale(
            scale: inAnimation.value,
            child: Text('中国象棋', style: nameStyle, textAlign: TextAlign.center),
          ),
          Expanded(child: SizedBox()),
          FlatButton(
            child: Text('单机对战', style: menuItemStyle),
            onPressed: () {},
          ),
          Expanded(child: SizedBox()),
          FlatButton(
            child: Text('挑战云主机', style: menuItemStyle),
            onPressed: () => navigateTo(BattlePage()),
          ),
          Expanded(child: SizedBox()),
          FlatButton(
            child: Text('排行榜', style: menuItemStyle),
            onPressed: () {},
          ),
          Expanded(child: SizedBox(), flex: 3),
          Text(
            '感谢贺老师的教程！',
            style: TextStyle(color: Colors.black54, fontSize: 16),
          ),
          Expanded(child: SizedBox()),
        ],
      ),
    );
    return Scaffold(
      backgroundColor: ColorConstants.LightBackground,
      body: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Image(image: AssetImage('assets/images/mei.png')),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Image(image: AssetImage('assets/images/zhu.png')),
          ),
          menuItems,
          Positioned(
            top: ChessRoadApp.StatusBarHeight,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.settings, color: ColorConstants.Primary),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => SettingPage()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  navigateTo(Widget page) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );

    inController.reset();
    shadowController.reset();
    inController.forward();
  }
}
