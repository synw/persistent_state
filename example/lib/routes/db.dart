import 'package:sqlcool/sqlcool.dart';

DbTable schema() {
  return DbTable("routes_state")..varchar("route", defaultValue: '"/page1"');
}

String populate() {
  return 'INSERT INTO routes_state(id) VALUES(1)';
}
