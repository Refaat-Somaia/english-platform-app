import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:funlish_app/mainPages/games/gameIntro.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class Games extends StatefulWidget {
  const Games({super.key});

  @override
  State<Games> createState() => _GamesState();
}

class _GamesState extends State<Games> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bodyColor,
        body: Animate(
          child: SizedBox(
            width: 100.w,
            height: 94.h,
            child: SingleChildScrollView(
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      "assets/images/circle-top-right.png",
                      width: 20.w,
                    ),
                  ],
                ),
                setText("Funlish games", FontWeight.w600, 17.sp, fontColor),
                setText("Practice your English in a competitive way!",
                    FontWeight.w500, 14.sp, fontColor.withOpacity(0.6)),
                SizedBox(height: 5.h),
                SizedBox(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 92.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buttonOfMenu(
                                const Color.fromARGB(255, 48, 79, 139),
                                "assets/animations/castle.json",
                                "Castle Escape",
                                500.ms,
                                1),
                            buttonOfMenu(
                                Color.fromARGB(255, 235, 140, 50),
                                "assets/animations/bomb.json",
                                "Bomb Relay",
                                600.ms,
                                2),
                          ],
                        ),
                      ),
                      SizedBox(height: 2.h),
                      SizedBox(
                        width: 92.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buttonOfMenu(
                                Color.fromARGB(255, 35, 118, 105),
                                "assets/images/translate.png",
                                "Speedy Translator",
                                800.ms,
                                3),
                            buttonOfMenu(
                                const Color.fromARGB(255, 90, 63, 151),
                                "assets/animations/puzzle.json",
                                "Word Puzzle",
                                1000.ms,
                                4),
                          ],
                        ),
                      ),
                      SizedBox(height: 2.h),
                      SizedBox(
                        width: 92.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buttonOfMenu(
                                Color(0xff32356D),
                                "assets/animations/dice.json",
                                "Random",
                                800.ms,
                                5),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Animate(
                  child: Container(
                    width: 90.w,
                    height: 7.h,
                    decoration: BoxDecoration(
                        color: primaryPurple,
                        borderRadius: BorderRadius.circular(16)),
                    child: TextButton(
                      style: buttonStyle(14),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.leaderboard_rounded,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          setText("Leaderboard", FontWeight.w600, 15.sp,
                              Colors.white),
                        ],
                      ),
                    ),
                  ),
                ).fadeIn(begin: 0, delay: 700.ms, duration: 500.ms),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    Image.asset(
                      "assets/images/circle-bottom.png",
                      width: 25.w,
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ).fadeIn(duration: 400.ms));
  }

  Widget buttonOfMenu(Color color, String path, String text, duration,
      [index]) {
    return Animate(
      child: Container(
        width: 44.w,
        height: 22.h,
        // decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(16),
        //     border: Border.all(
        //       color: fontColor.withOpacity(0.2),
        //       width: 2,
        //     ),
        // color: bodyColor),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 243, 243, 243).withOpacity(
                  preferences.getBool("isDarkMode") == true ? 0 : 0.3),
              spreadRadius: 0.01.h,
              blurRadius: 8,
              offset: const Offset(0, 7),
            )
          ],
          borderRadius: BorderRadius.circular(16),
          color: preferences.getBool("isDarkMode") == true
              ? color.withOpacity(.4)
              : color.withOpacity(.9),
          // color: color.withOpacity(0.15)
        ),
        child: TextButton(
          style: buttonStyle(14),
          onPressed: () async {
            switch (index) {
              case 1:
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (BuildContext context) => Gameintro(
                            gameName: text,
                            color: color,
                            text:
                                "Each player is trapped in a virtual castle 🏰. To escape, they must solve grammar puzzles, fix incorrect sentences, or choose the right words.",
                            path: path)));
                break;
              case 2:
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (BuildContext context) => Gameintro(
                            gameName: text,
                            color: color,
                            text:
                                "A grammar bomb is passed between players ⏳. A sentence with a missing word is given. The player must fill in the blank correctly before time runs out! If they fail or take too long, they lose the game. Last player standing wins!",
                            path: path)));

                break;
              case 3:
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (BuildContext context) => Gameintro(
                            gameName: text,
                            color: color,
                            text:
                                "The teacher gives a sentence in the student’s native language. The team must quickly work together to translate it into correct English. The AI checks grammar and correctness instantly.",
                            path: path)));
                break;
              case 4:
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (BuildContext context) => Gameintro(
                            gameName: text,
                            color: color,
                            text:
                                "Each player is given scattered letters on the screen. They must rearrange them to form a word. The fastest player to solve 4 words wins!",
                            path: path)));
                break;
              case 5:
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (BuildContext context) => Gameintro(
                            gameName: text,
                            color: color,
                            text: "Play a game at random",
                            path: path)));
                break;
              default:
                break;
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              path == 'assets/images/translate.png'
                  ? Image.asset('assets/images/translate.png', height: 12.h)
                  : Lottie.asset(path, animate: false, height: 12.h),
              setText(text, FontWeight.w600, 14.5.sp, Colors.white)
            ],
          ),
        ),
      ),
    );
    // .scaleXY(
    //     begin: 1.2,
    //     end: 1,
    //     curve: Curves.ease,
    //     duration: 300.ms,
    //     delay: (50 + index * 100).ms)
    // .fadeIn();
  }
}
