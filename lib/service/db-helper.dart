import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';



class DatabaseHelper {
  static const _databaseName = "JswDatabase.db";
  static const _databaseVersion = 1;
  static const binningTable = 'binning_code_table';
  static const productDetailsTable = 'product_detail_table';//save data after audit

  static const binningId = 'id';
  static const productCode = 'productCode';
  static const locationCode = 'locationCode';
  static const dateTime = 'dateTime';



  static const productId = 'id';
  static const vendor = 'vendor';
  static const matDesc = 'matDesc';
  static const poNo = 'poNo';
  static const itemCode = 'itemCode';
  static const dept = 'dept';
  static const qty = 'qty';
  static const sieDate = 'sieDate';
  static const sieNo = 'sieNo';
  static const isProductChecked = 'isProductChecked';
  static const remark = 'remark';

  late Database _db;

  // this opens the database (and creates it if it doesn't exist)
  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }




  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $binningTable (
            $binningId INTEGER PRIMARY KEY,
            $productCode TEXT NOT NULL,
            $locationCode TEXT NOT NULL,
            $dateTime TEXT NOT NULL,
            UNIQUE ($productCode, $locationCode)
          )         
          ''');
    await db.execute('''
          CREATE TABLE $productDetailsTable (
  $productId INTEGER PRIMARY KEY,
  $productCode TEXT NOT NULL,
  $vendor TEXT NOT NULL,
  $matDesc TEXT NOT NULL,
  $poNo TEXT NOT NULL,
  $itemCode TEXT NOT NULL,
  $dept TEXT NOT NULL,
  $qty TEXT NOT NULL,
  $sieDate TEXT NOT NULL,
  $sieNo TEXT NOT NULL,
  $locationCode TEXT NOT NULL,
  $isProductChecked INTEGER NOT NULL,
  $remark TEXT NOT NULL,
  $dateTime TEXT NOT NULL,
  UNIQUE ($productCode, $locationCode)
  )       
  ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(dynamic row,table) async {
    print("row  $row");
    print("row.toMap() ${row.toMap()}");
    try{
      return await _db.insert(table, row.toMap());
    }catch(ex){
      return 0;
    }
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows(table) async {
    return await _db.query(table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount(table) async {
    final results = await _db.rawQuery('SELECT COUNT(*) FROM $table');
    return Sqflite.firstIntValue(results) ?? 0;
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row,table) async {
    int id = row[binningId];
    return await _db.update(
      table,
      row,
      where: '$binningId = ?',
      whereArgs: [id],
    );
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id,table) async {
    return await _db.delete(
      table,
      where: '$binningId = ?',
      whereArgs: [id],
    );
  }
}



















/*

openDbMethod() async {
  database = openDatabase(
      join(await getDatabasesPath(), 'code_database.db'),
  // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
  // Run the CREATE TABLE statement on the database.
  return db.execute(
  'CREATE TABLE jswCodes(id INTEGER PRIMARY KEY, productCode TEXT, locationCode TEXT,dateTime TEXT)',
  );
  },
// Set the version. This executes the onCreate function and provides a
// path to perform database upgrades and downgrades.
  version: 1,
  );
}

Future<void> insertCodes(CodeDataModel codes) async {
  // Get a reference to the database.
  final db = await database;
  print('codes insert ${codes.toJson()}');
  await db.insert(
    'jswCodes',
    codes.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

}

Future<List<CodeDataModel>> codes() async {

  print(await getDatabasesPath());
  print(await getApplicationDocumentsDirectory());
  // Get a reference to the database.
  final db = await database;

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query('jswCodes');


  return List.generate(maps.length, (i) {
    print("i :$i");
    print("maps.length :${maps.length}");
    return CodeDataModel(
      productCode: maps[i]['productCode'],
      locationCode: maps[i]['locationCode'],
      dateTime: maps[i]['dateTime'],
    );
  });
}*/
