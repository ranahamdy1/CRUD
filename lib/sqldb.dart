import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDb();
      return _db;
    } else {
      return _db;
    }
  }

  initialDb() async {
    String dataBasePath = await getDatabasesPath();
    String path = join(dataBasePath, 'nutrition.db');
    Database myDb = await openDatabase(path,
        onCreate: _onCreate, onUpgrade: _onUpgrade, version: 1);
    return myDb;
  }

  _onCreate(Database db, int version) async {
    await db.execute(''' 
    CREATE TABLE "tips" (
    "id" INTEGER  NOT NULL PRIMARY KEY  AUTOINCREMENT, 
    "day" TEXT NOT NULL,
    "tip" TEXT NOT NULL
    )
   ''');
    print('onCreate');
  }

  /*
     _onCreate(Database db, int version) async {
     Batch batch= db.Batch();
    batch.execute('''
    CREATE TABLE "tips" (
    "id" INTEGER  NOT NULL PRIMARY KEY  AUTOINCREMENT,
    "day" TEXT NOT NULL,
    "tips" TEXT NOT NULL
    )
   ''');
   batch.execute('''
    CREATE TABLE "notes" (
    "id" INTEGER  NOT NULL PRIMARY KEY  AUTOINCREMENT,
    "title" TEXT NOT NULL,
    "note" TEXT NOT NULL
    )
   ''');
   await batch.commit();
   print('onCreate');
  }
  */

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('onUpgrade');
  }

  readData(String sql) async {
    Database? myDb = await db;
    List<Map> response = await myDb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? myDb = await db;
    int response = await myDb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? myDb = await db;
    int response = await myDb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? myDb = await db;
    int response = await myDb!.rawDelete(sql);
    return response;
  }
}
