import 'dart:io';

import 'package:markit_list/models/article_model.dart';
import 'package:markit_list/models/liste_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MyDatabase {
  MyDatabase._privateConstructor();

  static final MyDatabase instance = MyDatabase._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "markitlist.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE Liste(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name varchar(255) NOT NULL,
          price INTEGER DEFAULT 0,
          isFinish boolean DEFAULT 0,
          isImportant boolean DEFAULT 0,
          creationDate DATETIME
        );
      ''');

    await db.execute('''
        CREATE TABLE Article(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name varchar(255) NOT NULL,
          price INTEGER NOT NULL,
          isBuy boolean DEFAULT 0,
          amount INTEGER NOT NULL,
          liste int,
          FOREIGN KEY (liste) REFERENCES Liste(id)
          ON DELETE CASCADE
        );
      ''');
  }

  Future<List<Liste>> getListe({trie=""}) async {
    Database db = await instance.database;
    var listes = await db.query(
      "Liste",
      orderBy: '$trie creationDate Desc',
    );

    List<Liste> listesList =
        listes.isNotEmpty ? listes.map((e) => Liste.fromMap(e)).toList() : [];

    return listesList;
  }

  Future<List<Article>> getArticle(int id) async {
    Database db = await instance.database;
    var articles = await db
        .query("Article", orderBy: 'name', where: 'liste=?', whereArgs: [id]);

    List<Article> articlesList = articles.isNotEmpty
        ? articles.map((e) => Article.fromMap(e)).toList()
        : [];

    return articlesList;
  }
}
