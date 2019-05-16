import 'dart:async';
import 'package:flutter/foundation.dart';
//import 'package:observable/observable.dart';
import 'package:sqlcool/sqlcool.dart';

/// A class to persist some state to a database
class PersistentState {
  /// Default constructor: provide at least a [Db] an make sure
  /// that your database has a schema for the state table
  PersistentState(
      {@required this.db,
      this.table = "state",
      this.id = 1,
      this.verbose = false})
      : assert(db != null) {
    if (db?.schema?.hasTable(table) == null) {
      String msg = 'The database must have a schema for a "$table" table';
      if (!db.hasSchema) {
        msg += ". The database have no schema";
      } else if (db.schema.hasTable(table) == null)
        msg += ". Database schema: \n${db.schema}";
      throw (ArgumentError(msg));
    }
  }

  /// This Sqlcool [Db]
  final Db db;

  /// Verbosity level
  bool verbose;

  /// The database table to use for this instance of state
  final String table;

  /// The row id to use for this instance of state
  final int id;

  SynchronizedMap _synchronizedMap;
  final Completer _readyCompleter = Completer<dynamic>();
  bool _isReady = false;

  //ObservableMap<String, String> get data => _synchronizedMap.data;

  /// A future that completes when the state is ready
  Future<dynamic> get onReady => _readyCompleter.future;

  /// Check if the state is ready
  bool get isReady => _isReady;

  /// Select a key to get it's value.
  ///
  /// This does not hit the database
  String select(String key) {
    assert(_isReady);
    String res;
    try {
      if (!_synchronizedMap.data.containsKey(key))
        throw (ArgumentError("Key $key not found"));
      res = _synchronizedMap.data[key];
      if (res == "null") return null;
      //if (verbose) debugPrint("STATE: selected $key : $res");
    } catch (e) {
      throw (e);
    }
    return res;
  }

  /// Change the value of a key
  ///
  /// This hits the database with an update query.
  /// Limitation: rhis method is async but can not be awaited.
  /// The queries are queued so this method can
  /// be safely called concurrently
  void mutate(String key, String value) {
    assert(_isReady);
    try {
      if (!_synchronizedMap.data.containsKey(key))
        throw (ArgumentError("Key $key not found"));
      _synchronizedMap.data[key] = value;
      if (verbose) debugPrint("STATE: mutated $key to $value");
    } catch (e) {
      throw (e);
    }
  }

  /// Initialize the state
  ///
  /// Make sure that the [Db] is ready before running this.
  Future<void> init() async {
    assert(db.isReady);
    try {
      String columns;
      for (DatabaseColumn col in db.schema.table(table).schema) {
        if (columns == null) {
          columns = col.name;
        } else {
          columns = "$columns,${col.name}";
        }
      }
      _synchronizedMap = SynchronizedMap(
          db: db,
          table: table,
          columns: columns,
          where: "id=$id",
          verbose: verbose);
      await _synchronizedMap.onReady;
    } catch (e) {
      throw (e);
    }
    if (verbose)
      debugPrint("STATE: created persistant state: ${_synchronizedMap.data}");
    _isReady = true;
    _readyCompleter.complete();
  }

  /// Dispose the state to free up memory
  void dispose() {
    _synchronizedMap.dispose();
  }

  /// Print a description of the current state
  void describe() {
    debugPrint("PERSISTANT STATE:");
    _synchronizedMap.data.forEach((k, v) {
      debugPrint("  - $k : $v");
    });
  }
}
