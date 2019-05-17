import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:persistent_state/persistent_state.dart';
import '../db.dart';

var state = ScopedModelState();

class ScopedModelState extends Model {
  PersistentState store;
  Completer _readyCompleter = Completer<dynamic>();

  int get currentNumber => int.tryParse("${store.select("number")}");
  set currentNumber(int n) => _setCurrentNumber(n);

  Future<dynamic> get onReady => _readyCompleter.future;

  void _setCurrentNumber(int n) {
    // hit the database
    store.mutate("number", "$n");
    notifyListeners();
  }

  Future<void> init() async {
    assert(db.isReady);
    if (_readyCompleter.isCompleted) return;
    print("Initializing scoped_model state");
    try {
      store =
          PersistentState(db: db, table: "scoped_model_state", verbose: true);
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
      _readyCompleter = Completer<dynamic>();
      print("Disposed bloc state");
    }
  }
}
