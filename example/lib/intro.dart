import 'package:flutter/material.dart';
import 'state.dart';

class _IntroPageState extends State<IntroPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      state.onReady.then((_) {
        // go to the previously persisted page
        Navigator.of(context).pushReplacementNamed(state.currentRoute);
        print("Redirecting to ${state.currentRoute}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: const Text("Loading .."),
          )
        ],
      ),
    ));
  }
}

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}
