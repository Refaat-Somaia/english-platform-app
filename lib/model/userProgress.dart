import 'package:flutter/material.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:funlish_app/utility/noti_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProgress extends ChangeNotifier {
  int level;
  int xp;
  int characterIndex;
  int hatIndex;
  List<String> charactersList; // Made non-nullable
  List<String> hatsList; // Made non-nullable
  int points;

  UserProgress({
    this.level = 1,
    this.xp = 0,
    this.points = 0,
    List<String>? charactersList,
    List<String>? hatsList,
    this.characterIndex = 0,
    this.hatIndex = 0,
  })  : charactersList = charactersList ?? ["0"], // Default to only character 0
        hatsList = hatsList ?? ["0"];
  int xpForNextLevel() {
    int baseXp = 100;
    double growthFactor = 1.5;
    return (baseXp * (level * growthFactor)).toInt();
  }

  void addXP(int amount) async {
    xp += amount;
    points += amount;
    while (xp >= xpForNextLevel()) {
      xp -= xpForNextLevel();
      level++;
      final notiService = NotiService();

      notiService.showNotification(
        title: "Leveled Up!",
        body: "You have reached level $level, congratulations!",
      );
    }
    await saveProgress();

    notifyListeners();
  }

  Future<void> saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userLevel', level);
    await prefs.setInt('userXp', xp);

    await prefs.setInt('userPoints', points);
  }

  void changeAvatar(int character, int hat) {
    // Add validation to ensure the indices exist
    if (!charactersList.contains(character.toString())) {
      throw Exception("Character not unlocked");
    }
    if (!hatsList.contains(hat.toString())) {
      throw Exception("Hat not unlocked");
    }

    characterIndex = character;
    hatIndex = hat;
    preferences.setInt("characterIndex", characterIndex);
    preferences.setInt("hatIndex", hatIndex);
    notifyListeners();
  }

  void addCharacter(int index) {
    if (!charactersList.contains(index.toString())) {
      charactersList.add(index.toString());
      preferences.setStringList("charactersList", charactersList);
      notifyListeners();
    }
  }

  void addhat(int index) {
    if (!hatsList.contains(index.toString())) {
      hatsList.add(index.toString());
      preferences.setStringList("hatsList", hatsList);
      notifyListeners();
    }
  }

  static Future<UserProgress> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    return UserProgress(
      level: prefs.getInt('userLevel') ?? 1,
      xp: prefs.getInt('userXp') ?? 0,
      points: prefs.getInt("userPoints") ?? 0,
      characterIndex: prefs.getInt("characterIndex") ?? 0,
      hatIndex: prefs.getInt("hatIndex") ?? 0,
      charactersList: prefs.getStringList("charactersList") ?? ["0"],
      hatsList: prefs.getStringList("hatsList") ?? ["0"],
    );
  }
}
