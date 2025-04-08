import 'package:flutter/material.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:funlish_app/utility/noti_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProgress extends ChangeNotifier {
  int level;
  int xp;
  int characterIndex;
  int hatIndex;
  int points;

  UserProgress(
      {this.level = 1,
      this.xp = 0,
      this.points = 0,
      this.characterIndex = 0,
      this.hatIndex = 0});

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
    characterIndex = character;
    hatIndex = hat;
    preferences.setInt("userCharacter", characterIndex);
    preferences.setInt("userHat", hatIndex);
    notifyListeners();
  }

  static Future<UserProgress> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    int savedLevel = prefs.getInt('userLevel') ?? 1;
    int savedXp = prefs.getInt('userXp') ?? 0;
    int points = prefs.getInt("userPoints") ?? 0;
    int character = prefs.getInt("userCharacter") ?? 0;
    int hat = prefs.getInt("userHat") ?? 0;

    return UserProgress(
        level: savedLevel,
        xp: savedXp,
        points: points,
        characterIndex: character,
        hatIndex: hat);
  }
}
