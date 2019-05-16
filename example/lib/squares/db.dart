import 'package:sqlcool/sqlcool.dart';

DbTable schema() {
  return DbTable("squares_state")..integer("active", defaultValue: 0);
}

String populate() {
  return 'INSERT INTO squares_state(id) VALUES(1)';
}
