import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'state.dart';

class _PageState extends State<Page> {
  final Color _randomColor =
      Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
          .withOpacity(0.8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            NavButton(pageNum: 1, isSelected: (1 == widget.pageNum)),
            NavButton(pageNum: 2, isSelected: (2 == widget.pageNum)),
            NavButton(pageNum: 3, isSelected: (3 == widget.pageNum)),
            NavButton(pageNum: 4, isSelected: (4 == widget.pageNum)),
            NavButton(pageNum: 5, isSelected: (5 == widget.pageNum)),
          ],
        ),
        body: Container(
            decoration: BoxDecoration(color: _randomColor),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Page ${widget.pageNum}", textScaleFactor: 2.0),
                Padding(padding: const EdgeInsets.all(15.0)),
                RaisedButton(
                  child: const Text("Back to the menu"),
                  onPressed: () => Navigator.of(context).pushNamed("/"),
                )
              ],
            ))));
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

class Page extends StatefulWidget {
  Page(this.pageNum, {Key key}) : super(key: key);

  final int pageNum;

  @override
  _PageState createState() => _PageState();
}
