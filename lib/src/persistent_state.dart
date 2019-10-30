import 'dart:async';

import 'package:kvsql/kvsql.dart';

import 'exceptions.dart';
import 'models.dart';

/// The base state class
class PersistentState<UpdateType> {
  /// Use this if [kvStore] is not overriden
  Future<void> init({bool verbose = false}) async {
    if (kvStore == null) {
      kvStore = KvStore(inMemory: true, verbose: verbose);
    } else {
      assert(kvStore.inMemory);
      //assert(kvStore.isReady);
    }
  }

  /// The class to kvStore the data
  ///
  /// Override this to provide your own store
  KvStore kvStore;

  final StreamController<StateUpdate> _changeFeed =
      StreamController<StateUpdate>.broadcast();

  /// Use this when no [kvStore] is provided at initialization
  Future<void> get onReady => kvStore.onReady;

  /// Use this when no [kvStore] is provided at initialization
  //bool get isReady => kvStore.isReady;

  /// The feed of state changes
  Stream<StateUpdate> get changeFeed => _changeFeed.stream;

  /// Get a value for a key
  T select<T>(String key) {
    T v;
    try {
      v = kvStore.selectSync<T>(key);
    } catch (e) {
      throw StateStorageException("Can not read state: database error: $e");
    }
    return v;
  }

  /// Mutate a property
  Future<void> mutate<T>(String key, dynamic value, [UpdateType type]) async {
    T v;
    try {
      v = value as T;
    } catch (e) {}
    try {
      await kvStore.put<T>(key, v);
    } catch (e) {
      throw StateStorageException(
          "Can not mutate state: database write error: $e");
    }
    final update = StateUpdate<UpdateType>(key, value, type);
    _notify(update);
  }

  void _notify(StateUpdate update) {
    _changeFeed.sink.add(update);
  }

  /// Dispose when finished using
  void dispose() => _changeFeed.close();
}
