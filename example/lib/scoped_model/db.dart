import 'package:sqlcool/sqlcool.dart';

DbTable schema() {
  return DbTable("scoped_model_state")..integer("number", nullable: true);
}

String populate() {
  return 'INSERT INTO scoped_model_state(id) VALUES(1)';
}
