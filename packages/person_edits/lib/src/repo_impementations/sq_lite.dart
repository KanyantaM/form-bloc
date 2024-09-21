import 'package:path/path.dart';
import 'package:person_edits/src/repo.dart';
import 'package:sqflite/sqflite.dart';
import '../../person_edits.dart';

class SQLitePersonRepo implements PersonRepo {
  // Ensure that the database is only initialized once.
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  // Initialize the database and ensure versioning and migrations are handled properly.
  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'person.db');
    return await openDatabase(
      path,
      version: 10,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE persons('
          'id TEXT PRIMARY KEY, '
          'fullName TEXT, '
          'email TEXT, '
          'phoneNumber TEXT, '
          'country TEXT, '
          'city TEXT, '
          'postalCode TEXT, '
          'preferences TEXT, '
          'synced INTEGER)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 10) {
          // Add missing column if it doesn't exist
          await db.execute('ALTER TABLE persons ADD COLUMN email TEXT');
        }
      },
    );
  }

  // Save a new person in the database.
  @override
  Future<bool> savingPerson(Person newPerson) async {
    try {
      final db = await database;
      int result = await db.insert(
        'persons',
        newPerson.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return result > 0;
    } catch (e) {
      print('Error saving person: $e');
      return false;
    }
  }

  // Fetch a person by their ID.
  @override
  Future<Person> fetchPersonFromDataBase(String key) async {
    try {
      final db = await database;
      List<Map<String, dynamic>> maps = await db.query(
        'persons',
        where: 'id = ?',
        whereArgs: [key],
      );

      if (maps.isNotEmpty) {
        return Person.fromJson(maps.first);
      } else {
        throw Exception('Person not found');
      }
    } catch (e) {
      print('Error fetching person: $e');
      rethrow;
    }
  }

  // Update an existing person.
  @override
  Future<void> updatePerson(Person person) async {
    try {
      final db = await database;
      await db.update(
        'persons',
        person.toJson(),
        where: 'id = ?',
        whereArgs: [person.id],
      );
    } catch (e) {
      print('Error updating person: $e');
    }
  }

  // Delete a person by their ID.
  @override
  Future<bool> deletePerson(String key) async {
    try {
      final db = await database;
      int result = await db.delete(
        'persons',
        where: 'id = ?',
        whereArgs: [key],
      );
      return result > 0;
    } catch (e) {
      print('Error deleting person: $e');
      return false;
    }
  }

  // Fetch unsynced persons from the database.
  Future<List<Person>> fetchUnsyncedPersons() async {
    try {
      final db = await database;
      List<Map<String, dynamic>> maps = await db.query(
        'persons',
        where: 'synced = ?',
        whereArgs: [0],
      );
      return List.generate(maps.length, (i) => Person.fromJson(maps[i]));
    } catch (e) {
      print('Error fetching unsynced persons: $e');
      return [];
    }
  }
}
