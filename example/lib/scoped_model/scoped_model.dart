import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'state.dart';

class _ScopedModelPageState extends State<ScopedModelPage> {
  bool ready = false;

  @override
  void initState() {
    super.initState();
    Future<dynamic>.delayed(Duration.zero, () {
      state.onReady.then((dynamic _) => setState(() => ready = true));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scoped Model")),
      body: Center(
        child: ready
            ? ScopedModel<ScopedModelState>(
                model: state,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ScopedModelDescendant<ScopedModelState>(
                          builder: (context, child, model) {
                        Widget w;
                        switch (state.currentNumber == null) {
                          case false:
                            w = Text("${state.currentNumber}",
                                textScaleFactor: 5.0);
                            break;
                          case true:
                            w = const Text("Select a number",
                                textScaleFactor: 1.3);
                        }
                        return w;
                      }),
                      const Padding(padding: EdgeInsets.only(bottom: 20.0)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ScopedModelDescendant<ScopedModelState>(
                              builder: (context, child, model) =>
                                  NumberButton(1)),
                          ScopedModelDescendant<ScopedModelState>(
                              builder: (context, child, model) =>
                                  NumberButton(2)),
                          ScopedModelDescendant<ScopedModelState>(
                              builder: (context, child, model) =>
                                  NumberButton(3)),
                          ScopedModelDescendant<ScopedModelState>(
                              builder: (context, child, model) =>
                                  NumberButton(4)),
                          ScopedModelDescendant<ScopedModelState>(
                              builder: (context, child, model) =>
                                  NumberButton(5)),
                        ],
                      )
                    ]))
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

class ScopedModelPage extends StatefulWidget {
  @override
  _ScopedModelPageState createState() => _ScopedModelPageState();
}
