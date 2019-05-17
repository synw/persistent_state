import 'package:flutter/material.dart';
import 'db.dart';
import 'menu.dart';
import 'routes/page_builder.dart';
import 'routes/intro.dart';
import 'squares/squares.dart';
import 'bloc/bloc.dart';
import 'scoped_model/scoped_model.dart';

final routes = {
  '/': (BuildContext context) => MenuPage(),
  // pages example
  '/intro': (BuildContext context) => IntroPage(),
  '/page1': (BuildContext context) => Page(1),
  '/page2': (BuildContext context) => Page(2),
  '/page3': (BuildContext context) => Page(3),
  '/page4': (BuildContext context) => Page(4),
  '/page5': (BuildContext context) => Page(5),
  // squares example
  '/squares': (BuildContext context) => SquaresPage(),
  // bloc example
  '/bloc': (BuildContext context) => BlocPage(),
  // scoped model example
  '/scoped_model': (BuildContext context) => ScopedModelPage(),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Persistent state demo',
      routes: routes,
    );
  }
}

void main() {
  initDb();
  runApp(MyApp());
}
