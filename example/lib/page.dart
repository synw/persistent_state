import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:persistent_state/persistent_state.dart';
import 'state.dart';

Random random = Random();

class _PageState extends State<Page> {
  bool _ready = false;
  String status = "";

  @override
  void initState() {
    super.initState();

    /// listen to the state changes
    appState.changeFeed.listen((StateUpdate change) =>
        setState(() => status = "State update: \n${change.description}"));

    /// wait for tje state to be ready. This is not necessary
    /// if a [kvStore] argument is provided at state class
    /// initialization
    appState.onReady.then((_) {
      setState(() => _ready = true);
      // set the initial state
      updateState(type: UpdateType.intProp, value: 1);
      updateState(type: UpdateType.doubleProp, value: 1.0);
      updateState(type: UpdateType.stringProp, value: "one");
      updateState(type: UpdateType.listProp, value: <int>[1, 2, 3]);
      updateState(
          type: UpdateType.mapProp, value: <String, int>{"one": 1, "two": 2});
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<Store>(context).state;
    return Scaffold(
      appBar: AppBar(title: const Text("Persistent state")),
      body: _ready
          ? Column(
              children: <Widget>[
                const Padding(padding: EdgeInsets.only(top: 20.0)),
                Text("Int prop: ${state.intProp}"),
                Text("Double prop: ${state.doubleProp}"),
                Text("String prop: ${state.stringProp}"),
                Text("List<int> prop: ${state.listProp}"),
                Text("Map<String,int> prop: ${state.mapProp}"),
                const Divider(),
                RaisedButton(
                  child: const Text("Change int prop"),
                  onPressed: () => updateState(
                      type: UpdateType.intProp, value: random.nextInt(100)),
                ),
                RaisedButton(
                  child: const Text("Change double prop"),
                  onPressed: () => updateState(
                      type: UpdateType.doubleProp, value: random.nextDouble()),
                ),
                RaisedButton(
                  child: const Text("Change string prop"),
                  onPressed: () => updateState(
                      type: UpdateType.stringProp,
                      value: "string ${random.nextInt(100)}"),
                ),
                RaisedButton(
                  child: const Text("Change list prop"),
                  onPressed: () => updateState(
                    type: UpdateType.listProp,
                    value: <int>[random.nextInt(100), random.nextInt(100)],
                  ),
                ),
                RaisedButton(
                  child: const Text("Change map prop"),
                  onPressed: () => updateState(
                      type: UpdateType.mapProp,
                      value: <String, int>{
                        "one": random.nextInt(100),
                        "two": random.nextInt(100)
                      }),
                ),
                Padding(
                    child: Text(status),
                    padding: const EdgeInsets.only(top: 10.0))
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class Page extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}
