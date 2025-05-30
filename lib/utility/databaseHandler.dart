import 'package:flutter/cupertino.dart';
import 'package:funlish_app/model/gamesStats.dart';
import 'package:funlish_app/model/learnedWord.dart';
import 'package:funlish_app/model/level.dart';
import 'package:funlish_app/model/powerUp.dart';
import 'package:funlish_app/utility/premadeData.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import '../model/Chapter.dart';

Database? database;

Future<void> openDB() async {
  if (database != null) {
    debugPrint("Database already opened.");
    return;
  }

  try {
    debugPrint("Opening database...");
    database = await openDatabase(
      join(await getDatabasesPath(), 'funlish.db'),
      version: 7,
      onCreate: (db, version) async {
        debugPrint("Creating tables...");
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
            arabicDescription TEXT,
            levelType INTEGER,
            stars INTEGER,
            isReset INTEGER,
            word TEXT,
            isPassed INTEGER,
            points INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE learnedWords (
            id TEXT PRIMARY KEY,
            word TEXT,
            type TEXT,
            description TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE powerUps (
            id TEXT PRIMARY KEY,
            name TEXT,
            game TEXT,
            price INTEGER,
            count INTEGER,
            description TEXT,
            iconPath TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE gamesStats (
            id TEXT PRIMARY KEY,
            gameName TEXT,
            wins INTEGER,
            score INTEGER,
            timesPlayed INTEGER
          )
        ''');

        debugPrint("Tables created.");
        await insertChapters(db);
        await insertMcqLevels(db);
        await insertDefaultPowerUps(db); // Ensure power-ups are preloaded
        await insertDefaultGamesStats(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 7) {}
      },
      onOpen: (db) async {
        debugPrint("Database is now open.");
      },
    );

    debugPrint("Database initialized successfully.");
  } catch (e) {
    debugPrint("Error initializing database: $e");
    throw Exception("Database initialization failed.");
  }
}

Future<void> insertDefaultGamesStats(Database db) async {
  final List<Map<String, dynamic>> gamesStats = await db.query('gamesStats');
  if (gamesStats.isEmpty) {
    await insertGameStats(
        db,
        GameStat(
            id: Uuid().v4(),
            gameName: "Word Puzzle",
            wins: 0,
            score: 0,
            timesPlayed: 0));
    await insertGameStats(
        db,
        GameStat(
            id: Uuid().v4(),
            gameName: "Bomb Relay",
            wins: 0,
            score: 0,
            timesPlayed: 0));
    await insertGameStats(
        db,
        GameStat(
            id: Uuid().v4(),
            gameName: "Castle Escape",
            wins: 0,
            score: 0,
            timesPlayed: 0));
    await insertGameStats(
        db,
        GameStat(
            id: Uuid().v4(),
            gameName: "Speedy Translator",
            wins: 0,
            score: 0,
            timesPlayed: 0));
    await insertGameStats(
        db,
        GameStat(
            id: Uuid().v4(),
            gameName: "Random",
            wins: 0,
            score: 0,
            timesPlayed: 0));
  }
}

Future<void> insertDefaultPowerUps(Database db) async {
  final List<Map<String, dynamic>> powerUps = await db.query('powerUps');
  if (powerUps.isEmpty) {
    await insertPowerUp(
        db,
        PowerUp(
            id: Uuid().v4(),
            count: 2,
            description:
                "In Bomb Relay, the bomb won't explode if you answered incorrectly.",
            game: "bombRelay",
            price: 200,
            iconPath: "assets/images/bomb.png",
            name: "Friendly Bomb"));
    await insertPowerUp(
        db,
        PowerUp(
            id: Uuid().v4(),
            count: 2,
            price: 200,
            game: "wordPuzzle",
            iconPath: "assets/images/puzzle.png",
            description: "In Word Puzzle, unlock half of the word's letters.",
            name: "Puzzle Hint"));
    await insertPowerUp(
        db,
        PowerUp(
            id: Uuid().v4(),
            count: 2,
            game: "all",
            price: 200,
            iconPath: "assets/images/clock.png",
            description:
                "Extend the time in time-based games (when activated, time is extended for all players).",
            name: "Extended Time"));
    await insertPowerUp(
        db,
        PowerUp(
            id: Uuid().v4(),
            count: 2,
            price: 200,
            game: "castleEscape",
            iconPath: "assets/images/key.png",
            description:
                "In Castle Escape, escape the current room with a key.",
            name: "Secret Key"));
    await insertPowerUp(
        db,
        PowerUp(
            id: Uuid().v4(),
            count: 2,
            price: 200,
            game: "castleEscape",
            iconPath: "assets/images/lock.png",
            description:
                "In Castle Escape, add another question to other players.",
            name: "Additional Lock"));
  }
}

Future<int> updateGameStat(GameStat gameStat) async {
  final db = await database;

  return await db!.update(
    'gamesStats',
    gameStat.toMap(),
    where: 'id = ?',
    whereArgs: [gameStat.id],
  );
}

Future<GameStat?> getGameStatByIGame(String id) async {
  final db = await database;

  final List<Map<String, dynamic>> maps = await db!.query(
    'gamesStats',
    where: 'gameName = ?',
    whereArgs: [id],
  );

  if (maps.isNotEmpty) {
    return GameStat.fromMap(maps.first);
  } else {
    return null;
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

Future<void> insertGameStats(Database db, GameStat gameStat) async {
  await db.insert(
    'gamesStats',
    {
      'id': gameStat.id,
      'gameName': gameStat.gameName,
      'wins': gameStat.wins,
      "timesPlayed": gameStat.timesPlayed,
      "score": gameStat.score,
    },
    conflictAlgorithm: ConflictAlgorithm.replace, // Prevents duplicate IDs
  );
}

Future<void> insertPowerUp(Database db, PowerUp powerUp) async {
  await db.insert(
    'powerUps',
    {
      'id': powerUp.id,
      'description': powerUp.description,
      'name': powerUp.name,
      "iconPath": powerUp.iconPath,
      "price": powerUp.price,
      'game': powerUp.game,
      'count': powerUp.count
    },
    conflictAlgorithm: ConflictAlgorithm.replace, // Prevents duplicate IDs
  );
}

Future<List<PowerUp>> getPowerUpsFromDB() async {
  final db = await database;

  final List<Map<String, dynamic>> maps = await db!.query('powerUps');

  return List.generate(maps.length, (i) {
    return PowerUp(
        id: maps[i]["id"],
        count: maps[i]["count"],
        price: maps[i]["price"],
        iconPath: maps[i]["iconPath"],
        description: maps[i]["description"],
        game: maps[i]["game"],
        name: maps[i]["name"]);
  });
}

Future<List<PowerUp>> getPowerUpsOfGame(String gameName) async {
  final db = await database;

  final List<Map<String, dynamic>> maps = await db!.query('powerUps',
      where: "game = ? OR game = 'all'", whereArgs: [gameName]);

  return List.generate(maps.length, (i) {
    return PowerUp(
        id: maps[i]["id"],
        count: maps[i]["count"],
        price: maps[i]["price"],
        iconPath: maps[i]["iconPath"],
        description: maps[i]["description"],
        game: maps[i]["game"],
        name: maps[i]["name"]);
  });
}

Future<void> updatePowerUp(String id, int newCount) async {
  final db = await database;
  await db!.update(
    'powerUps',
    {'count': newCount},
    where: 'id = ?',
    whereArgs: [id],
  );
}

Future<void> insertMcqLevels(Database db) async {
  try {
    final List<Map<String, dynamic>> existingMcqLevels =
        await db.query('mcqLevels');

    if (existingMcqLevels.isEmpty) {
      predefinedMcqLevels.shuffle();
      for (var McqLevel in predefinedMcqLevels) {
        await db.insert(
          'mcqLevels',
          {
            'id': McqLevel.id,
            'chapterId': McqLevel.chapterId,
            'description': McqLevel.description,
            'word': McqLevel.word,
            'arabicDescription': McqLevel.arabicDescription,
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

Future<List<Learnedword>> getLearnedWordsFromDB() async {
  if (database == null) {
    throw Exception("Database is not initialized. Call openDB() first.");
  }

  final db = database;
  final List<Map<String, dynamic>> maps = await db!.query('learnedWords');

  return List.generate(maps.length, (i) {
    return Learnedword(
      id: maps[i]['id'],
      word: maps[i]['word'],
      description: maps[i]['description'],
      type: maps[i]['type'],
    );
  });
}

Future<void> addLearnedWordsToDB(Learnedword learnedWord) async {
  if (database == null) {
    throw Exception("Database is not initialized. Call openDB() first.");
  }

  final db = database;
  await db!.insert(
      'learnedWords',
      conflictAlgorithm: ConflictAlgorithm.replace,
      learnedWord.toMap());
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

Future<void> updateLearedWordInDB(Learnedword learnedWord) async {
  // Get a reference to the database.
  final db = await database;

  // Update the given Dog.
  await db!.update(
    'learnedWords',
    learnedWord.toMap(),
    // Ensure that the Dog has a matching id.
    where: 'id = ?',
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [learnedWord.id],
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
  List<McqLevel> list = [
    for (final {
          'id': id as String,
          'word': word as String,
          'chapterId': chapterId as int,
          'description': description as String,
          'arabicDescription': arabicDescription as String,
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
        arabicDescription: arabicDescription,
        stars: stars,
        points: points,
        isPassed: isPassed,
        chapterId: chapterId,
      ),
  ];

  return list;
}

Future<void> deleteDatabaseFile() async {
  final dbPath = join(await getDatabasesPath(), 'funlish_app.db');
  await deleteDatabase(dbPath);
  debugPrint("Database deleted!");
}

Future<void> clearDatabase() async {
  final db = await database;

  await db?.delete("chapters");
  await db?.delete("gamesStats");
  await db?.delete("powerUps");
  await db?.delete("learnedWords");
  await db?.delete("mcqLevels");
}
