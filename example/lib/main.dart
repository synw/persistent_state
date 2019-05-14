import 'package:flutter/material.dart';
import 'page_builder.dart';
import 'state.dart';
import 'db.dart';
import 'intro.dart';

final routes = {
  '/page1': (BuildContext context) => Page(1),
  '/page2': (BuildContext context) => Page(2),
  '/page3': (BuildContext context) => Page(3),
  '/page4': (BuildContext context) => Page(4),
  '/page5': (BuildContext context) => Page(5),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Persistent state demo',
      home: IntroPage(),
      routes: routes,
    );
  }
}

void main() {
  initDb().then((_) => state.init());
  runApp(MyApp());
}
