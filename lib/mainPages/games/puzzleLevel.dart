// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:funlish_app/components/afterGameScreens/countDownScreen.dart';
import 'package:funlish_app/components/afterGameScreens/drawScreen.dart';
import 'package:funlish_app/components/afterGameScreens/lostScreen.dart';
import 'package:funlish_app/components/afterGameScreens/winScreen.dart';
import 'package:funlish_app/components/modals/alertModal.dart';
import 'package:funlish_app/components/topNotification.dart';
import 'package:funlish_app/model/gamesStats.dart';
import 'package:funlish_app/model/player.dart';
import 'package:funlish_app/model/powerUp.dart';
import 'package:funlish_app/model/userProgress.dart';
import 'package:funlish_app/utility/databaseHandler.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:funlish_app/utility/socketIoClient.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

extension Shuffle on String {
  String get shuffled => (characters.toList()..shuffle()).join();
}

class Puzzlelevel extends StatefulWidget {
  final Color color;
  final bool playAgain;
  final GameStat gameStat;
  const Puzzlelevel(
      {super.key,
      required this.gameStat,
      required this.color,
      required this.playAgain});

  @override
  State<Puzzlelevel> createState() => _PuzzlelevelState();
}

class _PuzzlelevelState extends State<Puzzlelevel>
    with SingleTickerProviderStateMixin {
  bool isAnswered = false;
  double progress = 0;
  ValueNotifier<int> activeIndex = ValueNotifier<int>(0);
  final PageController pageController = PageController();
  late AnimationController animationController;
  late SocketService socketService;
  List<dynamic> words = [
    "",
    "",
    "",
    "",
  ];
  List<dynamic> description = [
    "",
    "",
    "",
    "",
  ];
  List<String> shuffledWord = [];
  int correctAnswers = 0;
  List<bool> hasAnswered = [false, false, false, false];
  List<List<String?>> droppedWords = [];
  Timer timer = Timer(Duration(), () {});
  Timer timerPreMatch = Timer(Duration(), () {});
  List<Player> players = [];
  bool isLoading = true;
  int timeDuration = 60;
  bool isTimeUp = false;
  bool isCountDown = false;
  int extendedTimeCount = 0;
  bool isWon = false;
  bool isLost = false;
  bool isDraw = false;
  void getPowerUps() async {
    powerUps = await getPowerUpsOfGame('wordPuzzle');
    setState(() {});
  }

  void updateLoading() {
    animationController.reverse();

    Timer(Duration(milliseconds: 300), () {
      isCountDown = true;
      playSound("audio/found.MP3");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
    timerPreMatch = Timer.periodic(Duration(seconds: 1), (time) {
      if (timerPreMatch.tick <= 3) {
        if (mounted) {
          setState(() {});
        }
      } else {
        timerPreMatch.cancel();
        setState(() {
          isCountDown = false;
        });
        startTimer();
      }
    });
  }

  void addPoints(String name, String points) {
    for (var player in players) {
      if (player.name == name) {
        setState(() {
          player.points = int.parse(points);
        });
      }
    }
  }

  void hasLost() {
    playSound("audio/lost.mp3");
    if (mounted) {
      setState(() {
        isLost = true;
      });
    }
    updateGameStat(GameStat(
        id: widget.gameStat.id,
        gameName: widget.gameStat.gameName,
        wins: widget.gameStat.wins,
        score: widget.gameStat.score,
        timesPlayed: widget.gameStat.timesPlayed + 1));
    timer.cancel();
  }

  void updatePlayers(List<Player> newPlayers) {
    if (mounted) {
      setState(() {
        players = newPlayers;
      });
    }
  }

  void addWord(List<dynamic> word1, List<dynamic> description1) {
    if (mounted) {
      words = word1;
      description = description1;
      for (int i = 0; i < words.length; i++) {
        words[i] = words[i].toString().toLowerCase();
        droppedWords.add(List.filled(words[i].length, ""));
        shuffledWord.add(words[i].toString().shuffled);
        hasAnswered.add(false);
      }
      setState(() {});
    }
  }

  void hasWon() {
    final user = Provider.of<UserProgress>(context, listen: false);
    user.addXP(50);
    playSound("audio/win.MP3");
    setState(() {
      isWon = true;
    });
    updateGameStat(GameStat(
        id: widget.gameStat.id,
        gameName: widget.gameStat.gameName,
        wins: widget.gameStat.wins + 1,
        score: widget.gameStat.score + 50,
        timesPlayed: widget.gameStat.timesPlayed + 1));
    socketService.sendMessage(socketService.matchid, "", "IWON");
    timer.cancel();
  }

  void hasDraw() {
    final user = Provider.of<UserProgress>(context, listen: false);
    user.addXP(25);
    playSound("audio/draw.mp3");
    setState(() {
      isDraw = true;
    });
    updateGameStat(GameStat(
        id: widget.gameStat.id,
        gameName: widget.gameStat.gameName,
        wins: widget.gameStat.wins,
        score: widget.gameStat.score + 25,
        timesPlayed: widget.gameStat.timesPlayed + 1));
    timer.cancel();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (time) {
      if (time.tick <= timeDuration) {
        if (mounted) {
          setState(() {
            progress = (time.tick / timeDuration);
          });
        }
      } else {
        time.cancel();
        if (!(isLost || isWon)) {
          int max = 0;
          for (var player in players) {
            if (player.points > max) max = player.points;
          }
          if (max < correctAnswers) {
            hasWon();

            return;
          }
          hasDraw();
        }
      }
    });
  }

  @override
  void initState() {
    getPowerUps();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    animationController.forward();
    playSound("audio/searching.mp3");

    // TODO: implement initState
    socketService = SocketService(
        updateLoading: updateLoading,
        addAnswer: () {},
        setFirst: () {},
        extendTimer: extendTimer,
        friednlyBomb: () {},
        hasWon: () {},
        hasDraw: () {},
        addWord: addWord,
        updatePlayers: updatePlayers,
        hasLost: hasLost,
        addSentence: () {},
        addPoints: addPoints,
        showAlert: () {
          if (timer.isActive) {
            Navigator.pop(context);
            showAlertModal(context, "Opponent has left");
            playSound("audio/left.mp3");
          }
        });
    super.initState();

    Timer(Duration(seconds: widget.playAgain ? 1 : 0), () {
      socketService.connect();
      socketService.findMatch("wordPuzzle");
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
    timerPreMatch.cancel();
    powerUpTimer.cancel();
    socketService.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyColor,
      body: Container(
        width: 100.w,
        height: 100.h,
        color: widget.color.withOpacity(0.05),
        child: isLoading
            ? Animate(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingAnimationWidget.fallingDot(
                        color: widget.color, size: 18.w),
                    SizedBox(height: 1.h),
                    setText("Looking for players...", FontWeight.w600, 16.sp,
                        fontColor),
                    SizedBox(height: 3.h),
                    Container(
                      width: 35.w,
                      height: 6.h,
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
                          Navigator.pop(context);
                        },
                        child: setText(
                            "Cancel", FontWeight.w600, 15.sp, Colors.white),
                      ),
                    ),
                  ],
                ),
              )
                .animate(controller: animationController, autoPlay: false)
                .fadeIn(delay: 200.ms, duration: 400.ms, begin: 0)
            : isCountDown
                ? Countdownscreen(
                    color: widget.color,
                    players: players,
                    time: timerPreMatch.tick,
                  )
                : isWon
                    ? Winscreen(
                        color: widget.color,
                        players: players,
                        function: playAgain)
                    : isLost
                        ? Lostscreen(
                            color: widget.color,
                            players: players,
                            words: words,
                            function: playAgain)
                        : isDraw
                            ? Drawscreen(
                                players: players,
                                color: widget.color,
                                function: playAgain)
                            : Animate(
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      width: 100.w,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 6.h,
                                          ),
                                          CircularPercentIndicator(
                                            radius: 6.h,
                                            backgroundColor:
                                                fontColor.withOpacity(0.2),
                                            animation: true,
                                            animateFromLastPercent: true,
                                            curve: Curves.easeOut,
                                            animationDuration: 400,
                                            progressColor: progress < 0.4
                                                ? const Color.fromARGB(
                                                    255, 68, 186, 129)
                                                : progress < 0.7
                                                    ? Colors.orangeAccent
                                                    : Colors.redAccent,
                                            percent: progress,
                                            center: setText(
                                                (timeDuration - timer.tick)
                                                    .toString(),
                                                FontWeight.bold,
                                                16.sp,
                                                fontColor.withOpacity(0.8),
                                                true),
                                          ),
                                          SingleChildScrollView(
                                            child: SizedBox(
                                              width: 100.w,
                                              height: 72.h,
                                              child: PageView(
                                                controller: pageController,
                                                children: [
                                                  for (int i = 0;
                                                      i < words.length;
                                                      i++)
                                                    WordPage(i),
                                                ],
                                                onPageChanged: (value) {
                                                  setState(() {
                                                    activeIndex.value = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          ValueListenableBuilder<int>(
                                            valueListenable: activeIndex,
                                            builder: (context, value, child) {
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: List.generate(
                                                  words.length,
                                                  (index) => Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 1.w),
                                                    child: AnimatedContainer(
                                                      duration: const Duration(
                                                          milliseconds: 300),
                                                      curve: Curves.easeOut,
                                                      width: 5.5.w,
                                                      height: 5.5.w,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                              color: hasAnswered[
                                                                      index]
                                                                  ? const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      68,
                                                                      186,
                                                                      129)
                                                                  : value ==
                                                                          index
                                                                      ? fontColor
                                                                      : fontColor
                                                                          .withOpacity(
                                                                              0.2),
                                                              width: 2)),
                                                      child: Center(
                                                        child: setText(
                                                            "${index + 1}",
                                                            FontWeight.w600,
                                                            13.sp,
                                                            value == index ||
                                                                    hasAnswered[
                                                                        index]
                                                                ? fontColor
                                                                : hasAnswered[
                                                                        index]
                                                                    ? const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        68,
                                                                        186,
                                                                        129)
                                                                    : fontColor
                                                                        .withOpacity(
                                                                            0.2)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isVisible)
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _width = 12.w;
                                              _height = 12.w;
                                              isVisible = false;
                                              bgOpacity = 0;
                                            });
                                          },
                                          child: AnimatedOpacity(
                                            opacity: bgOpacity,
                                            duration:
                                                Duration(milliseconds: 200),
                                            child: Container(
                                              width: 100.w,
                                              height: 100.h,
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                            ),
                                          )),
                                    Positioned(
                                        right: 3.w,
                                        bottom: 2.5.h,
                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 300),
                                          padding: EdgeInsets.all(
                                              _width > 12.w ? 15 : 0),
                                          constraints: BoxConstraints(
                                              minHeight: _height,
                                              minWidth: _width),
                                          curve: Curves.ease,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: TextButton(
                                            style: buttonStyle(12),
                                            onPressed: () {
                                              if (_width == 12.w) {
                                                setState(() {
                                                  _width = 70.w;

                                                  _height = 20.h;
                                                });

                                                Timer(
                                                    Duration(milliseconds: 150),
                                                    () {
                                                  setState(() {
                                                    isVisible = true;
                                                  });
                                                });
                                                Timer(
                                                    Duration(milliseconds: 200),
                                                    () {
                                                  setState(() {
                                                    bgOpacity = 1;
                                                  });
                                                });

                                                return;
                                              }
                                              closeBg();
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                if (_width < 13.w)
                                                  Animate(
                                                    child: Image.asset(
                                                      "assets/images/power.png",
                                                      width: 9.w,
                                                    ),
                                                  ).fadeIn(),
                                                if (isVisible)
                                                  Animate(
                                                    child: Wrap(
                                                      alignment:
                                                          WrapAlignment.center,
                                                      spacing: 7.w,
                                                      runSpacing: 2.h,
                                                      children: [
                                                        for (int i = 0;
                                                            i < powerUps.length;
                                                            i++)
                                                          Column(
                                                            children: [
                                                              Container(
                                                                width: 17.w,
                                                                height: 17.w,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16),
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        244,
                                                                        244,
                                                                        244)),
                                                                child:
                                                                    TextButton(
                                                                        style: buttonStyle(
                                                                            12),
                                                                        onPressed:
                                                                            () {
                                                                          switch (
                                                                              powerUps[i].name) {
                                                                            case "Extended Time":
                                                                              if (extendedTimeCount >= 3) {
                                                                                showAlertModal(context, "Extended Time can only be used 3 times per match");
                                                                                return;
                                                                              }
                                                                              extendTimer();
                                                                              socketService.sendMessage(socketService.matchid, "", "EXTENDTIMER");
                                                                              closeBg();
                                                                              break;
                                                                            case "Puzzle Hint":
                                                                              wordHint();
                                                                              socketService.sendMessage(socketService.matchid, "", "WORDHINT");

                                                                              closeBg();

                                                                              break;
                                                                            default:
                                                                              break;
                                                                          }
                                                                        },
                                                                        child: Image
                                                                            .asset(
                                                                          powerUps[i]
                                                                              .iconPath,
                                                                          height:
                                                                              12.w,
                                                                        )),
                                                              ),
                                                              SizedBox(
                                                                  height: 1.h),
                                                              setText(
                                                                  powerUps[i]
                                                                      .count
                                                                      .toString(),
                                                                  FontWeight
                                                                      .bold,
                                                                  14.sp,
                                                                  Color(
                                                                      0xff32356D))
                                                            ],
                                                          ),
                                                      ],
                                                    ),
                                                  ).fadeIn(),
                                              ],
                                            ),
                                          ),
                                        )),
                                    Animate(
                                            child: Positioned(
                                      left: 4.w,
                                      top: 2.h,
                                      child: Topnotification(
                                        powerUp: notificationPowerUp,
                                        sender: sender,
                                      ),
                                    ))
                                        .slideY(
                                            begin: -0.3,
                                            end: showNotification ? 0 : -3,
                                            curve: Curves.ease,
                                            duration: showNotification
                                                ? 400.ms
                                                : 700.ms)
                                        .fadeIn()
                                  ],
                                ),
                              )
                                .scaleXY(
                                    begin: 1.2,
                                    end: 1,
                                    duration: 400.ms,
                                    curve: Curves.ease)
                                .fadeIn(),
      ),
    );
  }

  Widget _buildDraggableItem(String word) {
    return Container(
      width: 14.w,
      height: 7.h,
      decoration: BoxDecoration(
        color: preferences.getBool('isDarkMode') == true
            ? primaryPurple
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        // border: Border.all(color: fontColor, width: 2),
      ),
      child: Center(
        child: setText(word, FontWeight.bold, 15.sp, fontColor),
      ),
    );
  }

  playAgain() {
    Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
            builder: (BuildContext context) => Puzzlelevel(
                  color: widget.color,
                  playAgain: true,
                  gameStat: widget.gameStat,
                )));
  }

  void updatePowerUpCount(String name) async {
    for (int i = 0; i < powerUps.length; i++) {
      if (powerUps[i].name == name) {
        powerUps[i] = PowerUp(
            id: powerUps[i].id,
            price: powerUps[i].price,
            count: powerUps[i].count - 1,
            iconPath: powerUps[i].iconPath,
            description: powerUps[i].description,
            game: powerUps[i].game,
            name: powerUps[i].name);
        await updatePowerUp(powerUps[i].id, powerUps[i].count - 1);
      }
    }
    if (mounted) setState(() {});
  }

  Widget WordPage(int index) {
    return Column(
      children: [
        if (!isAnswered)
          SizedBox(
            height: 6.h,
          ),
        if (!isAnswered)
          SizedBox(
            width: 92.w,
            child: setText('"${description[index]}"', FontWeight.w600, 16.sp,
                fontColor, true),
          ),
        SizedBox(
          height: isAnswered ? 8.h : 6.h,
        ),
        SizedBox(
          width: 92.w,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 2.w,
            runSpacing: 1.h,
            children: List.generate(
              words[index].length,
              (indx) => DragTarget<String>(
                onAccept: (receivedWord) {
                  playSound('audio/click.mp3');
                  if (mounted) {
                    setState(() {
                      droppedWords[index][indx] = receivedWord;
                    });
                    if (droppedWords[index].join() == words[index] &&
                        !hasAnswered[index]) {
                      playSound("audio/found.MP3");
                      setState(() {
                        correctAnswers++;
                        hasAnswered[index] = true;
                      });

                      socketService.sendMessage(socketService.matchid,
                          correctAnswers.toString(), "points");
                      addPoints(preferences.getString("userName")!,
                          correctAnswers.toString());
                      if (activeIndex.value < words.length - 1) {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                        setState(() {
                          activeIndex.value++;
                        });
                      }
                    }
                    if (correctAnswers == words.length) {
                      int max = 0;
                      for (var player in players) {
                        if (player.points > max &&
                            player.name != preferences.getString("userName")) {
                          max = player.points;
                        }
                      }
                      if (max < correctAnswers) {
                        hasWon();
                      } else {
                        hasDraw();
                      }
                    }
                  }
                },
                builder: (context, candidateData, rejectedData) {
                  return Animate(
                    child: Container(
                      width: 14.w,
                      height: 7.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: fontColor.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: setText(
                          droppedWords[index][indx] ??
                              "", // Show dropped word or empty
                          FontWeight.bold,
                          15.sp,
                          fontColor,
                        ),
                      ),
                    ),
                  )
                      .scaleXY(
                        begin: 0,
                        end: 1,
                        curve: Curves.ease,
                        duration:
                            droppedWords[index][indx] != "" ? 300.ms : 0.ms,
                      )
                      .scaleXY(
                          begin: 1.1,
                          end: 1,
                          curve: Curves.ease,
                          duration:
                              droppedWords[index][indx] != "" ? 300.ms : 0.ms,
                          delay:
                              droppedWords[index][indx] != "" ? 300.ms : 0.ms);
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),

        // 🔴 Draggable Words (Shuffled Words)
        SizedBox(
          width: 92.w,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 2.w,
            runSpacing: 1.h,
            children: List.generate(
              shuffledWord[index].length,
              (indx) => Draggable<String>(
                data: shuffledWord[index][indx], // Send word when dragged
                feedback: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 14.w,
                    height: 7.h,
                    decoration: BoxDecoration(
                      color: preferences.getBool('isDarkMode') == true
                          ? primaryPurple
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      // border: Border.all(color: fontColor, width: 2),
                    ),
                    child: Center(
                      child: setText(
                        shuffledWord[index][indx],
                        FontWeight.bold,
                        15.sp,
                        fontColor,
                      ),
                    ),
                  ),
                ),
                childWhenDragging: Opacity(
                    opacity: 0.5,
                    child: _buildDraggableItem(shuffledWord[index][indx])),
                child: _buildDraggableItem(shuffledWord[index][indx]),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<PowerUp> powerUps = [];
  double _width = 12.w;
  double bgOpacity = 0;
  double _height = 12.w;
  PowerUp notificationPowerUp = PowerUp(
      id: "id",
      price: 0,
      count: 0,
      iconPath: "",
      description: "",
      game: "",
      name: "");

  bool showNotification = false;
  String sender = "";
  Timer powerUpTimer = Timer(Duration(), () {});

  bool isVisible = false;
  void winCondition() {
    socketService.sendMessage(socketService.matchid, "", "IWON");
    hasWon();
    timer.cancel();
  }

  extendTimer([sender1]) {
    for (var powerUp in powerUps) {
      if (powerUp.name == "Extended Time") {
        if (powerUp.count <= 0) return;
      }
    }
    updatePowerUpCount("Extended Time");

    powerUpTimer.cancel();
    if (sender1 != null) {
      sender = sender1.toString();
      playSound('audio/enemyPowerUp.mp3');
    } else {
      sender = preferences.getString("userName")!;
      playSound('audio/powerUp.mp3');
    }
    for (var powerUp in powerUps) {
      if (powerUp.name == "Extended Time") {
        setState(() {
          notificationPowerUp = powerUp;
          showNotification = true;
        });
      }
    }
    powerUpTimer = Timer(Duration(seconds: 6), () {
      setState(() {
        showNotification = false;
      });
    });

    setState(() {
      timeDuration += 30;
      extendedTimeCount++;
    });
  }

  wordHint([sender1]) {
    for (var powerUp in powerUps) {
      if (powerUp.name == "Puzzle Hint") {
        if (powerUp.count <= 0) return;
      }
    }
    powerUpTimer.cancel();
    updatePowerUpCount("Puzzle Hint");

    if (sender1 != null) {
      sender = sender1.toString();
      playSound('audio/enemyPowerUp.mp3');
    } else {
      sender = preferences.getString("userName")!;
      playSound('audio/powerUp.mp3');
    }
    for (var powerUp in powerUps) {
      if (powerUp.name == "Puzzle Hint") {
        setState(() {
          notificationPowerUp = powerUp;
          showNotification = true;
        });
      }
    }
    powerUpTimer = Timer(Duration(seconds: 6), () {
      setState(() {
        showNotification = false;
      });
    });
    int length = (droppedWords[activeIndex.value].length / 2).ceil();
    int corrected = 0;

    for (int i = 0; i < droppedWords[activeIndex.value].length; i++) {
      if (droppedWords[activeIndex.value][i] != words[activeIndex.value][i] &&
          corrected <= length) {
        droppedWords[activeIndex.value][i] = words[activeIndex.value][i];
        corrected++;
      }
    }
    setState(() {});
    return;
  }

  closeBg() {
    setState(() {
      _width = 12.w;
      _height = 12.w;
      bgOpacity = 0;
      isVisible = false;
    });
  }
}
