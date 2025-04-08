import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:funlish_app/model/learnedWord.dart';
import 'package:funlish_app/model/level.dart';
import 'package:funlish_app/model/userProgress.dart';
import 'package:funlish_app/utility/databaseHandler.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:uuid/uuid.dart';
import '../../model/Chapter.dart';

class Listeninglevel extends StatefulWidget {
  final Chapter chapter;
  final McqLevel level;
  final List<String> words;

  final Map<String, IconData> icons;
  final Function updateChapters;
  final Function updateLevels;
  const Listeninglevel(
      {super.key,
      required this.chapter,
      required this.level,
      required this.updateChapters,
      required this.updateLevels,
      required this.words,
      required this.icons});

  @override
  State<Listeninglevel> createState() => _ListeninglevelState();
}

class _ListeninglevelState extends State<Listeninglevel>
    with SingleTickerProviderStateMixin {
  @override
  List<String> options = ["", "", "", ""];

  List<bool> isPressed = [false, false, false, false];
  String answered = "";
  double _width = 0;
  int stars = 3;
  late AnimationController animationController;
  bool isSpeaking = false;
  bool started = false;
  String description = "";
  late Timer timer;
  FlutterTts flutterTts = FlutterTts();
  // final ChapterController chapterController = Get.find();

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    description = widget.level.description;
    options = getRandomWords(widget.words, widget.level.word);
    initTTS();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _showModalBottomSheet(context, "");
    });
  }

  Future<void> initTTS() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    // Ensure TTS waits for completion
    await flutterTts.awaitSpeakCompletion(true);

    try {
      flutterTts.setStartHandler(() {
        setState(() => isSpeaking = true);
      });

      flutterTts.setCompletionHandler(() {
        setState(() => isSpeaking = false);
      });

      flutterTts.setErrorHandler((msg) {
        print('TTS Error: $msg');
        setState(() => isSpeaking = false);
      });

      print("TTS Engine Initialized Successfully!");
    } catch (e) {
      print('TTS Initialization Error: $e');
    }
  }

  Future<void> speak(String text) async {
    if (isSpeaking) return; // Prevent overlapping speech

    int engineAvailable = await flutterTts.isLanguageAvailable("en-US") ? 1 : 0;
    if (engineAvailable == 0) {
      print("TTS Engine is not ready yet!");
      await initTTS(); // Re-initialize if needed
      return;
    }

    try {
      await flutterTts.speak(text);
    } catch (e) {
      print('TTS Speak Error: $e');
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    timer.cancel();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          // color: widget.chapter.colorAsColor.withOpacity(0.05),
          color: bodyColor),
      height: double.infinity,
      width: 100.w,
      child: !started
          ? Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 4.w,
                  top: 3.h,
                  child: Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        // border: Border.all(
                        //     width: 1.5, color: fontColor.withOpacity(0.2))
                        color: primaryPurple),
                    child: IconButton(
                        style: IconButton.styleFrom(padding: EdgeInsets.zero),
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
                Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30.h,
                    ),
                    Animate(
                            child: Image.asset('assets/images/mascot-timer.png',
                                height: 20.h))
                        .slideX(
                            begin: -0.3,
                            end: 0,
                            curve: Curves.ease,
                            duration: 300.ms,
                            delay: 300.ms)
                        .fadeIn(),
                    SizedBox(
                      height: 2.h,
                    ),
                    Animate(
                      child: setText("Start when ready 🧐", FontWeight.w600,
                          17.sp, fontColor),
                    ).fadeIn(delay: 300.ms),
                    SizedBox(
                      height: 0.5.h,
                    ),
                    Animate(
                      child: SizedBox(
                        width: 90.w,
                        child: setText(
                            "Stars will be given based on speed of answering.",
                            FontWeight.w500,
                            13.sp,
                            fontColor.withOpacity(0.6),
                            true),
                      ),
                    ).fadeIn(delay: 500.ms),
                    SizedBox(
                      height: 29.h,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: primaryPurple),
                      width: 89.w,
                      height: 6.5.h,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            started = true;
                          });

                          timer = Timer.periodic(Duration(seconds: 1), (time) {
                            if (time.tick <= 30) {
                              setState(() {
                                _width = (time.tick / 30) * 90.w;
                              });
                            } else {
                              time.cancel();
                            }
                          });
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: primaryPurple,
                            padding: EdgeInsets.all(0)),
                        child: setText(
                            "Start", FontWeight.w600, 15.sp, Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Container(
              decoration: BoxDecoration(color: bodyColor),
              child: Column(
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Stack(
                    children: [
                      Container(
                        width: 90.w,
                        height: 1.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: fontColor.withOpacity(0.1)),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        width: _width,
                        height: 1.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: _width > 60.w
                                ? Colors.redAccent
                                : _width > 30.w
                                    ? Colors.orangeAccent
                                    : const Color.fromARGB(255, 68, 186, 129)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Animate(
                    child: SizedBox(
                      width: 92.w,
                      child: GestureDetector(
                        onTap: () {
                          animationController.forward();
                          speak(widget.level.description);
                        },
                        child: Lottie.asset(
                          'assets/animations/speaker.json',
                          controller: animationController,
                          height: 25.h,
                        ),
                      ),
                    ),
                  ).fadeIn(begin: 0, delay: 300.ms, duration: 500.ms),
                  SizedBox(
                    height: 5.h,
                  ),
                  SizedBox(
                    width: 85.w,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    answered = options[0];
                                    isPressed[0] = true;
                                  });
                                  if (options[0] == widget.level.word) {
                                    await answeredCorrectly();

                                    _showModalBottomSheet(context);
                                    setState(() {
                                      timer.cancel();
                                    });
                                  } else {
                                    stars--;
                                  }
                                },
                                child: Animate(
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 1.w),
                                    width: 40.w,
                                    height: 9.h,
                                    decoration: BoxDecoration(
                                        color: isPressed[0] &&
                                                options[0] == widget.level.word
                                            ? widget.chapter.colorAsColor
                                            : isPressed[0] &&
                                                    options[0] !=
                                                        widget.level.word
                                                ? Colors.redAccent
                                                    .withOpacity(0.3)
                                                : Colors.transparent,
                                        borderRadius: BorderRadius.circular(16),
                                        // color: widget.chapter.colorAsColor,
                                        border: Border.all(
                                            width: 2,
                                            color: widget.chapter.colorAsColor
                                                .withOpacity(0.5))),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: widget.icons.isNotEmpty
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  widget.icons[options[0]],
                                                  color: fontColor,
                                                ),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                setText(
                                                    options[0],
                                                    FontWeight.w600,
                                                    15.sp,
                                                    fontColor),
                                              ],
                                            )
                                          : setText(options[0], FontWeight.w600,
                                              15.sp, fontColor),
                                    ),
                                  ),
                                )
                                    .fadeIn(
                                        duration: 300.ms,
                                        curve: Curves.ease,
                                        delay: (200).ms)
                                    .scaleXY(
                                        begin: 0.6,
                                        end: 1,
                                        curve: Curves.ease,
                                        duration: 300.ms,
                                        delay: (150).ms)),
                            GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    answered = options[1];
                                    isPressed[1] = true;
                                  });
                                  if (options[1] == widget.level.word) {
                                    await answeredCorrectly();

                                    _showModalBottomSheet(context);
                                    setState(() {
                                      timer.cancel();
                                    });
                                  } else {
                                    stars--;
                                  }
                                },
                                child: Animate(
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 1.w),
                                    curve: Curves.easeOut,
                                    width: 40.w,
                                    height: 9.h,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: isPressed[1] &&
                                                options[1] == widget.level.word
                                            ? widget.chapter.colorAsColor
                                            : isPressed[1] &&
                                                    options[1] !=
                                                        widget.level.word
                                                ? Colors.redAccent
                                                    .withOpacity(0.3)
                                                : Colors.transparent,
                                        border: Border.all(
                                            width: 2,
                                            color: widget.chapter.colorAsColor
                                                .withOpacity(0.5))),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: widget.icons.isNotEmpty
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  widget.icons[options[1]],
                                                  color: fontColor,
                                                ),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                setText(
                                                    options[1],
                                                    FontWeight.w600,
                                                    15.sp,
                                                    fontColor),
                                              ],
                                            )
                                          : setText(options[1], FontWeight.w600,
                                              15.sp, fontColor),
                                    ),
                                  ),
                                )
                                    .fadeIn(
                                        duration: 300.ms,
                                        curve: Curves.ease,
                                        delay: (300).ms)
                                    .scaleXY(
                                        begin: 0.6,
                                        end: 1,
                                        curve: Curves.ease,
                                        duration: 300.ms,
                                        delay: (250).ms)),
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    answered = options[2];
                                    isPressed[2] = true;
                                  });

                                  if (options[2] == widget.level.word) {
                                    await answeredCorrectly();

                                    _showModalBottomSheet(context);

                                    setState(() {
                                      timer.cancel();
                                    });
                                  } else {
                                    stars--;
                                  }
                                },
                                child: Animate(
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 1.w),
                                    width: 40.w,
                                    height: 9.h,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        // color: widget.chapter.colorAsColor,
                                        color: isPressed[2] &&
                                                options[2] == widget.level.word
                                            ? widget.chapter.colorAsColor
                                            : isPressed[2] &&
                                                    options[2] !=
                                                        widget.level.word
                                                ? Colors.redAccent
                                                    .withOpacity(0.3)
                                                : Colors.transparent,
                                        border: Border.all(
                                            width: 2,
                                            color: widget.chapter.colorAsColor
                                                .withOpacity(0.5))),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: widget.icons.isNotEmpty
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  widget.icons[options[2]],
                                                  color: fontColor,
                                                ),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                setText(
                                                    options[2],
                                                    FontWeight.w600,
                                                    15.sp,
                                                    fontColor),
                                              ],
                                            )
                                          : setText(options[2], FontWeight.w600,
                                              15.sp, fontColor),
                                    ),
                                  ),
                                )
                                    .fadeIn(
                                        duration: 300.ms,
                                        curve: Curves.ease,
                                        delay: (400).ms)
                                    .scaleXY(
                                        begin: 0.6,
                                        end: 1,
                                        curve: Curves.ease,
                                        duration: 300.ms,
                                        delay: (350).ms)),
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  answered = options[3];
                                  isPressed[3] = true;
                                });
                                if (options[3] == widget.level.word) {
                                  await answeredCorrectly();

                                  _showModalBottomSheet(context);
                                  setState(() {
                                    timer.cancel();
                                  });
                                } else {
                                  stars--;
                                }
                              },
                              child: Animate(
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 1.w),
                                  width: 40.w,
                                  height: 9.h,
                                  decoration: BoxDecoration(
                                      color: isPressed[3] &&
                                              options[3] == widget.level.word
                                          ? widget.chapter.colorAsColor
                                          : isPressed[3] &&
                                                  options[3] !=
                                                      widget.level.word
                                              ? Colors.redAccent
                                                  .withOpacity(0.3)
                                              : Colors.transparent,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                          width: 2,
                                          color: widget.chapter.colorAsColor
                                              .withOpacity(0.5))),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: widget.icons.isNotEmpty
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                widget.icons[options[3]],
                                                color: fontColor,
                                              ),
                                              SizedBox(
                                                width: 2.w,
                                              ),
                                              setText(
                                                  options[3],
                                                  FontWeight.w600,
                                                  15.sp,
                                                  fontColor),
                                            ],
                                          )
                                        : setText(options[3], FontWeight.w600,
                                            15.sp, fontColor),
                                  ),
                                ),
                              )
                                  .fadeIn(
                                      duration: 300.ms,
                                      curve: Curves.ease,
                                      delay: (500).ms)
                                  .scaleXY(
                                      begin: 0.6,
                                      end: 1,
                                      curve: Curves.ease,
                                      duration: 300.ms,
                                      delay: (450).ms),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),
    ));
  }

  bool isSaved = false;
  void updateSaved() {
    setState(() {
      isSaved = true;
    });
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16))),
                height: 50.h,
                width: 100.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/animations/Success.json',
                        width: 50.w, repeat: false),
                    SizedBox(
                      height: 1.h,
                    ),
                    setText("Correct answer!", FontWeight.w600, 14.sp,
                        fontColor.withOpacity(0.6)),
                    SizedBox(
                      height: 2.h,
                    ),
                    widget.icons.isNotEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                widget.icons[answered],
                                color: widget.chapter.colorAsColor,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              setText(answered, FontWeight.w600, 15.sp,
                                  widget.chapter.colorAsColor),
                            ],
                          )
                        : setText(answered, FontWeight.w600, 15.sp,
                            widget.chapter.colorAsColor),
                    SizedBox(
                      height: 4.h,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 13.w,
                            height: 13.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  width: 1.5,
                                  color: primaryPurple.withOpacity(0.2)),
                            ),
                            child: IconButton(
                                style: buttonStyle(12),
                                onPressed: () {
                                  speak(widget.level.word);
                                },
                                icon: Icon(
                                  FontAwesomeIcons.microphone,
                                  size: 6.w,
                                  color: primaryPurple,
                                )),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: primaryPurple),
                            width: 45.w,
                            height: 13.w,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                // Navigator.pushReplacement(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (BuildContext context) => LevelsMenu(
                                //       chapter: chapters[widget.chapter.id - 1],
                                //     ),
                                //   ),
                                // );
                              },
                              style: buttonStyle(14),
                              child: setText(
                                  "Ok", FontWeight.w600, 15.sp, Colors.white),
                            ),
                          ),
                          Container(
                            width: 13.w,
                            height: 13.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  width: 1.5,
                                  color: primaryPurple.withOpacity(0.2)),
                            ),
                            child: IconButton(
                                style: buttonStyle(12),
                                onPressed: () {
                                  if (isSaved) return;
                                  addLearnedWordsToDB(Learnedword(
                                      id: Uuid().v4(),
                                      word: widget.level.word,
                                      type: "listen",
                                      description: widget.level.description));
                                  updateSaved();
                                },
                                icon: AnimatedSwitcher(
                                  duration: Duration(milliseconds: 300),
                                  child: Icon(
                                    isSaved
                                        ? FontAwesomeIcons.check
                                        : FontAwesomeIcons.folderPlus,
                                    size: 6.w,
                                    color: primaryPurple,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  Future<void> answeredCorrectly() async {
    final user = Provider.of<UserProgress>(context, listen: false);

    if (_width > 60.w) {
      stars -= 2;
    } else if (_width > 30.w) {
      stars--;
    }

    Chapter updatedChapater = Chapter(
        id: chapters[widget.chapter.id - 1].id,
        name: chapters[widget.chapter.id - 1].name,
        description: chapters[widget.chapter.id - 1].description,
        levelCount: chapters[widget.chapter.id - 1].levelCount,
        pointsCollected: chapters[widget.chapter.id - 1].pointsCollected +
            widget.level.points,
        starsCollected: chapters[widget.chapter.id - 1].starsCollected +
            (stars < 1 ? 1 : stars),
        levelsPassed: chapters[widget.chapter.id - 1].levelsPassed +
            (widget.level.isPassed == 0 ? 1 : 0),
        color: chapters[widget.chapter.id - 1].color);
    setState(() {
      chapters[widget.chapter.id - 1] = updatedChapater;
    });

    McqLevel updatedLevel = McqLevel(
        chapterId: widget.level.chapterId,
        id: widget.level.id,
        arabicDescription: widget.level.arabicDescription,
        levelType: widget.level.levelType,
        stars: stars < 1 ? 1 : stars,
        points: 30,
        isReset: widget.level.isReset,
        isPassed: 1,
        description: widget.level.description,
        word: widget.level.word);

    for (int i = 0; i < mcqLevels.length; i++) {
      if (mcqLevels[i].id == updatedLevel.id) {
        setState(() {
          mcqLevels[i] = updatedLevel;
        });
      }
    }
    setState(() {
      mcqLevels;
    });
    if (preferences.getInt("userPoints") == null) {
      user.addXP(widget.level.points);
    } else {
      if (widget.level.isReset == 0 && widget.level.isPassed == 0) {
        user.addXP(widget.level.points);
      }
    }
    updateChapterInDB(updatedChapater);
    updateMcqLevelInDB(updatedLevel);
    widget.updateLevels(mcqLevels);
    widget.updateChapters(chapters);
  }
}
