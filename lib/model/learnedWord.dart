class Learnedword {
  final String word;
  final String id;
  final String description;
  final String type;

  const Learnedword({
    required this.id,
    required this.word,
    required this.type,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'type': type,
      'description': description,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Learnedword &&
            runtimeType == other.runtimeType &&
            word == other.word &&
            description == other.description;
  }

  @override
  int get hashCode => word.hashCode ^ description.hashCode;
}
