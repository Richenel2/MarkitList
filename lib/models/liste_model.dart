import 'package:markit_list/database/database.dart';
import 'package:sqflite/sqflite.dart';

class Liste {
  int? id;
  String name;
  int price;
  bool isFinish;
  bool isImportant;
  DateTime? creationDate;

  Liste(
      {this.id,
      required this.name,
      this.price = 0,
      this.isFinish = false,
      this.isImportant = false,
      this.creationDate});

  factory Liste.fromMap(Map<String, dynamic> json) => Liste(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        isFinish: json['isFinish'] == 0 ? false : true,
        isImportant: json['isImportant'] == 0 ? false : true,
        creationDate: DateTime.parse(json['creationDate'].toString()),
      );

  Map<String, dynamic> toMap() {
    creationDate ??= DateTime.now();
    return {
      'id': id,
      'name': name,
      'price': price,
      'isFinish': isFinish,
      'isImportant': isImportant,
      'creationDate': creationDate.toString(),
    };
  }

  Future save() async {
    creationDate ??= DateTime.now();
    Database db = await MyDatabase.instance.database;
    id = await db.insert('Liste', {
      'name': name,
      'creationDate': creationDate.toString(),
    });
  }

  Future delete() async {
    Database db = await MyDatabase.instance.database;
    await db.delete('Liste', where: "id=?", whereArgs: [id]);
  }

  Future updatePrice() async {
    Database db = await MyDatabase.instance.database;
    var result =
        await db.rawQuery("SELECT SUM(price) FROM Article Where liste=$id");
    try {
      price = int.parse((result[0]["SUM(price)"]).toString());
    } on Exception {
      price = 0;
    }
    db.update('Liste', toMap(), where: "id=?", whereArgs: [id]);
  }
  
  Future update() async {
    Database db = await MyDatabase.instance.database;
    db.update('Liste', toMap(), where: "id=?", whereArgs: [id]);
  }
}
