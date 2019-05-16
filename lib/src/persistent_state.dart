import 'dart:async';
import 'package:flutter/foundation.dart';
//import 'package:observable/observable.dart';
import 'package:sqlcool/sqlcool.dart';

class PersistentState {
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

  final Db db;
  bool verbose;
  final String table;
  final int id;

  SynchronizedMap _synchronizedMap;
  final Completer _readyCompleter = Completer();
  bool _isReady = false;

  //ObservableMap<String, String> get data => _synchronizedMap.data;

  Future<dynamic> get onReady => _readyCompleter.future;
  bool get isReady => _isReady;

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

  Future<void> init() async {
    assert(db.isReady);
    assert(db.hasSchema);
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

  void dispose() {
    _synchronizedMap.dispose();
  }

  void describe() {
    debugPrint("PERSISTANT STATE:");
    _synchronizedMap.data.forEach((k, v) {
      debugPrint("  - $k : $v");
    });
  }
}
