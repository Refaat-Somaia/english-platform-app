class UserProfile {
  final int? id;
  final String? status;
  final int? sort;
  final String? userCreated;
  final DateTime? dateCreated;
  final String? userUpdated;
  final DateTime? dateUpdated;
  final int? leaderboardScore;
  final int? coursesTaken;
  final List<String>? interests;
  final int? points;
  final int? expPoints;
  final int? characterIndex;
  final int? hatIndex;
  final int? personalDetails;
  final int? englishLevel;
  final String? role;

  UserProfile({
    this.id,
    this.status,
    this.sort,
    this.userCreated,
    this.dateCreated,
    this.userUpdated,
    this.dateUpdated,
    this.leaderboardScore,
    this.coursesTaken,
    this.interests,
    this.points,
    this.expPoints,
    this.characterIndex,
    this.hatIndex,
    this.personalDetails,
    this.englishLevel,
    this.role,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      status: json['status'],
      sort: json['sort'],
      userCreated: json['user_created'],
      dateCreated: json['date_created'] != null
          ? DateTime.tryParse(json['date_created'])
          : null,
      userUpdated: json['user_updated'],
      dateUpdated: json['date_updated'] != null
          ? DateTime.tryParse(json['date_updated'])
          : null,
      leaderboardScore: json['leaderboard_score'],
      coursesTaken: json['courses_taken'],
      interests: json['interests'] != null
          ? List<String>.from(json['interests'])
          : null,
      points: json['points'],
      expPoints: json['exp_points'],
      characterIndex: json['character_index'],
      hatIndex: json['hat_index'],
      personalDetails: json['personal_details'],
      englishLevel: json['english_level'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'sort': sort,
      'user_created': userCreated,
      'date_created': dateCreated?.toIso8601String(),
      'user_updated': userUpdated,
      'date_updated': dateUpdated?.toIso8601String(),
      'leaderboard_score': leaderboardScore,
      'courses_taken': coursesTaken,
      'interests': interests,
      'points': points,
      'exp_points': expPoints,
      'character_index': characterIndex,
      'hat_index': hatIndex,
      'personal_details': personalDetails,
      'english_level': englishLevel,
      'role': role,
    };
  }
}
