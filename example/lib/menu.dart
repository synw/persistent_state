import 'package:flutter/material.dart';
import 'db.dart';
import 'routes/state.dart' as routes show state;
import 'squares/state.dart' as squares show state;
import 'bloc/state.dart' as bloc show state;
import 'scoped_model/state.dart' as scopedModel show state;

class _MenuPageState extends State<MenuPage> {
  bool ready = false;

  @override
  void initState() {
    db.onReady.then((_) => setState(() => ready = true));
    // dispose the local examples states if needed
    routes.state.disposeIfNeeded();
    squares.state.disposeIfNeeded();
    bloc.state.disposeIfNeeded();
    scopedModel.state.disposeIfNeeded();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ready
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: const Text("Routes"),
                    onPressed: () {
                      routes.state.init();
                      Navigator.of(context).pushNamed("/intro");
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 15.0)),
                  RaisedButton(
                    child: const Text("Squares"),
                    onPressed: () {
                      squares.state.init();
                      Navigator.of(context).pushNamed("/squares");
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 15.0)),
                  RaisedButton(
                    child: const Text("Bloc"),
                    onPressed: () {
                      bloc.state.init();
                      Navigator.of(context).pushNamed("/bloc");
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 15.0)),
                  RaisedButton(
                    child: const Text("Scoped model"),
                    onPressed: () {
                      scopedModel.state.init();
                      Navigator.of(context).pushNamed("/scoped_model");
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 15.0)),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}
