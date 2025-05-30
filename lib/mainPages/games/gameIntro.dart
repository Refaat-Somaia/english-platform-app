import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:funlish_app/mainPages/games/createSession.dart';
import 'package:funlish_app/mainPages/games/escapeLevel.dart';
import 'package:funlish_app/mainPages/games/inputLevel.dart';
import 'package:funlish_app/mainPages/games/joinSession.dart';
import 'package:funlish_app/mainPages/games/puzzleLevel.dart';
import 'package:funlish_app/model/gamesStats.dart';
import 'package:funlish_app/utility/databaseHandler.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:funlish_app/utility/socketIoClient.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class Gameintro extends StatefulWidget {
  final Color color;
  final String gameName;
  final String text;

  final String path;
  const Gameintro(
      {super.key,
      required this.gameName,
      required this.color,
      required this.text,
      required this.path});

  @override
  State<Gameintro> createState() => _GameintroState();
}

class _GameintroState extends State<Gameintro> {
  // final SocketService socketService = SocketService();

  GameStat? gameStat;

  @override
  void initState() {
    super.initState();
    getGameStats();
    // socketService.connect();
  }

  getGameStats() async {
    gameStat = await getGameStatByIGame(widget.gameName);
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    // socketService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 1; i <= 4; i++) {
      Image.asset(
        'assets/images/games/room$i.jpg',
        width: 0,
      );
    }

