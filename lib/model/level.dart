class McqLevel {
  final String id;
  final int chapterId;
  final int levelType;
  final String description;
  final String word;
  final int isPassed;
  final int points;
  final int isReset;
  final int stars;

  const McqLevel(
      {required this.id,
      required this.levelType,
      required this.chapterId,
      required this.description,
      required this.isReset,
      required this.isPassed,
      required this.word,
      required this.stars,
      required this.points});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chapterId': chapterId,
      'description': description,
      'word': word,
      'isReset':isReset,
      'levelType': levelType,
      'isPassed': isPassed,
      'points': points,
      'stars': stars
    };
  }
}
