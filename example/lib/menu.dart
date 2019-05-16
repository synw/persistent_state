import 'package:flutter/material.dart';
import 'routes/state.dart' as routesState show state;
import 'squares/state.dart' as squaresState show state;

class _MenuPageState extends State<MenuPage> {
  @override
  void initState() {
    // dispose the local examples states if needed
    routesState.state.disposeIfNeeded();
    squaresState.state.disposeIfNeeded();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: const Text("Routes"),
              onPressed: () {
                routesState.state.init();
                Navigator.of(context).pushNamed("/intro");
              },
            ),
            Padding(padding: const EdgeInsets.only(bottom: 15.0)),
            RaisedButton(
              child: const Text("Squares"),
              onPressed: () {
                squaresState.state.init();
                Navigator.of(context).pushNamed("/squares");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}
