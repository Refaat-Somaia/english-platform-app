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
import 'package:funlish_app/model/player.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:funlish_app/utility/socketIoClient.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';

class Inputlevel extends StatefulWidget {
  final Color color;
  final int timerDuration;
  const Inputlevel(
      {super.key, required this.color, required this.timerDuration});

  @override
  State<Inputlevel> createState() => _InputlevelState();
}

class _InputlevelState extends State<Inputlevel>
    with SingleTickerProviderStateMixin {
  List<bool> isVoted = [false, false, false];
  List<int> votesCount = [0, 0, 0];
  List<String> answers = [];
  List<bool> hasAnswered = [];
  int currentQuestion = 0;
  String sentence = "";
  late AnimationController animationController;
  List<Player> players = [];
  bool isLoading = true;
  bool isTimeUp = false;
  bool isCountDown = false;
  bool isWon = false;
  bool isLost = false;
  bool isDraw = false;
  bool isFirst = true;
  List<dynamic> words = [];
  List<dynamic> description = [];
  late SocketService socketService;
  final TextEditingController inputController = TextEditingController();
  Timer timer = Timer(Duration(), () {});
  Timer timerPreMatch = Timer(Duration(), () {});
  double progress = 0;
  void updateLoading() {
    animationController.reverse();

    Timer(Duration(milliseconds: 300), () {
      isCountDown = true;
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
        if (isFirst) startTimer();
      }
    });
  }

  void addPoints(String name, String points) {
    players.forEach((player) {
      print(player);

      if (player.name == name) {
        setState(() {
          player.points = int.parse(points);
        });
      }
    });
  }

  void hasLost() {
    if (mounted) {
      setState(() {
        isLost = true;
      });
    }
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

    timer = Timer.periodic(Duration(seconds: 1), (time) {
      print(time.tick);
      print(isFirst); // Corrected from `timer.tick`
      // Corrected from `timer.tick`

      if (time.tick <= widget.timerDuration) {
        if (mounted) {
          setState(() {
            progress = (time.tick / widget.timerDuration);
          });
        }
      } else {
        time.cancel();
        if (!(isLost || isWon)) {
          int max = players.fold(
              0, (max, player) => player.points > max ? player.points : max);

          if (max < currentQuestion) {
            setState(() {
              isWon = true;
            });
            socketService.sendMessage(socketService.matchid, "", "IWON");
            return;
          }
          setState(() {
            isLost = true;
          });
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
    });
    if (words.length == currentQuestion) {
      socketService.sendMessage(socketService.matchid, "", "DRAW");
      hasDraw();
    }
    if (!isCountDown && isFirst) startTimer();
  }

  void hasWon() {
    setState(() {
      isWon = true;
      timer.cancel();
    });
  }

  void hasDraw() {
    setState(() {
      isDraw = true;
      timer.cancel();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
          addSentence: () {},
          hasDraw: hasDraw,
          hasLost: hasLost,
          hasWon: hasWon,
          addWord: addWord,
          showAlert: () {
            showAlertModal(context, "Opponent has left");
          });
    }
    socketService.connect();
    socketService.findMatch("bombRelay");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

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
          child: Container(
              decoration: BoxDecoration(
                  // color: widget.chapter.colorAsColor.withOpacity(0.05),
                  color: widget.color.withOpacity(0.05)),
              height: double.infinity,
              width: 100.w,
              child: isLoading
                  ? Animate(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LoadingAnimationWidget.staggeredDotsWave(
                              color: widget.color, size: 18.w),
                          SizedBox(height: 1.h),
                          setText("Waiting for players...", FontWeight.w600,
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
                                                    child: Column(
                                                      children: [
                                                        Lottie.asset(
                                                            "assets/animations/bomb.json",
                                                            height: 20.h),
                                                        SizedBox(height: 1.h),
                                                        setText(
                                                            "The the bomb was passed!",
                                                            FontWeight.w600,
                                                            16.sp,
                                                            fontColor),
                                                        setText(
                                                            "Wait for opponent to pass it back",
                                                            FontWeight.w500,
                                                            13.sp,
                                                            fontColor
                                                                .withOpacity(
                                                                    0.6)),
                                                      ],
                                                    ),
                                                  ).fadeIn(
                                                    delay: 200.ms,
                                                    duration: 400.ms,
                                                    begin: 0)
                                                : Column(
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
                                                        curve: Curves.easeOut,
                                                        animationDuration: 400,
                                                        progressColor: progress <
                                                                0.4
                                                            ? const Color
                                                                .fromARGB(255,
                                                                68, 186, 129)
                                                            : progress < 0.7
                                                                ? Colors
                                                                    .orangeAccent
                                                                : Colors
                                                                    .redAccent,
                                                        percent: progress,
                                                        center: setText(
                                                            (widget.timerDuration -
                                                                    timer.tick)
                                                                .toString(),
                                                            FontWeight.bold,
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
                                                            FontWeight.w600,
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
                                                          FontWeight.w600,
                                                          15.sp,
                                                          fontColor),
                                                      SizedBox(height: 5.h),
                                                      SizedBox(
                                                        width: 92.w,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              width: 70.w,
                                                              height: 7.h,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  color: Colors
                                                                      .white),
                                                              child: Center(
                                                                child:
                                                                    TextFormField(
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        "magnet",
                                                                    fontSize:
                                                                        15.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color:
                                                                        fontColor,
                                                                  ),
                                                                  decoration:
                                                                      InputDecoration(
                                                                    counterStyle:
                                                                        TextStyle(
                                                                            fontSize:
                                                                                0),
                                                                    hintStyle:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          "magnet",
                                                                      fontSize:
                                                                          15.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: fontColor
                                                                          .withOpacity(
                                                                              0.3),
                                                                    ),
                                                                    hintText:
                                                                        "Answer here...",
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    contentPadding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                  ),
                                                                  maxLength: 70,
                                                                  controller:
                                                                      inputController,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              width: 20.w,
                                                              height: 7.h,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  color: Color(
                                                                      0xff0EB29A)),
                                                              child: TextButton(
                                                                  style: OutlinedButton.styleFrom(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                      shape: const RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              12)))),
                                                                  onPressed:
                                                                      () {
                                                                    timer
                                                                        .cancel();
                                                                    if (words[
                                                                            currentQuestion] ==
                                                                        inputController
                                                                            .text) {
                                                                      if (words
                                                                              .length ==
                                                                          currentQuestion) {
                                                                        winCondition();
                                                                      }
                                                                      socketService.sendMessage(
                                                                          socketService
                                                                              .matchid,
                                                                          inputController
                                                                              .text,
                                                                          "answer_bombRelay");
                                                                      if (mounted) {
                                                                        setState(
                                                                            () {
                                                                          isFirst =
                                                                              false;
                                                                          currentQuestion++;
                                                                        });
                                                                        FocusManager
                                                                            .instance
                                                                            .primaryFocus
                                                                            ?.unfocus();
                                                                      }
                                                                    } else {
                                                                      socketService.sendMessage(
                                                                          socketService
                                                                              .matchid,
                                                                          "",
                                                                          "ILOST");
                                                                      setState(
                                                                          () {
                                                                        isLost =
                                                                            true;
                                                                      });
                                                                    }
                                                                    inputController
                                                                        .clear();
                                                                  },
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .scaleDown,
                                                                    child: setText(
                                                                        "Send",
                                                                        FontWeight
                                                                            .w600,
                                                                        15.sp,
                                                                        Colors
                                                                            .white),
                                                                  )),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                          ]),
                                    )),
        ));
  }

  void winCondition() {
    socketService.sendMessage(socketService.matchid, "", "IWON");
    setState(() {
      isWon = true;
    });
    timer.cancel();
  }

  Widget TeammateCard(int index) {
    return Column(
      children: [
        setText(players[index].name, FontWeight.w600, 15.sp,
            fontColor.withOpacity(0.6)),
        Image.asset(
          "assets/images/mascot-avatar.png",
          width: 35.w,
        ),
        SizedBox(height: 2.h),
        setText("Answer:", FontWeight.w600, 13.sp, fontColor.withOpacity(0.4)),
        SizedBox(height: 0.5.h),
        setText(answers[index], FontWeight.bold, 18.sp, fontColor),
        setText("Votes: ${votesCount[index]}", FontWeight.w500, 14.sp,
            fontColor.withOpacity(0.6)),
        SizedBox(height: 2.h),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: 40.w,
          height: 6.h,
          decoration: BoxDecoration(
              color: isVoted[index] ? Colors.white : Color(0xff0EB29A),
              borderRadius: BorderRadius.circular(12)),
          child: TextButton(
            style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)))),
            onPressed: () {
              if (mounted) {
                setState(() {
                  isVoted[index] = !(isVoted[index]);
                  isVoted[index] ? votesCount[index]++ : votesCount[index]--;
                });
              }
            },
            child: setText(
                isVoted[index] ? "Voted" : "Vote",
                FontWeight.w600,
                15.sp,
                isVoted[index] ? fontColor.withOpacity(0.7) : Colors.white),
          ),
        )
      ],
    );
  }

  playAgain() {
    socketService.disconnect();
    Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
            builder: (BuildContext context) =>
                Inputlevel(color: widget.color, timerDuration: 15)));
  }
}
