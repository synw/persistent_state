import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:persistent_state/persistent_state.dart';

AppState appState;

enum UpdateType { intProp, stringProp, doubleProp, listProp, mapProp }

final StreamController<Store> stateController = StreamController<Store>();

void updateState({@required UpdateType type, @required dynamic value}) =>
    stateController.sink.add(Store.update(type, value));

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

class Store {
  Store();

  AppState state = appState;

  Store.update(UpdateType type, dynamic value) : this.state = appState {
    switch (type) {
      case UpdateType.intProp:
        state.intProp = value as int;
        break;
      case UpdateType.doubleProp:
        state.doubleProp = value as double;
        break;
      case UpdateType.stringProp:
        state.stringProp = value as String;
        break;
      case UpdateType.listProp:
        state.listProp = value as List<int>;
        break;
      case UpdateType.mapProp:
        state.mapProp = value as Map<String, int>;
        break;
    }
  }
}