    return Scaffold(
      backgroundColor: bodyColor,
      body: Container(
        width: 100.w,
        height: 100.h,
        color: widget.color.withOpacity(0.05),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 5.h,
                ),
                Animate(
                  child: widget.path == 'assets/images/translate.png'
                      ? Image.asset(
                          'assets/images/translate.png',
                          width: 50.w,
                        )
                      : Lottie.asset(widget.path, width: 50.w),
                )
                    .scaleXY(
                      begin: 0,
                      end: 1,
                      curve: Curves.easeOut,
                      duration: 300.ms,
                    )
                    .scaleXY(
                        begin: 1.2,
                        end: 1,
                        curve: Curves.easeOut,
                        duration: 300.ms,
                        delay: 300.ms),
                Animate(
                  child: setText(
                      widget.gameName,
                      FontWeight.bold,
                      19.sp,
                      preferences.getBool("isDarkMode") == true
                          ? fontColor
                          : widget.color),
                ).fadeIn(begin: 0, delay: 300.ms, duration: 500.ms),
                SizedBox(
                  height: 1.h,
                ),
                Animate(
                  child: SizedBox(
                      width: 92.w,
                      child: setText(widget.text, FontWeight.w600, 14.sp,
                          fontColor.withOpacity(0.8))),
                ).fadeIn(begin: 0, delay: 300.ms, duration: 500.ms),
                SizedBox(
                  height: 4.h,
                ),
                Animate(
                  child: SizedBox(
                    width: 92.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                preferences.getBool("isDarkMode") == true
                                    ? "assets/images/play-dark.png"
                                    : "assets/images/play.png",
                                height: 4.h,
                              ),
                              setText("Games played:", FontWeight.w600, 13.sp,
                                  fontColor),
                              setText(
                                  "${gameStat != null ? gameStat!.timesPlayed : 0}",
                                  FontWeight.w600,
                                  13.sp,
                                  fontColor),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                preferences.getBool("isDarkMode") == true
                                    ? "assets/images/win-dark.png"
                                    : "assets/images/win.png",
                                height: 4.h,
                              ),
                              setText("Games won:", FontWeight.w600, 13.sp,
                                  fontColor),
                              setText(
                                  "${gameStat != null ? gameStat!.wins : 0}",
                                  FontWeight.w600,
                                  13.sp,
                                  fontColor),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              preferences.getBool("isDarkMode") == true
                                  ? "assets/images/coins-dark.png"
                                  : "assets/images/coins.png",
                              height: 4.h,
                            ),
                            setText("Total score:", FontWeight.w600, 13.sp,
                                fontColor),
                            setText("${gameStat != null ? gameStat!.score : 0}",
                                FontWeight.w600, 13.sp, fontColor),
                          ],
                        ),
                      ],
                    ),
                  ),
                ).fadeIn(begin: 0, delay: 700.ms, duration: 500.ms),
                SizedBox(
                  height: 8.h,
                ),
                Animate(
                  child: Container(
                    width: 90.w,
                    height: 7.h,
                    decoration: BoxDecoration(
                        color: widget.color,
                        borderRadius: BorderRadius.circular(16)),
                    child: TextButton(
                      style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)))),
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (BuildContext context) =>
                                    widget.gameName == "Bomb Relay"
                                        ? Inputlevel(
                                            color: widget.color,
                                            gameStat: gameStat!,
                                            updateStats: getGameStats,
                                            playAgain: false,
                                          )
                                        : widget.gameName == "Word Puzzle"
                                            ? Puzzlelevel(
                                                color: widget.color,
                                                gameStat: gameStat!,
                                                updateStats: getGameStats,
                                                playAgain: false)
                                            : Escapelevel(
                                                playAgain: false,
                                                gameStat: gameStat!,
                                                updateStats: getGameStats,
                                                color: widget.color,
                                              )));
                      },
                      child: setText("Public session", FontWeight.w600, 15.sp,
                          Colors.white),
                    ),
                  ),
                )
                    .fadeIn(begin: 0, delay: 500.ms, duration: 400.ms)
                    .slideY(begin: 0.7, end: 0, curve: Curves.ease),
                SizedBox(
                  height: 2.h,
                ),
                Animate(
                        child: SizedBox(
                            width: 90.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 43.w,
                                  height: 7.h,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16)),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (BuildContext context) =>
                                                  Joinsession(
                                                    color: widget.color,
                                                    gameName: widget.gameName,
                                                  )));
                                    },
                                    style: OutlinedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16)))),
                                    child: setText("Join a session",
                                        FontWeight.w600, 14.5.sp, widget.color),
                                  ),
                                ),
                                Container(
                                  width: 43.w,
                                  height: 7.h,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16)),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (BuildContext context) =>
                                                  Createsession(
                                                    color: widget.color,
                                                    gameName: widget.gameName,
                                                  )));
                                    },
                                    style: OutlinedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16)))),
                                    child: setText("Create a session",
                                        FontWeight.w600, 14.5.sp, widget.color),
                                  ),
                                ),
                              ],
                            )))
                    .fadeIn(begin: 0, delay: 600.ms, duration: 500.ms)
                    .slideY(begin: 1.2, end: 0, curve: Curves.ease),
              ],
            ),
            Positioned(
              left: 4.w,
              top: 2.5.h,
              child: Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    // border: Border.all(
                    //     width: 1.5, color: fontColor.withOpacity(0.2))
                    color: widget.color),
                child: IconButton(
                    style: buttonStyle(16),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      size: 7.w,
                      color: Colors.white,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showModeModal(context, Color color, String text, String path) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Animate(
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                insetPadding: EdgeInsets.all(5.w),
                backgroundColor: bodyColor,
                content: SizedBox(
                  height: 40.h,
                  width: double.maxFinite,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 2.h,
                      ),
                      setText("Select mode", FontWeight.w600, 18.sp, fontColor),
                      SizedBox(
                        height: 6.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: color),
                            width: 38.w,
                            height: 18.h,
                            child: TextButton(
                              onPressed: () {},
                              style: buttonStyle(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/3players.png",
                                    width: 18.w,
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  setText("3 or more", FontWeight.w600, 15.sp,
                                      Colors.white, true),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: color),
                            width: 38.w,
                            height: 18.h,
                            child: TextButton(
                              onPressed: () async {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (BuildContext context) =>
                                            Gameintro(
                                                gameName: text,
                                                color: color,
                                                text:
                                                    "Each player is given scattered letters on the screen. They must rearrange them to form a word. The fastest player to solve 4 words wins!",
                                                path: path)));
                              },
                              style: buttonStyle(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/1v1.png",
                                    width: 18.w,
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  setText("2 players", FontWeight.w600, 15.sp,
                                      Colors.white, true),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
                .slideY(begin: .1, end: 0, curve: Curves.ease, duration: 400.ms)
                .fadeIn();
          });
        });
  }
}
