import 'dart:async';
import 'package:flutter/foundation.dart';

import 'state.dart';

enum UpdateType { intProp, stringProp, doubleProp, listProp, mapProp }

AppState appState;

final StreamController<Store> stateController = StreamController<Store>();

void updateState({@required UpdateType type, @required dynamic value}) =>
    stateController.sink.add(Store.update(type, value));

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
