# Persistent state

[![pub package](https://img.shields.io/pub/v/persistent_state.svg)](https://pub.dartlang.org/packages/persistent_state)

Persist state in an Sqlite database across restarts and returns from hibernation

Powered by the [KvSql](https://github.com/synw/kvsql) key/value store. The state is saved to an Sqlite database

## Usage

Create your state class:

   ```dart
   import 'dart:async';
   import 'package:flutter/foundation.dart';
   import 'package:persistent_state/persistent_state.dart';


   enum UpdateType { intProp, stringProp, doubleProp, listProp, mapProp }

   class AppState with PersistentState<UpdateType> {

     double get doubleProp => select<double>("double_prop");
     set doubleProp(double v) =>
         mutate<double>("double_prop", v, UpdateType.doubleProp);

     List<int> get listProp => select<List<int>>("list_prop");
     set listProp(List<int> v) =>
         mutate<List<int>>("list_prop", v, UpdateType.listProp);

     Map<String, int> get mapProp => select<Map<String, int>>("map_prop");
     set mapProp(Map<String, int> v) =>
         mutate<Map<String, int>>("map_prop", v, UpdateType.mapProp);
   }
   ```

All the mutations will be persisted to the database:

   ```dart
   state.doubleProp = 3.0;
   ```

**Note**: the state reads with `select` do not hit the database and
use an in memory copy of the state

If you already use KvSql you can provide your own store:

   ```dart

   final store = KvStore(inMemory: true);

   class AppState with PersistentState<UpdateType> {
      @override
      KvStore kvStore => store;
   }
   ```

### Listen to state changes

A changefeed is available:

   ```dart
   /// [appState] is an [AppState] instance
   appState.changeFeed.listen((StateUpdate change) =>
      print("State update: \n${change.type}");
   ```

## Example

An [example](example) with Provider is available
