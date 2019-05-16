import 'package:flutter/material.dart';
import 'state.dart';

class _SquaresPageState extends State<SquaresPage> {
  int maxSquares = 120;
  bool ready = false;
  bool running = false;

  @override
  void initState() {
    super.initState();
    Future<dynamic>.delayed(Duration.zero, () {
      state.onReady.then((dynamic _) => setState(() => ready = true));
    });
  }

  Future<void> buildSquares() async {
    // reset if full
    if (state.active == maxSquares) state.active = 0;
    // draw
    while (state.active != maxSquares) {
      if (!running) return;
      await Future<dynamic>.delayed(Duration(milliseconds: 50));
      // hit the database
      setState(() => state.active++);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Squares")),
      body: ready
          ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  !running
                      ? RaisedButton(
                          child: Row(
                            children: <Widget>[
                              const Icon(Icons.play_arrow, color: Colors.green),
                              const Text("Build squares"),
                            ],
                          ),
                          onPressed: () {
                            setState(() => running = true);
                            buildSquares();
                          },
                        )
                      : RaisedButton(
                          child: Row(
                            children: <Widget>[
                              const Icon(Icons.stop, color: Colors.red),
                              const Text("Stop"),
                            ],
                          ),
                          onPressed: () => setState(() => running = false),
                        ),
                  Expanded(
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 30),
                          itemCount: state.active,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  width: 10.0,
                                  height: 10.0,
                                  decoration: BoxDecoration(color: Colors.blue),
                                  child: const Text(""),
                                ));
                          }))
                ],
              ))
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class SquaresPage extends StatefulWidget {
  @override
  _SquaresPageState createState() => _SquaresPageState();
}
