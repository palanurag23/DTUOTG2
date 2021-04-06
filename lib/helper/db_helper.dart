import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

import 'dart:async';

class DbHelper {
  static Future<Database> dataBaseForAccessToken() async {
    //......................................Getting access to DB
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
        // searches for db ,if not found,it creats db
        path.join(dbPath, 'DtuOtgAccessToken.db'), onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE AccessToken(id TEXT PRIMARY KEY,accessToken TEXT,dateTime TEXT)');
    }, version: 1);

    //......................................Getting access to DB
  }

  static Future<void> insertAccessToken(
    String table,
    Map<String, Object> newAccessToken,
  ) async {
    final dbForAccessToken = await DbHelper.dataBaseForAccessToken();
    dbForAccessToken.insert(table, newAccessToken,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getAccessTokenData() async {
    final db = await DbHelper.dataBaseForAccessToken();
    return db.query('AccessToken');
  }
}
