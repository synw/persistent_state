import 'dart:async';

import 'package:err/err.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'exceptions.dart';
import 'models.dart';

/// The base state class
class PersistentState<UpdateType> {
  /// Initialize the store
  Future<void> init() async {
    await Hive.initFlutter();
    box = await Hive.openBox<dynamic>('state');
    _onReady.complete();
  }

  /// The class to store the data
  ///
  /// Override this to provide your own store
  Box<dynamic> box;

  final StreamController<StateUpdate> _changeFeed =
      StreamController<StateUpdate>.broadcast();
  final _onReady = Completer<dynamic>();

  /// Use this when no [kvStore] is provided at initialization
  Future<void> get onReady => _onReady.future;

  /// The feed of state changes
  Stream<StateUpdate> get changeFeed => _changeFeed.stream;

  /// Get a value for a key
  T select<T>(String key) {
    T v;
    try {
      v = box.get(key) as T;
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
    } catch (e) {
      Err.error("The provided value $v is not $T").raise();
      return;
    }
    try {
      await box.put(key, v);
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
