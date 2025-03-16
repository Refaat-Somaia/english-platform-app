import 'package:flutter/cupertino.dart';
import 'package:funlish_app/model/level.dart';
import 'package:funlish_app/utility/premadeData.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import '../model/Chapter.dart';
import 'global.dart';

Database? database;

Future<void> openDB() async {
  if (database != null) {
    // Database already initialized
    debugPrint("Database already opened.");
    return;
  }

  try {
    debugPrint("Opening database...");
    database = await openDatabase(
      join(await getDatabasesPath(), 'funlish.db'),
      version: 1,
      onCreate: (db, version) async {
        // Create necessary tables
        await db.execute('''
  CREATE TABLE chapters (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    levelCount INTEGER,
    levelsPassed INTEGER,
    starsCollected INTEGER,
    pointsCollected INTEGER,
    color INTEGER
  )
''');
        await db.execute('''
CREATE TABLE mcqLevels (
    id TEXT PRIMARY KEY,
    chapterId INTEGER NOT NULL,
    description TEXT,
    levelType INTEGER,
    stars INTEGER,
    isReset INTEGER,
    word TEXT,
    isPassed INTEGER,
    points INTEGER
    )
''');

        debugPrint("Tables created.");
      },
      onOpen: (db) async {
        debugPrint("Database is now open.");
        await insertChapters(db); // Ensure this runs only after initialization
        await insertMcqLevels(db); // Ensure this runs only after initialization
      },
    );
    debugPrint("Database initialized successfully.");
  } catch (e) {
    debugPrint("Error initializing database: $e");
    throw Exception("Database initialization failed.");
  }
}

Future<void> insertChapters(Database db) async {
  try {
    final List<Map<String, dynamic>> existingChapters =
        await db.query('chapters');

    if (existingChapters.isEmpty) {
      for (var chapter in predefinedChapters) {
        await db.insert(
          'chapters',
          {
            'name': chapter.name,
            'description': chapter.description,
            'levelCount': chapter.levelCount,
            'levelsPassed': chapter.levelsPassed,
            'color': chapter.color,
            'pointsCollected': chapter.pointsCollected,
            'starsCollected': chapter.starsCollected
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      debugPrint("Predefined chapters inserted successfully.");
    } else {
      debugPrint("Chapters already exist. Skipping insertion.");
    }
  } catch (e) {
    debugPrint("Error inserting chapters: $e");
    throw Exception("Failed to insert chapters.");
  }
}

Future<void> insertMcqLevels(Database db) async {
  try {
    final List<Map<String, dynamic>> existingMcqLevels =
        await db.query('mcqLevels');

    if (existingMcqLevels.isEmpty) {
      for (var McqLevel in predefinedMcqLevels) {
        await db.insert(
          'mcqLevels',
          {
            'id': McqLevel.id,
            'chapterId': McqLevel.chapterId,
            'description': McqLevel.description,
            'word': McqLevel.word,
            'levelType': McqLevel.levelType,
            'points': McqLevel.points,
            'isReset': McqLevel.isReset,
            'isPassed': McqLevel.isPassed,
            'stars': McqLevel.stars
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      debugPrint("Predefined levels inserted successfully.");
    } else {
      debugPrint("levels already exist. Skipping insertion.");
    }
  } catch (e) {
    debugPrint("Error inserting chapters: $e");
    throw Exception("Failed to insert chapters.");
  }
}

Future<List<String>> getWordsByChapterId(int chapterId) async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db!.query(
    'mcqLevels',
    columns: ['word'], // Only select the 'word' column
    where: 'chapterId = ?',
    whereArgs: [chapterId],
  );

  // Return all the words as a list
  return List.generate(maps.length, (i) {
    return maps[i]['word'] as String;
  });
}

Future<List<Chapter>> getChaptersFromDB() async {
  if (database == null) {
    throw Exception("Database is not initialized. Call openDB() first.");
  }

  final db = database;
  final List<Map<String, dynamic>> maps = await db!.query('chapters');

  return List.generate(maps.length, (i) {
    return Chapter(
      id: maps[i]['id'],
      name: maps[i]['name'],
      starsCollected: maps[i]['starsCollected'],
      pointsCollected: maps[i]['pointsCollected'],
      description: maps[i]['description'],
      levelCount: maps[i]['levelCount'],
      levelsPassed: maps[i]['levelsPassed'],
      color: maps[i]['color'],
    );
  });
}

Future<void> updateChapterInDB(Chapter chapter) async {
  // Get a reference to the database.
  final db = await database;

  // Update the given Dog.
  await db!.update(
    'chapters',
    chapter.toMap(),
    // Ensure that the Dog has a matching id.
    where: 'id = ?',
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [chapter.id],
  );
}

Future<void> updateMcqLevelInDB(McqLevel level) async {
  // Get a reference to the database.
  final db = await database;

  // Update the given Dog.
  await db!.update(
    'mcqLevels',
    level.toMap(),
    // Ensure that the Dog has a matching id.
    where: 'id = ?',
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [level.id],
  );
}

Future<List<McqLevel>> getMcqLevelsOfChapter(int chapterId) async {
  final db = await database;

  final List<Map<String, Object?>> levelsMap = await db!.query(
    'mcqLevels',
    where: 'chapterId = ?',
    whereArgs: [chapterId],
  );

  return [
    for (final {
          'id': id as String,
          'word': word as String,
          'chapterId': chapterId as int,
          'description': description as String,
          'stars': stars as int,
          'levelType': levelType as int,
          'isPassed': isPassed as int,
          'points': points as int,
          'isReset': isReset as int
        } in levelsMap)
      McqLevel(
        id: id,
        word: word,
        levelType: levelType,
        description: description,
        isReset: isReset,
        stars: stars,
        points: points,
        isPassed: isPassed,
        chapterId: chapterId,
      ),
  ];
}

Future<void> deleteDatabaseFile() async {
  final dbPath = join(await getDatabasesPath(), 'funlish_app.db');
  await deleteDatabase(dbPath);
  debugPrint("Database deleted!");
}
