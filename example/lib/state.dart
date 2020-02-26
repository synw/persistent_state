import 'package:persistent_state/persistent_state.dart';

import 'store.dart';

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
