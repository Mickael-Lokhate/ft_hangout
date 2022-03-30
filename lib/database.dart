import 'package:ft_hangout/models/config.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

import 'models/contact.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    return await openDatabase(
    path.join(await getDatabasesPath(), 'contacts.db'),
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE contacts(id INTEGER PRIMARY KEY, name TEXT, phonenumber TEXT, lastname TEXT, email TEXT, imageUrl TEXT, moreInfos TEXT)'
      );
    },
    version: 1
    );
  }

  insertContact(Contact newContact) async {
    final db = await database;
    var res = await db.insert(
      'contacts', 
      newContact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort
    );
    return res;
  }

  Future<List<Contact>> getContacts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('contacts');
    if (maps.isEmpty) {
      return [];
    }
    return List.generate(
      maps.length,
      (i) => Contact(
        maps[i]['id'],
        maps[i]['name'],
        maps[i]['phonenumber'],
        maps[i]['lastname'],
        maps[i]['email'],
        maps[i]['imageUrl'],
        maps[i]['moreInfos'],
      )
    );
  }

 getContact(int id) async {
  final db = await database;
  final List<Map<String, dynamic>> map = await db.query('contacts', where: 'id = ?', whereArgs: [id]);
  if (map.isNotEmpty){
    return Contact(
      map[0]['id'],
      map[0]['name'],
      map[0]['phonenumber'],
      map[0]['lastname'],
      map[0]['email'],
      map[0]['imageUrl'],
      map[0]['moreInfos'],
    );
  }
    return null;
  }

  updateContact(Contact toUpdate) async {
    final db = await database;
    var res = await db.update(
      'contacts',
      toUpdate.toMap(),
      where: 'id = ?',
      whereArgs: [toUpdate.id]
    );
    return res;
  }

  deleteContact(int id) async {
    final db = await database;
    await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }

  deleteAllContact() async {
    final db = await database;
    db.rawDelete("DELETE FROM contacts");
  }
}

