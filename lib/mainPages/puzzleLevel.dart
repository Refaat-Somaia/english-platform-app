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
import 'package:funlish_app/model/player.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:funlish_app/utility/socketIoClient.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';

extension Shuffle on String {
  String get shuffled => (characters.toList()..shuffle()).join();
}

class Puzzlelevel extends StatefulWidget {
  final Color color;
  final int timerDuration;
  const Puzzlelevel(
      {super.key, required this.color, required this.timerDuration});

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
  List<dynamic> words = [];
  List<dynamic> description = [];
  List<String> shuffledWord = [];
  int correctAnswers = 0;
  List<bool> hasAnswered = [];
  List<List<String?>> droppedWords = [];
  Timer timer = Timer(Duration(), () {});
  Timer timerPreMatch = Timer(Duration(), () {});
  List<Player> players = [];
  bool isLoading = true;
  bool isTimeUp = false;
  bool isCountDown = false;
  bool isWon = false;
  bool isLost = false;
  bool isDraw = false;

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
        startTimer();
      }
    });
  }

  void addPoints(String name, String points) {
    players.forEach((player) {
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

  void addWord(List<dynamic> word1, List<dynamic> description1) {
    if (mounted) {
      setState(() {
        words = word1;
        description = description1;
        for (int i = 0; i < words.length; i++) {
          words[i] = words[i].toString().toLowerCase();
          droppedWords.add(List.filled(words[i].length, ""));
          shuffledWord.add(words[i].toString().shuffled);
          hasAnswered.add(false);
        }
      });
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (time) {
      if (time.tick <= widget.timerDuration) {
        if (mounted) {
          setState(() {
            progress = (time.tick / widget.timerDuration);
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
            setState(() {
              isWon = true;
            });
            socketService.sendMessage(socketService.matchid, "", "IWON");
            return;
          }
          setState(() {
            isDraw = true;
          });
        }
      }
    });
  }

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    animationController.forward();
    // TODO: implement initState
    socketService = SocketService(
        updateLoading: updateLoading,
        addAnswer: () {},
        setFirst: () {},
        hasWon: () {},
        addWord: addWord,
        updatePlayers: updatePlayers,
        hasLost: hasLost,
        addSentence: () {},
        addPoints: addPoints,
        showAlert: () {
          showAlertModal(context, "Opponent has left");
        });
    super.initState();

    socketService.connect();

    socketService.findMatch("wordPuzzle");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
    timerPreMatch.cancel();
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
                    setText("Waiting for players...", FontWeight.w600, 16.sp,
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
                            function: playAgain)
                        : isDraw
                            ? Drawscreen(
                                players: players,
                                color: widget.color,
                                function: playAgain)
                            : Animate(
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
                                          (widget.timerDuration - timer.tick)
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
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 1.w),
                                              child: AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                curve: Curves.easeOut,
                                                width: 5.5.w,
                                                height: 5.5.w,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: hasAnswered[
                                                                index]
                                                            ? const Color
                                                                .fromARGB(255,
                                                                68, 186, 129)
                                                            : value == index
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
                                                      hasAnswered[index]
                                                          ? const Color
                                                              .fromARGB(
                                                              255, 68, 186, 129)
                                                          : value == index ||
                                                                  hasAnswered[
                                                                      index]
                                                              ? fontColor
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // border: Border.all(color: fontColor, width: 2),
      ),
      child: Center(
        child: setText(word, FontWeight.bold, 15.sp, fontColor),
      ),
    );
  }

  playAgain() {
    socketService.connect();
    Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
            builder: (BuildContext context) =>
                Puzzlelevel(color: widget.color, timerDuration: 60)));
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
                  if (mounted) {
                    setState(() {
                      droppedWords[index][indx] = receivedWord;
                    });
                    if (droppedWords[index].join() == words[index] &&
                        !hasAnswered[index]) {
                      setState(() {
                        correctAnswers++;
                        hasAnswered[index] = true;
                      });

                      socketService.sendMessage(socketService.matchid,
                          correctAnswers.toString(), "points");
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
                      players.forEach((player) {
                        if (player.points > max) max = player.points;
                      });
                      if (max < correctAnswers) {
                        setState(() {
                          isWon = true;
                        });
                        socketService.sendMessage(
                            socketService.matchid, "", "IWON");
                      } else {
                        setState(() {
                          isDraw = true;
                        });
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
                      color: Colors.white,
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
}
