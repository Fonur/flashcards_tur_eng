import 'dart:async';
import 'dart:io';

import 'package:flashcards_for_everything/database/model/flashcard.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class FlashCardHelper {
  FlashCardHelper._();
  static final FlashCardHelper db = FlashCardHelper._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "learning_cards.db");
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute(
            "CREATE TABLE flashcards(id INTEGER IDENTITY(1,1) PRIMARY KEY, keyName TEXT, valueName TEXT, cardSetId INTEGER);");
        await db.execute(
            "CREATE TABLE sets(id INTEGER IDENTITY(1,1) PRIMARY KEY, setName TEXT, setCount INTEGER);");
      },
    );
  }

  insertFlashCard(FlashCard flashcard) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM flashcards");
    int _id = table.first["id"];
    var raw = await db.rawInsert(
        "INSERT Into flashcards (id, keyName, valueName, cardSetId)"
        "VALUES (?, ?, ?, ?)",
        [_id, flashcard.keyName, flashcard.valueName, flashcard.cardSetId]);
    return raw;
  }

  getFlashCard(int id) async {
    final db = await database;
    var res = await db.query("flashcards", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? FlashCard.fromMap(res.first) : Null;
  }

  getRandomFlashCard(String cardSetId) async {
    final db = await database;
    var res = await db.query("flashcards",
        orderBy: "RANDOM()",
        where: "cardSetId = ?",
        whereArgs: [cardSetId],
        limit: 1);
    return res.isNotEmpty ? FlashCard.fromMap(res.first) : print("null");
  }

  getFlashCards(String cardSetId) async {
    final db = await database;
    var res = await db
        .query("flashcards", where: "cardSetId = ?", whereArgs: [cardSetId]);
    List<FlashCard> list =
        res.isNotEmpty ? res.map((c) => FlashCard.fromMap(c)).toList() : [];
    return list;
  }

  updateFlashCard(FlashCard flashcard) async {
    final db = await database;

    await db.update(
      'flashcards',
      flashcard.toMap(),
      where: "id = ?",
      whereArgs: [flashcard.id],
    );
  }

  deleteFlashCard(int id) async {
    final db = await database;

    await db.delete(
      'flashcards',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  deleteAll(int id) async {
    final db = await database;
    await db.delete(
      'flashcards',
      where: "cardSetId = ?",
      whereArgs: [id],
    );
  }
}
