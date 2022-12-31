import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:translator/translator.dart' as text;

class DatabaseHelper {
  //step1-create table
  static Future<void> createTable(sql.Database database) async {
    await database.execute("""
        CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,  
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )
        """).then((value) => debugPrint("table created successfully"));
  }

  //step2- link table with database
  static Future<sql.Database> db() async {
    return sql.openDatabase('flutterDb', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTable(database);
    }, onConfigure: (sql.Database database) {
      debugPrint("on configure is called");
    }, onUpgrade:
            (sql.Database database, int oldVersion, int newVersion) async {
      await createTable(database);
      debugPrint("on upgrade is called");
    });
  }

  //step3 - create new item
  static Future<void> createItem(String title, String description) async {

    //first open database
    final db = await DatabaseHelper.db();

    final data = {
      'title': title,
      'description': description,
    };

    final id = await db
        .insert('items', data, conflictAlgorithm: sql.ConflictAlgorithm.replace)
        .then((value) => debugPrint("insert successfully"));
  }

  //step4 - fetch all data
  static Future<List<Map<String, dynamic>>> getItems(String filter) async {
    final db = await DatabaseHelper.db();

    return db.query('items', orderBy: filter);
  }

  static final translator = text.GoogleTranslator();

  static List<Map<String, dynamic>> translatedTextItems = [];

  static Future<String> _translateText(
      String message, String languageCode) async {
    final text =
        await translator.translate(message, from: "auto", to: languageCode);
    return text.text;
  }

  static Future<List<Map<String, dynamic>>> getItemsWithSpecificLanguage(
      String filter, String languageCode) async {
    final db = await DatabaseHelper.db();

    List<Map<String, dynamic>> text = await db.query('items', orderBy: filter);

    for (int i = 0; i < text.length; i++) {
      final title = await _translateText(text[i]["title"], languageCode);
      final description =
          await _translateText(text[i]["description"], languageCode);

      final item = {"title": title, "description": description};
      translatedTextItems.add(item);
    }
    return translatedTextItems;
  }

  //step5 - get one data item
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await DatabaseHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  //step6 - update data
  static Future<void> updateItem(int id, String title, String description) async {
    final db = await DatabaseHelper.db();

    final data = {
      'title': title,
      'description': description,
      'createdAt': DateTime.now().toString()
    };

    final result = await db.update('items', data,
        where: "id = ?",
        whereArgs: [id]).then((value) => debugPrint("update successfully"));
  }

  //step7- delete data
  static Future<void> deleteItem(int id) async {
    final db = await DatabaseHelper.db();
    try {
      await db.delete('items',
          where: "id = ?",
          whereArgs: [id]).then((value) => debugPrint("delete successfully"));
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
