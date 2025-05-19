class GameStat {
  final String id;
  final String gameName;
  final int wins;
  final int score;
  final int timesPlayed;

  GameStat({
    required this.id,
    required this.gameName,
    required this.wins,
    required this.score,
    required this.timesPlayed,
  });

  // Convert from a map (retrieved from DB) to GameStat object
  factory GameStat.fromMap(Map<String, dynamic> map) {
    return GameStat(
      id: map['id'],
      gameName: map['gameName'],
      wins: map['wins'],
      score: map['score'],
      timesPlayed: map['timesPlayed'],
    );
  }

  // Convert GameStat object to a map (for insert/update)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gameName': gameName,
      'wins': wins,
      'score': score,
      'timesPlayed': timesPlayed,
    };
  }
}
