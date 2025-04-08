class PowerUp {
  String id;
  String name;
  String game;
  int count;
  int price;
  String iconPath;
  String description;
  PowerUp(
      {required this.id,
      required this.price,
      required this.count,
      required this.iconPath,
      required this.description,
      required this.game,
      required this.name});
}
