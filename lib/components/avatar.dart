import 'package:flutter/cupertino.dart';

class Avatar extends StatefulWidget {
  final int characterIndex;
  final int hatIndex;
  final double width;
  const Avatar(
      {super.key,
      required this.characterIndex,
      required this.hatIndex,
      required this.width});

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  List<String> charctersPaths = [
    'assets/images/shop/characters/penguin-purple.png',
    'assets/images/shop/characters/penguin-pink.png',
    'assets/images/shop/characters/penguin-green.png',
    'assets/images/shop/characters/penguin-blue.png',
    'assets/images/shop/characters/penguin-yellow.png',
    'assets/images/shop/characters/hamter-purple.png',
    'assets/images/shop/characters/hamter-blue.png',
    'assets/images/shop/characters/hamter-yellow.png',
    'assets/images/shop/characters/hamter-green.png',
  ];
  List<String> hatsPaths = [
    'assets/images/shop/hats/winter-1.png',
    'assets/images/shop/hats/hat-1.png',
    'assets/images/shop/hats/hat-2.png',
    'assets/images/shop/hats/hat-3.png',
    'assets/images/shop/hats/hat-4.png',
    'assets/images/shop/hats/hat-5.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            charctersPaths[widget.characterIndex],
            width: widget.width,
          ),
          Image.asset(
            hatsPaths[widget.hatIndex],
            width: widget.width,
          ),
        ],
      ),
    );
  }
}
