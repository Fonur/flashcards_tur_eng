import 'dart:async';
import 'dart:io';

import 'package:flashcards_for_everything/database/model/set.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class CardSetHelper {
  CardSetHelper._();
  static final CardSetHelper db = CardSetHelper._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "learn_english_cards.db");

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute(
            "CREATE TABLE flashcards(id INTEGER PRIMARY KEY, keyName TEXT, valueName TEXT, cardSetId INTEGER);");
        await db.execute(
            "CREATE TABLE sets(id INTEGER PRIMARY KEY, setName TEXT, setCount INTEGER);");
      },
    );
  }

  insertCardSet(CardSet cardSet) async {
    final db = await database;

    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM sets");

    int _id = table.first["id"];
    if (table == null) {
      _id = 0;
    }
    var raw = await db.rawInsert(
        "INSERT Into sets (id, setName, setCount)"
        " VALUES (?, ?, ?)",
        [_id, cardSet.setName, 0]);
    return raw;
  }

  getCardSet(int id) async {
    final db = await database;
    var res = await db.query("sets", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? CardSet.fromMap(res.first) : Null;
  }

  getCardSets() async {
    final db = await database;
    var res = await db.query("sets");
    List<CardSet> list =
        res.isNotEmpty ? res.map((c) => CardSet.fromMap(c)).toList() : [];
    return list;
  }

  getCardSetsLength() async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM sets");

    int _id = table.first["id"];

    return _id;
  }

  updateCardSet(CardSet cardSet) async {
    final db = await database;

    await db.update(
      'sets',
      cardSet.toMap(),
      where: "id = ?",
      whereArgs: [cardSet.id],
    );
  }

  deleteCardSet(int id) async {
    final db = await database;

    await db.delete(
      'sets',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from sets");
  }
}
