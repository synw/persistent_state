import 'package:sqlcool/sqlcool.dart';

DbTable schema() {
  return DbTable("bloc_state")..integer("number", nullable: true);
}

String populate() {
  return 'INSERT INTO bloc_state(id) VALUES(1)';
}
