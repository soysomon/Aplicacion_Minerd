// lib/database/incident_database.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/incident.dart';
import 'incident_fields.dart';

class IncidentDatabase {
  static final IncidentDatabase instance = IncidentDatabase._init();

  static Database? _database;

  IncidentDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('incidents.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE $tableIncidents ( 
      ${IncidentFields.id} $idType, 
      ${IncidentFields.title} $textType,
      ${IncidentFields.center} $textType,
      ${IncidentFields.regional} $textType,
      ${IncidentFields.district} $textType,
      ${IncidentFields.date} $textType,
      ${IncidentFields.description} $textType,
      ${IncidentFields.photoPath} $textType,
      ${IncidentFields.audioPath} $textType
    )
    ''');
  }

  Future<void> deleteAll() async {
    final db = await instance.database;
    await db.delete(tableIncidents);
  }

  Future<Incident> create(Incident incident) async {
    final db = await instance.database;
    final id = await db.insert(tableIncidents, incident.toJson());
    return incident.copy(id: id);
  }

  Future<List<Incident>> readAllIncidents() async {
    final db = await instance.database;
    const orderBy = '${IncidentFields.date} ASC';
    final result = await db.query(tableIncidents, orderBy: orderBy);
    return result.map((json) => Incident.fromJson(json)).toList();
  }

  Future<int> update(Incident incident) async {
    final db = await instance.database;
    return db.update(
      tableIncidents,
      incident.toJson(),
      where: '${IncidentFields.id} = ?',
      whereArgs: [incident.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return db.delete(
      tableIncidents,
      where: '${IncidentFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
