import 'package:sqlcool/sqlcool.dart';
import 'routes/db.dart' as routes;
import 'squares/db.dart' as squares;
import 'bloc/db.dart' as bloc;
import 'scoped_model/db.dart' as scopedModel;

Db db = Db();

Future<void> initDb() async {
  print("Initializing database");
  try {
    await db.init(
        path: "db.sqlite",
        schema: [
          routes.schema(),
          squares.schema(),
          bloc.schema(),
          scopedModel.schema()
        ],
        queries: [
          routes.populate(),
          squares.populate(),
          bloc.populate(),
          scopedModel.populate()
        ],
        verbose: true);
  } catch (e) {
    throw ("Can not init db $e");
  }
}
