import 'dart:async';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:funlish_app/components/afterGameScreens/countDownScreen.dart';
import 'package:funlish_app/components/afterGameScreens/drawScreen.dart';
import 'package:funlish_app/components/afterGameScreens/lostScreen.dart';
import 'package:funlish_app/components/afterGameScreens/winScreen.dart';
import 'package:funlish_app/components/modals/alertModal.dart';
import 'package:funlish_app/components/topNotification.dart';
import 'package:funlish_app/model/player.dart';
import 'package:funlish_app/model/powerUp.dart';
import 'package:funlish_app/model/userProgress.dart';
import 'package:funlish_app/utility/databaseHandler.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:funlish_app/utility/socketIoClient.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:sizer/sizer.dart';

class Escapelevel extends StatefulWidget {
  final Color color;
  final bool playAgain;

  const Escapelevel({super.key, required this.color, required this.playAgain});

  @override
  State<Escapelevel> createState() => _EscapelevelState();
}

class _EscapelevelState extends State<Escapelevel>
    with SingleTickerProviderStateMixin {
  bool isAnswered = false;
  double progress = 0;
  ValueNotifier<int> activeIndex = ValueNotifier<int>(0);
  final PageController pageController = PageController();
  List<TextEditingController> inputControllers = [];
  late AnimationController animationController;
  late SocketService socketService;
  List<dynamic> answers = [];
  List<dynamic> orQuestions = [];
  List<int> synQuestions = [];
  List<dynamic> fixQuestions = [];
  List<dynamic> questions = [];
  List<dynamic> options = [];
  int correctAnswers = 0;
  Timer timer = Timer(Duration(), () {});
  Timer timerPreMatch = Timer(Duration(), () {});
  List<Player> players = [];
  bool isLoading = true;
  int timeDuration = 300;
  bool isTimeUp = false;
  int activeContorllerIndex = 0;
  Random random = Random();
  Map<int, List<String>> synChoices = {};
  bool isCountDown = false;
  int extendedTimeCount = 0;
  ScrollController scrollController = ScrollController();
  bool isWon = false;
  bool isLost = false;
  bool isDraw = false;
  void getPowerUps() async {
    powerUps = await getPowerUpsOfGame('castleEscape');
    if (mounted) {
      setState(() {});
    }
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
        if (mounted) {
          setState(() {
            isCountDown = false;
          });
          Timer(Duration(milliseconds: 1500), () {
            scrollController.animateTo(475.h,
                duration: Duration(seconds: 3), curve: Curves.easeInOut);
          });
        }
        startTimer();
      }
    });
  }

  void addPoints(String name, String points) {
    for (var player in players) {
      if (player.name == name) {
        if (mounted) {
          setState(() {
            player.points = int.parse(points);
          });
        }
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
    timer.cancel();
  }

  void updatePlayers(List<Player> newPlayers) {
    if (mounted) {
      setState(() {
        players = newPlayers;
      });
    }
  }

  void addWord(List<dynamic> answers1, List<dynamic> questions1,
      List<dynamic> options1) {
    if (mounted) {
      answers = questions1;
      questions = answers1;
      options = options1;
      for (int i = 0; i < questions.length; i++) {
        if (questions[i].split(" ").length > 1) {
          if (questions[i].contains("(")) {
            orQuestions.add(questions[i]);
          } else {
            fixQuestions.add(questions[i]);
          }
        } else {
          synQuestions.add(i);
        }
      }

      List<String> list = [];
      options1.forEach((q) {
        list.add(q.toString());
      });
      for (int index in synQuestions) {
        synChoices[index] = getRandomWords(list, answers[index].toString());
      }
      print(synChoices);

      setState(() {});
    }
  }

  void hasWon() {
    final user = Provider.of<UserProgress>(context, listen: false);
    user.addXP(50);
    playSound("audio/win.MP3");
    if (mounted) {
      setState(() {
        isWon = true;
      });
    }
    socketService.sendMessage(socketService.matchid, "", "IWON");
    timer.cancel();
  }

  void hasDraw() {
    final user = Provider.of<UserProgress>(context, listen: false);
    user.addXP(25);
    playSound("audio/draw.mp3");
    if (mounted) {
      setState(() {
        isDraw = true;
      });
    }
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
          players.forEach((player) {
            if (player.points > max) max = player.points;
          });
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
    for (int i = 0; i < 2; i++) {
      inputControllers.add(TextEditingController());
    }

    // TODO: implement initState
    socketService = SocketService(
        updateLoading: updateLoading,
        addAnswer: () {},
        setFirst: () {},
        extendTimer: () {},
        friednlyBomb: () {},
        hasWon: () {},
        hasDraw: () {},
        addWord: addWord,
        updatePlayers: updatePlayers,
        hasLost: hasLost,
        addSentence: () {},
        addPoints: addPoints,
        showAlert: () {
          Navigator.pop(context);
          showAlertModal(context, "Opponent has left");
          playSound("audio/left.mp3");
        });
    super.initState();

    Timer(Duration(seconds: widget.playAgain ? 1 : 0), () {
      socketService.connect();
      socketService.findMatch("castleEscape");
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
    timerPreMatch.cancel();
    scrollController.dispose();
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
                    LoadingAnimationWidget.staggeredDotsWave(
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
                            words: answers,
                            function: playAgain)
                        : isDraw
                            ? Drawscreen(
                                players: players,
                                color: widget.color,
                                function: playAgain)
                            : Animate(
                                    child: Stack(
                                children: [
                                  Container(
                                    color:
                                        const Color.fromARGB(255, 18, 25, 31),
                                    width: 100.w,
                                    child: SingleChildScrollView(
                                      controller: scrollController,
                                      // physics:ScrollPhysics.e,
                                      child: Column(
                                        children: [
                                          // SizedBox(height: 5.h),
                                          Animate(
                                                  child: Lottie.asset(
                                                      "assets/animations/castle.json",
                                                      height: 75.h))
                                              .slideY(
                                                  begin: .2,
                                                  end: 0,
                                                  curve: Curves.ease,
                                                  delay: 400.ms,
                                                  duration: 400.ms)
                                              .fadeIn(),
                                          for (int i = 0;
                                              i < questions.length;
                                              i++)
                                            Column(
                                              children: [
                                                Container(
                                                  width: 100.w,
                                                  height: 25.h,
                                                  color: const Color.fromARGB(
                                                      255, 18, 25, 31),
                                                ),
                                                Container(
                                                  height: 100.h,
                                                  width: 100.w,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/games/room${i + 1}.jpg'),
                                                      fit: BoxFit.fitHeight,
                                                      colorFilter:
                                                          ColorFilter.mode(
                                                        Colors.black
                                                            .withOpacity(0.4),
                                                        BlendMode.darken,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Column(children: [
                                                    SizedBox(
                                                      height: 7.h,
                                                    ),
                                                    setText(
                                                        "Room ${4 - i}",
                                                        FontWeight.bold,
                                                        18.sp,
                                                        Colors.white),
                                                    SizedBox(height: 15.h),
                                                    if (questions[i]
                                                            .toString()
                                                            .split(" ")
                                                            .length ==
                                                        1)
                                                      Column(
                                                        children: [
                                                          SizedBox(
                                                            width: 90.w,
                                                            child: setText(
                                                                "What is another word for: ${questions[i]}",
                                                                FontWeight.w600,
                                                                16.sp,
                                                                bodyColor,
                                                                true),
                                                          ),
                                                          SizedBox(
                                                              height: 15.h),
                                                          SizedBox(
                                                            width: 88.w,
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    optionButton(
                                                                        synChoices[
                                                                            i]![0],
                                                                        i),
                                                                    optionButton(
                                                                        synChoices[
                                                                            i]![1],
                                                                        i),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        3.h),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    optionButton(
                                                                        synChoices[
                                                                            i]![2],
                                                                        i),
                                                                    optionButton(
                                                                        synChoices[
                                                                            i]![3],
                                                                        i),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    if (questions[i]
                                                        .toString()
                                                        .contains(
                                                            "correct form"))
                                                      Column(
                                                        children: [
                                                          SizedBox(
                                                            width: 90.w,
                                                            child: setText(
                                                                questions[i],
                                                                FontWeight.w600,
                                                                16.sp,
                                                                bodyColor,
                                                                true),
                                                          ),
                                                          SizedBox(
                                                              height: 15.h),
                                                          SizedBox(
                                                            width: 88.w,
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    for (String word
                                                                        in splitQuestion(questions[
                                                                            i]))
                                                                      optionButton(
                                                                          word,
                                                                          i),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        3.h),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    if (!questions[i]
                                                            .toString()
                                                            .contains("(") &&
                                                        questions[i]
                                                                .toString()
                                                                .split(" ")
                                                                .length >
                                                            1)
                                                      Column(
                                                        children: [
                                                          SizedBox(
                                                            width: 90.w,
                                                            child: setText(
                                                                questions[i],
                                                                FontWeight.w600,
                                                                16.sp,
                                                                bodyColor,
                                                                true),
                                                          ),
                                                          SizedBox(
                                                              height: 15.h),
                                                          SizedBox(
                                                            width: 88.w,
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  width: 92.w,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            85.w,
                                                                        height:
                                                                            7.h,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(12),
                                                                            color: Colors.white),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              TextFormField(
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: "magnet",
                                                                              fontSize: 15.sp,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: fontColor,
                                                                            ),
                                                                            decoration:
                                                                                InputDecoration(
                                                                              counterStyle: TextStyle(fontSize: 0),
                                                                              hintStyle: TextStyle(
                                                                                fontFamily: "magnet",
                                                                                fontSize: 15.sp,
                                                                                fontWeight: FontWeight.w500,
                                                                                color: fontColor.withOpacity(0.3),
                                                                              ),
                                                                              hintText: "Answer here...",
                                                                              border: InputBorder.none,
                                                                              contentPadding: EdgeInsets.all(10),
                                                                            ),
                                                                            maxLength:
                                                                                70,
                                                                            controller:
                                                                                inputControllers[activeContorllerIndex % 2],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              2.h),
                                                                      Container(
                                                                        width:
                                                                            20.w,
                                                                        height:
                                                                            7.h,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(12),
                                                                            color: Color(0xff0EB29A)),
                                                                        child: TextButton(
                                                                            style: OutlinedButton.styleFrom(padding: EdgeInsets.zero, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12)))),
                                                                            onPressed: () {},
                                                                            child: FittedBox(
                                                                              fit: BoxFit.scaleDown,
                                                                              child: setText("Send", FontWeight.w600, 15.sp, Colors.white),
                                                                            )),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        3.h),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                  ]),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (isVisible)
                                    GestureDetector(
                                        onTap: () {
                                          if (mounted) {
                                            setState(() {
                                              _width = 12.w;
                                              _height = 12.w;
                                              isVisible = false;
                                              bgOpacity = 0;
                                            });
                                          }
                                        },
                                        child: AnimatedOpacity(
                                          opacity: bgOpacity,
                                          duration: Duration(milliseconds: 200),
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
                                              if (mounted) {
                                                setState(() {
                                                  _width = 70.w;

                                                  _height = 20.h;
                                                });
                                              }

                                              Timer(Duration(milliseconds: 150),
                                                  () {
                                                if (mounted) {
                                                  setState(() {
                                                    isVisible = true;
                                                  });
                                                }
                                              });
                                              Timer(Duration(milliseconds: 200),
                                                  () {
                                                if (mounted) {
                                                  setState(() {
                                                    bgOpacity = 1;
                                                  });
                                                }
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
                                                                      BorderRadius
                                                                          .circular(
                                                                              16),
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      244,
                                                                      244,
                                                                      244)),
                                                              child: TextButton(
                                                                  style:
                                                                      buttonStyle(
                                                                          12),
                                                                  onPressed:
                                                                      () {
                                                                    switch (powerUps[
                                                                            i]
                                                                        .name) {
                                                                      case "Extended Time":
                                                                        if (extendedTimeCount >=
                                                                            3) {
                                                                          return;
                                                                        }
                                                                        // extendTimer();
                                                                        // socketService.sendMessage(socketService.matchid, "", "EXTENDTIMER");
                                                                        // closeBg();
                                                                        break;
                                                                      case "Friendly Bomb":
                                                                        // friednlyBomb();
                                                                        // socketService.sendMessage(socketService.matchid, "", "FRIENDLYBOMB");
                                                                        // closeBg();

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
                                                                        11.w,
                                                                  )),
                                                            ),
                                                            SizedBox(
                                                                height: 1.h),
                                                            setText(
                                                                powerUps[i]
                                                                    .count
                                                                    .toString(),
                                                                FontWeight.bold,
                                                                14.sp,
                                                                fontColor)
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
                              ))
                                .scaleXY(
                                    begin: 1.2,
                                    end: 1,
                                    duration: 400.ms,
                                    curve: Curves.ease)
                                .fadeIn(),
      ),
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

  closeBg() {
    if (mounted) {
      setState(() {
        _width = 12.w;
        _height = 12.w;
        bgOpacity = 0;
        isVisible = false;
      });
    }
  }

  bool showNotification = false;
  String sender = "";
  int answersCount = 0;
  bool isVisible = false;
  Widget optionButton(String text, int index) {
    return Container(
      width: 40.w,
      height: 7.5.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: bodyColor),
      child: TextButton(
        style: buttonStyle(12),
        onPressed: () {
          if (text != answers[index]) return;
          addPoints(
              preferences.getString("userName")!, (answersCount++).toString());
          scrollController.animateTo(475.h - (125 * (4 - index)).h,
              duration: Duration(milliseconds: 700), curve: Curves.easeInOut);
        },
        child: setText(text, FontWeight.w600, 15.sp, fontColor),
      ),
    );
  }

  playAgain() {
    Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
            builder: (BuildContext context) =>
                Escapelevel(color: widget.color, playAgain: true)));
  }

  List<String> splitQuestion(String sentence) {
    // Extract content inside parentheses
    RegExp regex = RegExp(r'\((.*?)\)');
    final match = regex.firstMatch(sentence);

    if (match != null) {
      String inside = match.group(1)!; // was/were
      List<String> words = inside.split('/'); // ['was', 'were']
      return words;
    }
    return [];
  }
}
