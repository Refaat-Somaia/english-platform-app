class Question {
  final int id;
  final String status;
  final String? sort;
  final String userCreated;
  final DateTime dateCreated;
  final String? userUpdated;
  final DateTime? dateUpdated;
  final String difficulty;
  final String text;
  final String answer;
  final List<String> options;

  Question({
    required this.id,
    required this.status,
    this.sort,
    required this.userCreated,
    required this.dateCreated,
    this.userUpdated,
    this.dateUpdated,
    required this.difficulty,
    required this.text,
    required this.answer,
    required this.options,
  });

  // Factory constructor to create an instance from JSON
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      status: json['status'],
      sort: json['sort'],
      userCreated: json['user_created'],
      dateCreated: DateTime.parse(json['date_created']),
      userUpdated: json['user_updated'],
      dateUpdated: json['date_updated'] != null
          ? DateTime.parse(json['date_updated'])
          : null,
      difficulty: json['difficulty'],
      text: json['text'],
      answer: json['answer'],
      options: List<String>.from(json['options']),
    );
  }

  // Method to convert the object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'sort': sort,
      'user_created': userCreated,
      'date_created': dateCreated.toIso8601String(),
      'user_updated': userUpdated,
      'date_updated': dateUpdated?.toIso8601String(),
      'difficulty': difficulty,
      'text': text,
      'answer': answer,
      'options': options,
    };
  }
}

class QuestionList {
  final List<Question> data;

  QuestionList({required this.data});

  factory QuestionList.fromJson(Map<String, dynamic> json) {
    return QuestionList(
      data: List<Question>.from(json['data'].map((q) => Question.fromJson(q))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((q) => q.toJson()).toList(),
    };
  }
}
