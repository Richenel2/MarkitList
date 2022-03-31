import 'package:sqflite/sqflite.dart';

import '../database/database.dart';

class Article {
  int? id;
  String name;
  int price;
  bool isBuy;
  int amount;
  int liste;

  Article({
    this.id,
    required this.name,
    required this.liste,
    this.price = 0,
    this.isBuy = false,
    this.amount = 1,
  });

  factory Article.fromMap(Map<String, dynamic> json) => Article(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        isBuy: json['isBuy'] == 0 ? false : true,
        liste: json['liste'],
        amount: json['amount'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'isBuy': isBuy,
      'liste': liste,
      'amount': amount,
    };
  }

  Future save() async {
    Database db = await MyDatabase.instance.database;
    id = await db.insert('Article', toMap());
  }

  Future delete() async {
    Database db = await MyDatabase.instance.database;
    id = await db.delete('Article', where: "id=?", whereArgs: [id]);
  }

  Future update() async {
    Database db = await MyDatabase.instance.database;
    db.update('Article', toMap(), where: "id=?", whereArgs: [id]);
  }
}
