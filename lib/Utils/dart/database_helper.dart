
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:safe/Models/Contact.dart';   


class DataBaseHelper {
  static const _databaseName = "ContactDatabase.db";
  static const _databaseVersion = 1;


  //singleton constructor.
  DataBaseHelper._();
  static final DataBaseHelper instance = DataBaseHelper._();

  //Properties of the db
  Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDirectory.path, _databaseName);
    return await openDatabase(dbPath,
        version: _databaseVersion, onCreate: _onCreateDB);
  }

  Future _onCreateDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE ${Contact.tblContact}(
        ${Contact.colId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        ${Contact.colName} TEXT NOT NULL,
        ${Contact.colAmount} TEXT NOT NULL,
        ${Contact.colMobile} TEXT NOT NULL
      )   
    ''');
  }

//Insert function
  Future<int> insertContact(Contact contact) async {
    Database db = await database;
    return await db.insert(Contact.tblContact, contact.toMap());
  }

  //fetch function
  Future <List<Contact>> fetchContact() async {
    final Database db = await database;
    var response = await db.query(Contact.tblContact);
    List<Contact> list = response.isNotEmpty ? response.map((e) => Contact.fromMap(e)).toList() : [];
    return list;
  }

  // //fetch function
  // Future<List> fetchContact() async {
  //   Database db = await database;
  //   List<Map> contacts = await db.query(Contact.tblContact);
  //   return contacts.length == 0
  //       ? []
  //       : contacts.map((f) => Contact.fromMap(f)).toList();
  // }



  //UpDate function
  Future<int> updateContact(Contact contact) async {
    Database db = await database;
    return await db.update(Contact.tblContact, contact.toMap(),
        where: '${Contact.colId}=?', whereArgs: [contact.id]
    );
  }

  //Delete function
  Future<int> deleteContact(int id) async {
    Database db = await database;
    return await db.delete(Contact.tblContact,
        where: '${Contact.colId}=?', whereArgs: [id]);
  }

  Future<Contact> getContactByNum(String mobile) async {
    final db = await database;
    var result = await db.query("Contact", where: "colMobile = ?", whereArgs: [mobile]);
    return result.isNotEmpty ? Contact.fromMap(result.first) : null;
  }
}
