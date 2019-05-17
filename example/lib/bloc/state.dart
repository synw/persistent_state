import 'dart:async';
import 'package:persistent_state/persistent_state.dart';
import '../db.dart';

var state = BlocState();

class BlocState {
  PersistentState store;
  Completer _readyCompleter = Completer<dynamic>();

  final StreamController<int> _controller = StreamController<int>.broadcast();

  Stream<int> get changefeed => _controller.stream;

  int get currentNumber => int.tryParse("${store.select("number")}");
  set currentNumber(int n) => _setCurrentNumber(n);

  Future<dynamic> get onReady => _readyCompleter.future;

  void _setCurrentNumber(int n) {
    store.mutate("number", "$n");
    _controller.sink.add(n);
  }

  Future<void> init() async {
    assert(db.isReady);
    if (_readyCompleter.isCompleted) return;
    print("Initializing bloc state");
    try {
      store = PersistentState(db: db, table: "bloc_state", verbose: true);
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
      _controller.close();
      print("Disposed bloc state");
    }
  }
}
