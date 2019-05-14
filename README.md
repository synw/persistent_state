# Persistent state

Persist state in a database across restarts and returns from hibernation. Powered by [Sqlcool](https://github.com/synw/sqlcool)

## Example

Goal: to persist the current page

### Define the state data and initialize the database

 In `db.dart`:

   ```dart
   import 'package:sqlcool/sqlcool.dart';

   Db db = Db();

   DbTable stateTableSchema() {
     /// Define a state table in the database
     ///
     /// Documentation about schemas:
     /// https://pub.dev/documentation/sqlcool/latest/sqlcool/DbTable-class.html
     ///
     return DbTable("state")..varchar("route", defaultValue: '"/page1"');
   }

   Future<void> initDb() async {
      try {
         await db.init(
            path: "db.sqlite",
            schema: [stateTableSchema()],
            queries: [_populate()]);
         } catch (e) {
      throw ("Can not init db $e");
      }
   }

   String _populate() {
      return 'INSERT INTO state(id) VALUES(1)';
   }
   ```

### Create the state

In `state.dart`:

   ```dart
   import 'dart:async';
   import 'package:flutter/material.dart';
   import 'package:persistent_state/persistent_state.dart';
   import 'db.dart';

   AppState state = AppState();

   class AppState {
      PersistentState store;

      Completer _readyCompleter = Completer();

      String get currentRoute => store.select("route");

      Future<dynamic> get onReady => _readyCompleter.future;

      Future<void> navigate(BuildContext context, String routeName) async {
         // Hit the database to update the route
         store.mutate("route", routeName);
         await Navigator.of(context).pushNamed(routeName);
      }

      Future<void> init() async {
         /// db is an Sqlcool [Db] object
         /// run [initDb] before this
         assert(db.isReady);
         try {
            store = PersistentState(db: db);
            store.init();
            await store.onReady;
            _readyCompleter.complete();
         } catch (e) {
            throw ("Can not create persistent state $e");
         }
      }
   }
   ```

### Init state

   ```dart
   void main() {
      initDb().then((_) => state.init());
      runApp(MyApp());
   }

   // later
   await state.onReady;
   // or
   state.onReady.then((_) => doSomething());
   ```


### Use the state

Calling `navigate` from anywhere will persist the state of the current route

   ```dart
   state.navigate(context, "/page3");
   ```
