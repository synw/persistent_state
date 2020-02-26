import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pedantic/pedantic.dart';

import 'page.dart';
import 'state.dart';

final Map<String, Page Function(BuildContext)> routes = {
  '/': (BuildContext context) => Page(),
};

void main() {
  runApp(MyApp());
  appState = AppState();
  unawaited(appState.init());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Store>.value(
        initialData: Store(),
        value: stateController.stream,
        child: MaterialApp(
          routes: routes,
          debugShowCheckedModeBanner: false,
          title: 'Persistent state example',
        ));
  }
}
