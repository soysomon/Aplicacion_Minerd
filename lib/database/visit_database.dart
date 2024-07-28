import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/visit.dart';

class VisitDatabase {
  static final VisitDatabase instance = VisitDatabase._init();

  static Database? _database;

  VisitDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('visits.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';

    await db.execute('''
    CREATE TABLE $tableVisits ( 
      ${VisitFields.id} $idType, 
      ${VisitFields.directorId} $textType,
      ${VisitFields.centerCode} $textType,
      ${VisitFields.reason} $textType,
      ${VisitFields.photoPath} $textType,
      ${VisitFields.audioPath} $textType,
      ${VisitFields.latitude} $doubleType,
      ${VisitFields.longitude} $doubleType,
      ${VisitFields.date} $textType,
      ${VisitFields.time} $textType,
      ${VisitFields.comment} $textType
    )
    ''');
  }

  Future<Visit> create(Visit visit) async {
    final db = await instance.database;

    final id = await db.insert(tableVisits, visit.toJson());
    return visit.copy(id: id);
  }

  Future<Visit?> readVisit(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableVisits,
      columns: VisitFields.values,
      where: '${VisitFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Visit.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Visit>> readAllVisits() async {
    final db = await instance.database;

    final orderBy = '${VisitFields.date} ASC';

    final result = await db.query(tableVisits, orderBy: orderBy);

    return result.map((json) => Visit.fromJson(json)).toList();
  }

  Future<int> update(Visit visit) async {
    final db = await instance.database;

    return db.update(
      tableVisits,
      visit.toJson(),
      where: '${VisitFields.id} = ?',
      whereArgs: [visit.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableVisits,
      where: '${VisitFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}

class VisitFields {
  static final List<String> values = [
    id, directorId, centerCode, reason, photoPath, audioPath, latitude, longitude, date, time, comment
  ];

  static const String id = '_id';
  static const String directorId = 'directorId';
  static const String centerCode = 'centerCode';
  static const String reason = 'reason';
  static const String photoPath = 'photoPath';
  static const String audioPath = 'audioPath';
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';
  static const String date = 'date';
  static const String time = 'time';
  static const String comment = 'comment';
}

const String tableVisits = 'visits';
