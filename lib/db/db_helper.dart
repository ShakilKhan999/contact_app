import 'package:contact_app/models/contact_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const String createTableContact = ''' create table $tableContact(
  $tableContactColId integer primary key ,
  $tableContactColName text,
  $tableContactColNumber text,
  $tableContactColEmail text,
  $tableContactColAddress text,
  $tableContactColdob text,
  $tableContactColimage text,
  $tableContactColwebsite text,
  $tableContactColFavorite integer,
  $tableContactColGender text
  
  )''';

  static Future<Database> open() async {
    final rootpath = await getDatabasesPath();
    final dbpath = join(rootpath, 'contact.db');
    return openDatabase(dbpath, version: 2, onCreate: (db, version) {
      db.execute(createTableContact);
    },onUpgrade: (db,oldVersion,newVersion){
      if(newVersion == 2){
        db.execute('alter table $tableContact  add column $tableContactColwebsite');
      }
    });
  }

  static Future<int> insertContact(ContactModel contactModel) async {
    final db = await open();
    return db.insert(tableContact, contactModel.toMap());
  }

  static Future<List<ContactModel>> getAllContacts() async {
    final db = await open();
    final List<Map<String, dynamic>> mapList = await db.query(tableContact);
    return List.generate(
        mapList.length, (index) => ContactModel.fromMap(mapList[index]));
  }
  static Future<List<ContactModel>> getAllFavoriteContacts() async {
    final db = await open();
    final List<Map<String, dynamic>> mapList = await db.query(tableContact,where: '$tableContactColFavorite =?',whereArgs: [1]);
    return List.generate(
        mapList.length, (index) => ContactModel.fromMap(mapList[index]));
  }

  static Future<ContactModel> getContactsById(int id) async {
    final db = await open();
    final mapList = await db
        .query(tableContact, where: '$tableContactColId = ?', whereArgs: [id]);
    return ContactModel.fromMap(mapList.first);
  }

  static Future<int> updateFavorite(int id, int value) async {
    final db = await open();
    return db.update(tableContact, {tableContactColFavorite: value},
        where: '$tableContactColId=?', whereArgs: [id]);
  }
  static Future<int> deleteContact(int id) async{
    final db= await open();
    return db.delete(tableContact, where: '$tableContactColId = ?', whereArgs: [id]);

  }
}
