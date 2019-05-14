import 'dart:async';
import 'package:flutter/material.dart';
import 'package:persistent_state/persistent_state.dart';
import 'db.dart';

AppState state = AppState();

class AppState {
  AppState() {}

  PersistentState store;
  Completer _readyCompleter = Completer();

  String get currentRoute => store.select("route");
  //set currentRoute(String routeName) => store.mutate("route", routeName);

  Future<dynamic> get onReady => _readyCompleter.future;

  Future<void> navigate(BuildContext context, String routeName) async {
    print("Navigating to $routeName");
    store.mutate("route", routeName);
    await Navigator.of(context).pushNamed(routeName);
  }

  Future<void> init() async {
    assert(db.isReady);
    print("Initializing state");
    try {
      store = PersistentState(db: db, verbose: true);
      await store.init();
      await store.onReady;
      _readyCompleter.complete();
    } catch (e) {
      throw ("Can not create persistent state");
    }
  }
}
