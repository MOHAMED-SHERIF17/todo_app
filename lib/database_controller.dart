import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled10/constants.dart';
import 'package:untitled10/info_model.dart';

class DatabaseController{
  //singleton(only instance to use)  طريقه كتابه بتساعدني لحل مشكله معينهه
  // objectmember   يتواجد اكتر من مره VS classmember    يتواجد مره واحده   object
  static final DatabaseController instance = DatabaseController._init();
  DatabaseController._init();

   static Database? _database;

   Future<Database>? get database async{
     if(_database != null)
       return _database!;
     _database = await initDB();
     return _database!;
  }

  Future<Database> initDB() async{
     String path = join(await getDatabasesPath(), 'InfoDatabase.db');
     return await openDatabase(path, version: 1, onCreate: _onCreate);
  }
  // CREATE TABLE t1(a, b PRIMARY KEY)
  Future<void> _onCreate(Database? db, int? version)  async {

     db!.execute('''
     CREATE TABLE $infoTable (
     $columnId $idType,
     $columnName $textTybe,
     $columnPhone $textTybe,
     $columnEmail $textTybe
     )
     ''');

}
/// CRUD OPERATION (CREATE - READ - UPDATE - DELETE)

/// CREATE
  Future<void> insertInfo(InfoModel info ) async{
     final db = await instance.database;
     db!.insert(
       infoTable,
     info.toDB(),
       conflictAlgorithm: ConflictAlgorithm.replace,
     );

  }
  /// READ
  Future<List<InfoModel>> readAllInfo() async{
     final db = await instance.database;
     List<Map<String, dynamic>> data = await db!.query(infoTable);

     return data.isNotEmpty ? data.map((elemnt) => InfoModel.fromDB(elemnt)).toList() : [];
  }
  Future<InfoModel?> readOneInfo(int id) async{
    final db = await instance.database;
    List<Map<String, dynamic>> data = await db!.query(
        infoTable,
      where: '$columnId = ?',
        whereArgs: [id],
    );
    return data.isNotEmpty
        ? InfoModel.fromDB(data.first)
        : throw Exception('Id $id is not found');

  }
  ///UPDATE
  Future<void> editInfo(InfoModel info) async{
    final db = await instance.database;
    db!.update(
        infoTable,
      info.toDB(),
      where: '$columnId = ?',
      whereArgs: [info.id],
    );
  }
  ///DELETE
  Future<void> deleteInfo(int id ) async{
    final db = await instance.database;
    db!.delete(
      infoTable,
      where: 'columnId = ?',
        whereArgs: [id]
    );

  }

}
