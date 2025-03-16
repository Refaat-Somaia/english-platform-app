class Comment {
  String text;
  String id;
  String threadId;
  String userName;
  int commentCount;
  int likeCount;
  DateTime date;
  bool isReported;
  Comment(
      {required this.text,
      required this.id,
      required this.threadId,
      required this.userName,
      required this.commentCount,
      required this.likeCount,
      required this.date,
      required this.isReported});
}
