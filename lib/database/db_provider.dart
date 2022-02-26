import 'dart:typed_data';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';

class DbProvider {
  DbProvider._privateConstructor();
  static final DbProvider instance = DbProvider._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ?? await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "items2.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) {
    return db.execute('''
    CREATE TABLE items2
          (
            id INTEGER AUTO INCREMENT PRIMARY KEY,
            name TEXT,
            buyPrice TEXT,
            sellPrice TEXT,
            imageURL TEXT,
            picture BLOB,
            quantity INTEGER
          )
    ''');
  }

  Future<List<Map<String, dynamic>>> getItems() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> items = await db.query('items2', orderBy: 'id');
    if (items.isNotEmpty) return items;
    return [];
  }

  Future<int> add(String url, Uint8List imageData, String name, String buyPrice,
      String sellPrice, int quantity) async {
    Database db = await instance.database;
    return await db.insert('items2', {
      'imageURL': url,
      'picture': imageData,
      'name': name,
      'buyPrice': buyPrice,
      'sellPrice': sellPrice,
      'quantity': quantity
    });
  }

  Future<int> delete(String name) async {
    Database db = await instance.database;
    return db.delete('items2', where: 'name=?', whereArgs: [name.toString()]);
  }

  Future<int> decreaseQuantity(String name) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> e =
        await db.query('items2', where: 'name=?', whereArgs: [name]);
    int quantity = e[0]['quantity'];
    if (quantity == 1) {
      return db.delete('items2', where: 'name=?', whereArgs: [name]);
    }
    return db.update('items2', {'quantity': quantity - 1},
        where: 'name=?', whereArgs: [name]);
  }

  Future<int> increaseQuantity(String name) async {
    print('shivanshu');
    Database db = await instance.database;
    List<Map<String, dynamic>> e =
        await db.query('items2', where: 'name=?', whereArgs: [name]);
    int quantity = e[0]['quantity'];
    print(quantity);
    return db.update('items2', {'quantity': quantity + 1},
        where: 'name=?', whereArgs: [name]);
  }
}
