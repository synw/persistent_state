import 'package:flutter/material.dart';
import 'state.dart';

class _BlocPageState extends State<BlocPage> {
  bool ready = false;

  @override
  void initState() {
    state.changefeed.listen((int n) {
      if (mounted) setState(() {});
    });
    super.initState();
    Future<dynamic>.delayed(Duration.zero, () {
      state.onReady.then((dynamic _) => setState(() => ready = true));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bloc")),
      body: Center(
        child: ready
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    (state.currentNumber == null)
                        ? const Text("Select a number", textScaleFactor: 1.3)
                        : Text("${state.currentNumber}", textScaleFactor: 5.0),
                    const Padding(padding: EdgeInsets.only(bottom: 20.0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        NumberButton(1),
                        NumberButton(2),
                        NumberButton(3),
                        NumberButton(4),
                        NumberButton(5)
                      ],
                    )
                  ])
            : const CircularProgressIndicator(),
      ),
    );
  }
}

class NumberButton extends StatelessWidget {
  NumberButton(this.number, {Key key}) : super(key: key);

  final int number;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Stack(children: <Widget>[
              Icon(
                Icons.brightness_1,
                size: 50.0,
                color: (state.currentNumber == null)
                    ? Colors.grey
                    : (state.currentNumber == number)
                        ? Colors.blue
                        : Colors.grey[300],
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 7.0, left: 16.0),
                  child: Text("$number", textScaleFactor: 2.0)),
            ])),
        // hit the database
        onTap: () => state.currentNumber = number);
  }
}

class BlocPage extends StatefulWidget {
  @override
  _BlocPageState createState() => _BlocPageState();
}
