import 'package:sqlcool/sqlcool.dart';
import 'routes/db.dart' as routes;
import 'squares/db.dart' as squares;

Db db = Db();

Future<void> initDb() async {
  print("Initializing database");
  try {
    var timer = Stopwatch();
    timer.start();
    await db.init(
        path: "db.sqlite",
        schema: [routes.schema(), squares.schema()],
        queries: [routes.populate(), squares.populate()],
        verbose: true);
    timer.stop();
    print("Database initialized in ${timer.elapsed}");
  } catch (e) {
    throw ("Can not init db $e");
  }
}
