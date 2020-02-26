# Persistent state

[![pub package](https://img.shields.io/pub/v/persistent_state.svg)](https://pub.dartlang.org/packages/persistent_state)

Persist state in an Hive database across restarts and returns from hibernation

## Usage

### Create state update types

Define the state mutations:

   ```dart
   enum UpdateType { intProp, stringProp, doubleProp, listProp, mapProp }
   ```

### Create the state class

Create your state class and map the properties to the persitent store:

   ```dart
   import 'package:persistent_state/persistent_state.dart';


   enum UpdateType { intProp, stringProp, doubleProp, listProp, mapProp }

   class AppState with PersistentState<UpdateType> {
      int get intProp => select<int>("int_prop");
      set intProp(int v) => mutate<int>("int_prop", v, UpdateType.intProp);
    
      double get doubleProp => select<double>("double_prop");
      set doubleProp(double v) =>
          mutate<double>("double_prop", v, UpdateType.doubleProp);
    
      String get stringProp => select<String>("string_prop");
      set stringProp(String v) =>
          mutate<String>("string_prop", v, UpdateType.stringProp);
    
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
   final AppState state = AppState();
   state.doubleProp = 3.0;
   ```

**Note**: the state reads with `select` do not hit the database and
use an in memory copy of the state

### Listen to state changes

A changefeed is available:

   ```dart
   /// [appState] is an [AppState] instance
   appState.changeFeed.listen((StateUpdate change) =>
      print("State update: \n${change.type}");
   ```

## Example

An [example](example) with Provider is available
