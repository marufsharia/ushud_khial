import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../data/models/medicine_model.dart';
import '../config/constants.dart';

class MedicineDB {
  static final MedicineDB instance = MedicineDB._init();
  static Database? _database;

  MedicineDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(AppConstants.dbName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textNullableType = 'TEXT';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE ${AppConstants.dbTable} (
      id $idType,
      name $textType,
      dosage $textType,
      frequency $intType,
      times $textType,
      startDate $intType,
      endDate $intType,
      isActive $intType,
      doctorName $textNullableType,
      doctorContact $textNullableType,
      color $intType,
      currentStock $intType,
      refillThreshold $intType
    )
    ''');
  }

  Future<MedicineModel> create(MedicineModel medicine) async {
    final db = await instance.database;
    final id = await db.insert(AppConstants.dbTable, medicine.toMap());
    return medicine.copyWith(id: id);
  }

  Future<MedicineModel> readMedicine(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      AppConstants.dbTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return MedicineModel.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<MedicineModel>> readAllMedicines() async {
    final db = await instance.database;
    final result = await db.query(AppConstants.dbTable, orderBy: 'id DESC');
    return result.map((json) => MedicineModel.fromMap(json)).toList();
  }

  Future<int> update(MedicineModel medicine) async {
    final db = await instance.database;
    return db.update(
      AppConstants.dbTable,
      medicine.toMap(),
      where: 'id = ?',
      whereArgs: [medicine.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      AppConstants.dbTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
