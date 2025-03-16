import 'package:flutter/material.dart';

class Chapter {
  final int id;
  final String name;
  final String description;
  final int levelCount;
  final int levelsPassed;
  final int pointsCollected;
  final int starsCollected;
  final int color;

  const Chapter(
      {required this.id,
      required this.name,
      required this.description,
      required this.levelCount,
      required this.pointsCollected,
      required this.starsCollected,
      required this.levelsPassed,
      required this.color});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'levelCount': levelCount,
      'pointsCollected': pointsCollected,
      'starsCollected': starsCollected,
      'levelsPassed': levelsPassed,
      'color': color,
    };
  }

  Color get colorAsColor => Color(color);
}
