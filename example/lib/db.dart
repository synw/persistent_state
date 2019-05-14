import 'package:sqlcool/sqlcool.dart';

Db db = Db();

DbTable stateTableSchema() {
  // define a state table in the database
  return DbTable("state")..varchar("route", defaultValue: '"/page1"');
}

Future<void> initDb() async {
  print("Initializing database");
  try {
    await db.init(
        path: "db.sqlite",
        schema: [stateTableSchema()],
        queries: [_populate()],
        verbose: true);
  } catch (e) {
    throw ("Can not init db $e");
  }
}

String _populate() {
  return 'INSERT INTO state(id) VALUES(1)';
}
