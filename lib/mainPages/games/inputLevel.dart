import 'dart:async';
import 'package:card_swiper/card_swiper.dart';
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
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Inputlevel extends StatefulWidget {
  final Color color;
  final bool playAgain;
  final GameStat gameStat;
  final Function updateStats;
  const Inputlevel(
      {super.key,
      required this.gameStat,
      required this.updateStats,
      required this.color,
      required this.playAgain});

  @override
  State<Inputlevel> createState() => _InputlevelState();
}

class _InputlevelState extends State<Inputlevel>
    with SingleTickerProviderStateMixin {
  List<bool> isVoted = [false, false, false];
  List<int> votesCount = [0, 0, 0];
  List<String> answers = [
    "",
    "",
    "",
    "",
  ];
  List<bool> hasAnswered = [false, false, false, false];
  int currentQuestion = 0;
  String sentence = "";
  late AnimationController animationController;
  List<Player> players = [];
  bool isLoading = true;
  bool isTimeUp = false;
  bool isCountDown = false;
  bool isWon = false;
  int timerDuration = 25;
  bool isLost = false;
  bool isDraw = false;
  bool isFirst = true;
  bool isFriendlyBomb = false;
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
  late SocketService socketService;
  final TextEditingController inputController = TextEditingController();
  Timer timer = Timer(Duration(), () {});
  Timer timerPreMatch = Timer(Duration(), () {});
  double progress = 0;
  void getPowerUps() async {
    powerUps = await getPowerUpsOfGame('bombRelay');
    setState(() {});
  }

  void updateLoading() {
    animationController.reverse();

    Timer(Duration(milliseconds: 300), () {
      isCountDown = true;

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      playSound("audio/found.MP3");
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
        if (isFirst) startTimer();
      }
    });
  }

  void addPoints(String name, String points) {
    for (var player in players) {
      print(player);

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
    widget.updateStats();
  }

  void updatePlayers(List<Player> newPlayers) {
    if (mounted) {
      setState(() {
        players = newPlayers;
      });
    }
  }

  void startTimer() {
    timer.cancel(); // Ensure old timer is stopped before starting a new one
    playSound("audio/tick.mp3");

    timer = Timer.periodic(Duration(seconds: 1), (time) {
      if (time.tick <= timerDuration) {
        if (mounted) {
          setState(() {
            progress = (time.tick / timerDuration);
          });
        }
      } else {
        time.cancel();
        if (!(isLost || isWon)) {
          int max = players.fold(
              0, (max, player) => player.points > max ? player.points : max);

          if (max < currentQuestion) {
            hasWon();
            socketService.sendMessage(socketService.matchid, "", "IWON");
            return;
          }
          if (words.length == currentQuestion) {
            winCondition();
          }
          socketService.sendMessage(
              socketService.matchid, inputController.text, "answer_bombRelay");
          if (mounted) {
            setState(() {
              isFirst = false;
              currentQuestion++;
            });
            FocusManager.instance.primaryFocus?.unfocus();
            return;
          }
          hasLost();
          socketService.sendMessage(socketService.matchid, "", "ILOST");
        }
      }
    });
  }

  void addAnswer(String answer, String player) {
    if (mounted) {
      setState(() {
        answers.add(answer);
      });
    }
  }

  void addWord(List<dynamic> word1, List<dynamic> description1) {
    if (mounted) {
      setState(() {
        words = word1;
        description = description1;
        for (int i = 0; i < words.length; i++) {
          words[i] = words[i].toString().toLowerCase();
        }
      });
    }
  }

  void setFirst(bool isFirst1) {
    setState(() {
      isFirst = isFirst1;
      timer.cancel();
      timerDuration = 20;
      isFriendlyBomb = false;
    });

    if (words.length == currentQuestion) {
      socketService.sendMessage(socketService.matchid, "", "DRAW");
      hasDraw();
      return;
    }

    if (!isCountDown && isFirst) {
      startTimer();
      return;
    }
    playSound("audio/found.MP3");
  }

  void hasWon() {
    final user = Provider.of<UserProgress>(context, listen: false);
    user.addXP(50);
    playSound("audio/win.MP3");
    updateGameStat(GameStat(
        id: widget.gameStat.id,
        gameName: widget.gameStat.gameName,
        wins: widget.gameStat.wins + 1,
        score: widget.gameStat.score + 50,
        timesPlayed: widget.gameStat.timesPlayed + 1));
    widget.updateStats();

    setState(() {
      isWon = true;
      timer.cancel();
    });
  }

  void hasDraw() {
    playSound("audio/draw.mp3");
    final user = Provider.of<UserProgress>(context, listen: false);
    user.addXP(25);
    setState(() {
      isDraw = true;
      timer.cancel();
    });
    updateGameStat(GameStat(
        id: widget.gameStat.id,
        gameName: widget.gameStat.gameName,
        wins: widget.gameStat.wins,
        score: widget.gameStat.score + 25,
        timesPlayed: widget.gameStat.timesPlayed + 1));
    widget.updateStats();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playSound("audio/searching.mp3");
    getPowerUps();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    animationController.forward();
    if (mounted) {
      socketService = SocketService(
          updateLoading: updateLoading,
          addAnswer: addAnswer,
          setFirst: setFirst,
          updatePlayers: updatePlayers,
          addPoints: addPoints,
          extendTimer: extendTimer,
          addSentence: () {},
          hasDraw: hasDraw,
          friednlyBomb: friednlyBomb,
          hasLost: hasLost,
          hasWon: hasWon,
          addWord: addWord,
          showAlert: () {
            if (timer.isActive) {
              Navigator.pop(context);
              showAlertModal(context, "Opponent has left");
              playSound("audio/left.mp3");
            }
          });
    }
    Timer(Duration(seconds: widget.playAgain ? 1 : 0), () {
      socketService.connect();
      socketService.findMatch("bombRelay");
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    powerUpTimer.cancel();
    timer.cancel();
    // socketService.findMatch('bombRelay'); // Replace with your actual event name
    animationController.dispose();
    timerPreMatch.cancel();
    inputController.dispose();
    socketService.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bodyColor,
        body: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
                decoration: BoxDecoration(
                    // color: widget.chapter.colorAsColor.withOpacity(0.05),
                    color: widget.color.withOpacity(0.05)),
                height: 100.h,
                width: 100.w,
                child: isLoading
                    ? Animate(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LoadingAnimationWidget.fallingDot(
                                color: widget.color, size: 18.w),
                            SizedBox(height: 1.h),
                            setText("Looking for players...", FontWeight.w600,
                                16.sp, fontColor),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16)))),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: setText("Cancel", FontWeight.w600, 15.sp,
                                    Colors.white),
                              ),
                            ),
                          ],
                        ),
                      )
                        .animate(
                            controller: animationController, autoPlay: false)
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
                                    words: words,
                                    players: players,
                                    function: playAgain)
                                : isDraw
                                    ? Drawscreen(
                                        players: players,
                                        color: widget.color,
                                        function: playAgain)
                                    : SizedBox(
                                        width: 100.w,
                                        // decoration:
                                        //     BoxDecoration(color: widget.color.withOpacity(0.05)),
                                        child: Column(
                                            mainAxisAlignment: isFirst
                                                ? MainAxisAlignment.start
                                                : MainAxisAlignment.center,
                                            children: [
                                              !isFirst
                                                  ? Animate(
                                                      child: Stack(
                                                        children: [
                                                          SizedBox(
                                                            height: 100.h,
                                                            width: 100.w,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Lottie.asset(
                                                                    "assets/animations/bomb.json",
                                                                    height:
                                                                        20.h),
                                                                SizedBox(
                                                                    height:
                                                                        1.h),
                                                                setText(
                                                                    "The bomb was passed!",
                                                                    FontWeight
                                                                        .w600,
                                                                    16.sp,
                                                                    fontColor),
                                                                setText(
                                                                    "Wait for opponent to pass it back",
                                                                    FontWeight
                                                                        .w500,
                                                                    13.sp,
                                                                    fontColor
                                                                        .withOpacity(
                                                                            0.6)),
                                                              ],
                                                            ),
                                                          ),
                                                          Animate(
                                                                  child: Positioned(
                                                            left: 4.w,
                                                            top: 2.h,
                                                            child:
                                                                Topnotification(
                                                              powerUp:
                                                                  notificationPowerUp,
                                                              sender: sender,
                                                            ),
                                                          ))
                                                              .slideY(
                                                                  begin: -0.3,
                                                                  end:
                                                                      showNotification
                                                                          ? 0
                                                                          : -3,
                                                                  curve: Curves
                                                                      .ease,
                                                                  duration:
                                                                      showNotification
                                                                          ? 400
                                                                              .ms
                                                                          : 700
                                                                              .ms)
                                                              .fadeIn()
                                                        ],
                                                      ),
                                                    ).fadeIn(
                                                      delay: 200.ms,
                                                      duration: 400.ms,
                                                      begin: 0)
                                                  : Stack(
                                                      children: [
                                                        SizedBox(
                                                          width: 100.w,
                                                          height: 100.h,
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 6.h,
                                                              ),
                                                              CircularPercentIndicator(
                                                                radius: 6.h,
                                                                backgroundColor:
                                                                    fontColor
                                                                        .withOpacity(
                                                                            0.2),
                                                                animation: true,
                                                                animateFromLastPercent:
                                                                    true,
                                                                curve: Curves
                                                                    .easeOut,
                                                                animationDuration:
                                                                    400,
                                                                progressColor: progress <
                                                                        0.4
                                                                    ? const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        68,
                                                                        186,
                                                                        129)
                                                                    : progress <
                                                                            0.7
                                                                        ? Colors
                                                                            .orangeAccent
                                                                        : Colors
                                                                            .redAccent,
                                                                percent:
                                                                    progress,
                                                                center: setText(
                                                                    (timerDuration -
                                                                            timer
                                                                                .tick)
                                                                        .toString(),
                                                                    FontWeight
                                                                        .bold,
                                                                    16.sp,
                                                                    fontColor
                                                                        .withOpacity(
                                                                            0.8),
                                                                    true),
                                                              ),
                                                              SizedBox(
                                                                height: 6.h,
                                                              ),
                                                              SizedBox(
                                                                width: 92.w,
                                                                child: setText(
                                                                    '"${description[currentQuestion]}"',
                                                                    FontWeight
                                                                        .w600,
                                                                    16.sp,
                                                                    fontColor,
                                                                    true),
                                                              ),
                                                              SizedBox(
                                                                height: !isFirst
                                                                    ? 8.h
                                                                    : 6.h,
                                                              ),
                                                              setText(
                                                                  "The bomb is passed to you!!!",
                                                                  FontWeight
                                                                      .w600,
                                                                  15.sp,
                                                                  fontColor),
                                                              SizedBox(
                                                                  height: 5.h),
                                                              SizedBox(
                                                                width: 92.w,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Container(
                                                                      width:
                                                                          70.w,
                                                                      height:
                                                                          7.h,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(12),
                                                                        color: preferences.getBool("isDarkMode") ==
                                                                                true
                                                                            ? Color.fromARGB(
                                                                                255,
                                                                                53,
                                                                                39,
                                                                                87)
                                                                            : Colors.white,
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            TextFormField(
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                "magnet",
                                                                            fontSize:
                                                                                15.sp,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color:
                                                                                fontColor,
                                                                          ),
                                                                          decoration:
                                                                              InputDecoration(
                                                                            counterStyle:
                                                                                TextStyle(fontSize: 0),
                                                                            hintStyle:
                                                                                TextStyle(
                                                                              fontFamily: "magnet",
                                                                              fontSize: 15.sp,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: fontColor.withOpacity(0.3),
                                                                            ),
                                                                            hintText:
                                                                                "Answer here...",
                                                                            border:
                                                                                InputBorder.none,
                                                                            contentPadding:
                                                                                EdgeInsets.all(10),
                                                                          ),
                                                                          maxLength:
                                                                              70,
                                                                          controller:
                                                                              inputController,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width:
                                                                          20.w,
                                                                      height:
                                                                          7.h,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              12),
                                                                          color:
                                                                              Color(0xff0EB29A)),
                                                                      child: TextButton(
                                                                          style: OutlinedButton.styleFrom(padding: EdgeInsets.zero, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12)))),
                                                                          onPressed: () {
                                                                            timer.cancel();
                                                                            if (words[currentQuestion] == inputController.text.trim() ||
                                                                                isFriendlyBomb) {
                                                                              if (words.length == currentQuestion) {
                                                                                winCondition();
                                                                              }

                                                                              if (mounted) {
                                                                                setState(() {
                                                                                  isFirst = false;
                                                                                  currentQuestion++;
                                                                                });
                                                                                socketService.sendMessage(socketService.matchid, inputController.text, "answer_bombRelay");

                                                                                socketService.sendMessage(socketService.matchid, currentQuestion.toString(), "points");
                                                                                addPoints(preferences.getString("userName")!, currentQuestion.toString());
                                                                                FocusManager.instance.primaryFocus?.unfocus();
                                                                              }
                                                                            } else {
                                                                              socketService.sendMessage(socketService.matchid, "", "ILOST");
                                                                              hasLost();
                                                                            }
                                                                            inputController.clear();
                                                                          },
                                                                          child: FittedBox(
                                                                            fit:
                                                                                BoxFit.scaleDown,
                                                                            child: setText(
                                                                                "Send",
                                                                                FontWeight.w600,
                                                                                15.sp,
                                                                                Colors.white),
                                                                          )),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        if (isVisible)
                                                          GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  _width = 12.w;
                                                                  _height =
                                                                      12.w;
                                                                  isVisible =
                                                                      false;
                                                                  bgOpacity = 0;
                                                                });
                                                              },
                                                              child:
                                                                  AnimatedOpacity(
                                                                opacity:
                                                                    bgOpacity,
                                                                duration: Duration(
                                                                    milliseconds:
                                                                        200),
                                                                child:
                                                                    Container(
                                                                  width: 100.w,
                                                                  height: 100.h,
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.3),
                                                                ),
                                                              )),
                                                        Positioned(
                                                            right: 3.w,
                                                            bottom: 2.5.h,
                                                            child:
                                                                AnimatedContainer(
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      300),
                                                              padding: EdgeInsets
                                                                  .all(_width >
                                                                          12.w
                                                                      ? 15
                                                                      : 0),
                                                              constraints:
                                                                  BoxConstraints(
                                                                      minWidth:
                                                                          _width,
                                                                      minHeight:
                                                                          _height),
                                                              curve:
                                                                  Curves.ease,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12)),
                                                              child: TextButton(
                                                                style:
                                                                    buttonStyle(
                                                                        12),
                                                                onPressed: () {
                                                                  if (_width ==
                                                                      12.w) {
                                                                    setState(
                                                                        () {
                                                                      _width =
                                                                          70.w;

                                                                      _height =
                                                                          20.h;
                                                                    });

                                                                    Timer(
                                                                        Duration(
                                                                            milliseconds:
                                                                                150),
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        isVisible =
                                                                            true;
                                                                      });
                                                                    });
                                                                    Timer(
                                                                        Duration(
                                                                            milliseconds:
                                                                                200),
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        bgOpacity =
                                                                            1;
                                                                      });
                                                                    });

                                                                    return;
                                                                  }
                                                                  closeBg();
                                                                },
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    if (_width <
                                                                        13.w)
                                                                      Animate(
                                                                        child: Image
                                                                            .asset(
                                                                          "assets/images/power.png",
                                                                          width:
                                                                              9.w,
                                                                        ),
                                                                      ).fadeIn(),
                                                                    if (isVisible)
                                                                      Animate(
                                                                        child:
                                                                            Wrap(
                                                                          alignment:
                                                                              WrapAlignment.center,
                                                                          spacing:
                                                                              7.w,
                                                                          runSpacing:
                                                                              2.h,
                                                                          children: [
                                                                            for (int i = 0;
                                                                                i < powerUps.length;
                                                                                i++)
                                                                              Column(
                                                                                children: [
                                                                                  Container(
                                                                                    width: 17.w,
                                                                                    height: 17.w,
                                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: const Color.fromARGB(255, 244, 244, 244)),
                                                                                    child: TextButton(
                                                                                        style: buttonStyle(12),
                                                                                        onPressed: () {
                                                                                          switch (powerUps[i].name) {
                                                                                            case "Extended Time":
                                                                                              if (extendedTimeCount >= 3) {
                                                                                                showAlertModal(context, "Extended Time can only be used 3 times per match");
                                                                                                return;
                                                                                              }

                                                                                              extendTimer();
                                                                                              socketService.sendMessage(socketService.matchid, "", "EXTENDTIMER");
                                                                                              closeBg();
                                                                                              break;
                                                                                            case "Friendly Bomb":
                                                                                              friednlyBomb();

                                                                                              socketService.sendMessage(socketService.matchid, "", "FRIENDLYBOMB");
                                                                                              closeBg();

                                                                                              break;
                                                                                            default:
                                                                                              break;
                                                                                          }
                                                                                        },
                                                                                        child: Image.asset(
                                                                                          powerUps[i].iconPath,
                                                                                          height: 12.w,
                                                                                        )),
                                                                                  ),
                                                                                  SizedBox(height: 1.h),
                                                                                  setText(powerUps[i].count.toString(), FontWeight.bold, 14.sp, Color(0xff32356D))
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
                                                          child:
                                                              Topnotification(
                                                            powerUp:
                                                                notificationPowerUp,
                                                            sender: sender,
                                                          ),
                                                        ))
                                                            .slideY(
                                                                begin: -0.3,
                                                                end:
                                                                    showNotification
                                                                        ? 0
                                                                        : -3,
                                                                curve:
                                                                    Curves.ease,
                                                                duration:
                                                                    showNotification
                                                                        ? 400.ms
                                                                        : 700
                                                                            .ms)
                                                            .fadeIn()
                                                      ],
                                                    )
                                            ]),
                                      )),
          ),
        ));
  }

  List<PowerUp> powerUps = [];
  double _width = 12.w;
  int extendedTimeCount = 0;

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

  alert(String text) {
    powerUpTimer.cancel();

    playSound('audio/enemyPowerUp.mp3');

    setState(() {
      showNotification = true;
    });

    powerUpTimer = Timer(Duration(seconds: 6), () {
      setState(() {
        showNotification = false;
      });
    });
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
      timerDuration += 10;
      // extendedTimeCount++;
    });
  }

  playAgain() {
    // socketService.disconnect();
    Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
            builder: (BuildContext context) => Inputlevel(
                  color: widget.color,
                  playAgain: true,
                  gameStat: widget.gameStat,
                  updateStats: widget.updateStats,
                )));
  }

  closeBg() {
    setState(() {
      _width = 12.w;
      _height = 12.w;
      bgOpacity = 0;
      isVisible = false;
    });
  }

  friednlyBomb([sender1]) {
    for (var powerUp in powerUps) {
      if (powerUp.name == "Friendly Bomb") {
        if (powerUp.count <= 0) return;
      }
    }
    updatePowerUpCount("Friendly Bomb");

    powerUpTimer.cancel();
    if (sender1 != null) {
      sender = sender1.toString();
      playSound('audio/enemyPowerUp.mp3');
    } else {
      sender = preferences.getString("userName")!;
      playSound('audio/powerUp.mp3');
    }
    for (var powerUp in powerUps) {
      if (powerUp.name == "Friendly Bomb") {
        setState(() {
          notificationPowerUp = powerUp;
          showNotification = true;
          sender = sender.toString();
        });
      }

      powerUpTimer = Timer(Duration(seconds: 6), () {
        setState(() {
          showNotification = false;
        });
      });
    }

    setState(() {
      isFriendlyBomb = true;
    });
  }

  void updatePowerUpCount(String name) async {
    for (var powerUp in powerUps) {
      if (powerUp.name == name) {
        powerUp = PowerUp(
            id: powerUp.id,
            price: powerUp.price,
            count: powerUp.count - 1,
            iconPath: powerUp.iconPath,
            description: powerUp.description,
            game: powerUp.game,
            name: powerUp.name);
        await updatePowerUp(powerUp.id, powerUp.count - 1);
      }
    }
    if (mounted) setState(() {});
  }
}
