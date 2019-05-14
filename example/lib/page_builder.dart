import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'state.dart';

class Page extends StatelessWidget {
  Page(this.pageNum, {Key key}) : super(key: key);

  final int pageNum;

  final Color _randomColor =
      Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
          .withOpacity(0.8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            NavButton(pageNum: 1, isSelected: (1 == pageNum)),
            NavButton(pageNum: 2, isSelected: (2 == pageNum)),
            NavButton(pageNum: 3, isSelected: (3 == pageNum)),
            NavButton(pageNum: 4, isSelected: (4 == pageNum)),
            NavButton(pageNum: 5, isSelected: (5 == pageNum)),
          ],
        ),
        body: Container(
            decoration: BoxDecoration(color: _randomColor),
            child: Center(
              child: Text("Page $pageNum", textScaleFactor: 2.0),
            )));
  }
}

class NavButton extends StatelessWidget {
  const NavButton({
    Key key,
    @required this.pageNum,
    this.isSelected = false,
  }) : super(key: key);

  final int pageNum;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.brightness_1,
        size: 35.0,
        color: (isSelected) ? Colors.red : Colors.white,
      ),
      onPressed: () => state.navigate(context, "/page$pageNum"),
    );
  }
}
