import 'dart:async';
import 'package:persistent_state/persistent_state.dart';
import '../db.dart';

var state = SquaresState();

class SquaresState {
  PersistentState store;
  Completer _readyCompleter = Completer();

  Future<dynamic> get onReady => _readyCompleter.future;

  int get active => int.tryParse(store.select("active"));
  set active(int number) => store.mutate("active", "$number");

  Future<void> init() async {
    assert(db.isReady);
    if (_readyCompleter.isCompleted) return;
    print("Initializing state");
    try {
      store = PersistentState(db: db, table: "squares_state", verbose: true);
      await store.init();
      await store.onReady;
      _readyCompleter.complete();
    } catch (e) {
      throw ("Can not create persistent state $e");
    }
  }

  void disposeIfNeeded() {
    if (store != null) {
      store.dispose();
      _readyCompleter = Completer();
      print("Disposed route state");
    }
  }
}
