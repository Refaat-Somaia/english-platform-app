import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:funlish_app/mainPages/chapters/mcqLevel.dart';
import 'package:funlish_app/mainPages/flashCards.dart';
import 'package:funlish_app/model/learnedWord.dart';
import 'package:funlish_app/model/level.dart';
import 'package:funlish_app/utility/databaseHandler.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

import '../../model/Chapter.dart';

class LevelsMenu extends StatefulWidget {
  final Chapter chapter;
  final Function update;
  const LevelsMenu({super.key, required this.chapter, required this.update});

  @override
  State<LevelsMenu> createState() => _LevelsMenuState();
}

class _LevelsMenuState extends State<LevelsMenu> {
  ScrollController scrollController = ScrollController();
  bool _isButtonVisible = false;
  List<String> words = [];

  Map<String, IconData> icons = {};
  double progress = 0;

  bool isLoading = true;

  void updateChpaters(List<Chapter> newChapters) {
    setState(() {
      chapters = newChapters;
      progress = chapters[widget.chapter.id - 1].levelsPassed / words.length;
    });
    widget.update(chapters);
  }

  void getMcqLevels() async {
    mcqLevels = await getMcqLevelsOfChapter(widget.chapter.id);
    words = await getWordsByChapterId(widget.chapter.id);

    setState(() {
      isLoading = false;
      progress = chapters[widget.chapter.id - 1].levelsPassed / words.length;
    });
  }

  void updateMcqLevels(List<McqLevel> newMcqLevels) {
    setState(() {
      mcqLevels = newMcqLevels;
    });
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
    getMcqLevels();
    if (chapterIcons[widget.chapter.name] != null) {
      icons = chapterIcons[widget.chapter.name]!;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // awaitDB();
      Timer(Duration(milliseconds: 1000), () {
        if (widget.chapter.levelsPassed > 3) {
          scrollController.animateTo(
              20.h * chapters[widget.chapter.id - 1].levelsPassed,
              duration: Duration(seconds: 1),
              curve: Curves.easeInOut);
        }
      });
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (scrollController.position.pixels > 200 && !_isButtonVisible) {
      setState(() {
        _isButtonVisible = true;
      });
    } else if (scrollController.position.pixels <= 200 && _isButtonVisible) {
      setState(() {
        _isButtonVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyColor,
      body: isLoading
          ? Container(
              decoration: BoxDecoration(
                color: widget.chapter.colorAsColor.withOpacity(0.06),
              ),
              child: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                    color: widget.chapter.colorAsColor, size: 18.w),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                color: widget.chapter.colorAsColor.withOpacity(0.06),
                // color: Colors.white,
              ),
              height: double.infinity,
              width: 100.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 5.h,
                      ),
                      SizedBox(
                        width: 92.w,
                        // height: 18.h,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Animate(
                              child: Image.asset(
                                'assets/images/${widget.chapter.name.toLowerCase()}/${widget.chapter.name.toLowerCase()}1.png',
                                width: 45.w,
                              ),
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
                                  widget.chapter.name,
                                  FontWeight.bold,
                                  21.sp,
                                  widget.chapter.colorAsColor),
                            ).fadeIn(begin: 0, delay: 300.ms, duration: 500.ms),
                            SizedBox(
                              height: 1.h,
                            ),
                            SizedBox(
                              width: 92.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Animate(
                                        child: SizedBox(
                                          width: 65.w,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                FontAwesomeIcons.circleCheck,
                                                size: 6.w,
                                                color:
                                                    widget.chapter.colorAsColor,
                                              ),
                                              SizedBox(
                                                width: 2.w,
                                              ),
                                              setText(
                                                  "Levels completed: ${chapters[widget.chapter.id - 1].levelsPassed}",
                                                  FontWeight.w600,
                                                  14.sp,
                                                  fontColor.withOpacity(0.6)),
                                            ],
                                          ),
                                        ),
                                      ).fadeIn(
                                          begin: 0,
                                          delay: 400.ms,
                                          duration: 300.ms),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      Animate(
                                        child: SizedBox(
                                          width: 65.w,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                FontAwesomeIcons.coins,
                                                size: 6.w,
                                                color:
                                                    widget.chapter.colorAsColor,
                                              ),
                                              SizedBox(
                                                width: 2.w,
                                              ),
                                              setText(
                                                  "Points collected: ${chapters[widget.chapter.id - 1].pointsCollected}",
                                                  FontWeight.w600,
                                                  14.sp,
                                                  fontColor.withOpacity(0.6)),
                                            ],
                                          ),
                                        ),
                                      ).fadeIn(
                                          begin: 0,
                                          delay: 600.ms,
                                          duration: 300.ms),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      Animate(
                                        child: SizedBox(
                                          width: 65.w,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.star_rounded,
                                                size: 6.w,
                                                color:
                                                    widget.chapter.colorAsColor,
                                              ),
                                              SizedBox(
                                                width: 2.w,
                                              ),
                                              setText(
                                                  "Stars collected: ${chapters[widget.chapter.id - 1].starsCollected}",
                                                  FontWeight.w600,
                                                  14.sp,
                                                  fontColor.withOpacity(0.6)),
                                            ],
                                          ),
                                        ),
                                      ).fadeIn(
                                          begin: 0,
                                          delay: 800.ms,
                                          duration: 300.ms),
                                    ],
                                  ),
                                  CircularPercentIndicator(
                                    radius: 12.w,
                                    backgroundColor: fontColor.withOpacity(0.2),
                                    animation: true,
                                    curve: Curves.easeOut,
                                    animationDuration: 800,
                                    progressColor: widget.chapter.colorAsColor,
                                    percent: progress,
                                    center: setText(
                                        "${(progress * 100).ceil()}%\nprogress",
                                        FontWeight.bold,
                                        13.sp,
                                        fontColor.withOpacity(0.8),
                                        true),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          padding: EdgeInsets.only(bottom: 4.h, top: 2.h),
                          itemCount: mcqLevels.length,
                          itemBuilder: (context, index) {
                            bool isCompleted = index <
                                chapters[widget.chapter.id - 1].levelsPassed +
                                    1;
                            return Column(
                              children: [
                                if (index != 0)
                                  CustomPaint(
                                    size: Size(20.w, 5.h),
                                    painter: DashedLinePainter(
                                        color: isCompleted
                                            ? widget.chapter.colorAsColor
                                            : fontColor.withOpacity(0.3)),
                                  ),
                                Animate(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (!isCompleted) return;

                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (BuildContext context) =>
                                                McqLevelPage(
                                                  words: words,
                                                  icons: icons,
                                                  updateChapters:
                                                      updateChpaters,
                                                  updateLevels: updateMcqLevels,
                                                  chapter: chapters[
                                                      widget.chapter.id - 1],
                                                  level: McqLevel(
                                                      id: mcqLevels[index].id,
                                                      isPassed: mcqLevels[index]
                                                          .isPassed,
                                                      arabicDescription:
                                                          mcqLevels[index]
                                                              .arabicDescription,
                                                      isReset:
                                                          mcqLevels[index]
                                                              .isReset,
                                                      stars:
                                                          mcqLevels[index]
                                                              .stars,
                                                      levelType: mcqLevels[index]
                                                          .levelType,
                                                      chapterId:
                                                          chapters[widget.chapter.id -
                                                                  1]
                                                              .id,
                                                      description: mcqLevels[
                                                              index]
                                                          .description,
                                                      word:
                                                          mcqLevels[index].word,
                                                      points: mcqLevels[index]
                                                          .points),
                                                )),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Container(
                                        //   width: 20.w,
                                        //   child: Center(
                                        //     child: Icon(
                                        //       FontAwesomeIcons.circleCheck,
                                        //       color: isCompleted
                                        //           ? widget.chapter.colorAsColor
                                        //           : fontColor.withOpacity(0.3),
                                        //     ),
                                        //   ),
                                        // ),
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              width: 62.w,
                                              height: 16.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                                color: isCompleted
                                                    ? bodyColor
                                                    : bodyColor
                                                        .withOpacity(0.4),
                                                // border: Border.all(
                                                //     width: 2,
                                                //     color: isCompleted
                                                //         ? widget.chapter.colorAsColor
                                                //         : Colors.transparent),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(
                                                        preferences.getBool(
                                                                    "isDarkMode") ==
                                                                true
                                                            ? 0
                                                            : 0.15),
                                                    spreadRadius: 0.01.h,
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 7),
                                                  )
                                                ],
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  setText(
                                                      "Level ${index + 1}",
                                                      FontWeight.w600,
                                                      16.sp,
                                                      isCompleted
                                                          ? fontColor
                                                          : fontColor
                                                              .withOpacity(
                                                                  0.4)),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        mcqLevels[index]
                                                                    .stars >=
                                                                1
                                                            ? Icons.star_rounded
                                                            : Icons
                                                                .star_border_rounded,
                                                        color: isCompleted
                                                            ? widget.chapter
                                                                .colorAsColor
                                                            : widget.chapter
                                                                .colorAsColor
                                                                .withOpacity(
                                                                    0.4),
                                                        size: 8.w,
                                                      ),
                                                      SizedBox(
                                                        width: 3.w,
                                                      ),
                                                      Icon(
                                                          mcqLevels[index]
                                                                      .stars >=
                                                                  2
                                                              ? Icons
                                                                  .star_rounded
                                                              : Icons
                                                                  .star_border_rounded,
                                                          size: 8.w,
                                                          color: isCompleted
                                                              ? widget.chapter
                                                                  .colorAsColor
                                                              : widget.chapter
                                                                  .colorAsColor
                                                                  .withOpacity(
                                                                      0.4)),
                                                      SizedBox(
                                                        width: 3.w,
                                                      ),
                                                      Icon(
                                                          mcqLevels[index]
                                                                      .stars ==
                                                                  3
                                                              ? Icons
                                                                  .star_rounded
                                                              : Icons
                                                                  .star_border_rounded,
                                                          size: 8.w,
                                                          color: isCompleted
                                                              ? widget.chapter
                                                                  .colorAsColor
                                                              : widget.chapter
                                                                  .colorAsColor
                                                                  .withOpacity(
                                                                      0.4)),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        FontAwesomeIcons.coins,
                                                        color: fontColor
                                                            .withOpacity(
                                                                isCompleted
                                                                    ? 0.8
                                                                    : 0.4),
                                                      ),
                                                      SizedBox(
                                                        width: 3.w,
                                                      ),
                                                      setText(
                                                          "30",
                                                          FontWeight.bold,
                                                          14.sp,
                                                          fontColor.withOpacity(
                                                              isCompleted
                                                                  ? 0.8
                                                                  : 0.4))
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            if (!isCompleted)
                                              Icon(
                                                FontAwesomeIcons.lock,
                                                color: fontColor,
                                                size: 9.w,
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ).fadeIn(
                                    begin: 0,
                                    curve: Curves.easeOut,
                                    duration: 500.ms,
                                    delay:
                                        (300 + index < 8 ? index * 100 : 0).ms)
                              ],
                            );
                          },
                        ),
                      )
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
                          color: widget.chapter.colorAsColor),
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
                  Positioned(
                    left: 83.w,
                    top: 3.h,
                    child: Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          // border: Border.all(
                          //     width: 1.5, color: fontColor.withOpacity(0.2))
                          color: widget.chapter.colorAsColor),
                      child: IconButton(
                          style: IconButton.styleFrom(padding: EdgeInsets.zero),
                          onPressed: () {
                            showOptionsModal(context);
                          },
                          icon: Icon(
                            FontAwesomeIcons.gear,
                            size: 5.w,
                            color: Colors.white,
                          )),
                    ),
                  ),
                  Positioned(
                      right: 1.w,
                      bottom: 2.h,
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: _isButtonVisible ? 1.0 : 0.0,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          width: 10.w,
                          height: 10.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isButtonVisible
                                ? widget.chapter.colorAsColor
                                : Colors.transparent,
                          ),
                          child: _isButtonVisible
                              ? IconButton(
                                  style: IconButton.styleFrom(
                                      padding: EdgeInsets.zero),
                                  onPressed: () {
                                    scrollController.animateTo(0,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeOut);
                                  },
                                  icon: Icon(
                                    Icons.arrow_upward_rounded,
                                    size: 5.w,
                                    color: Colors.white,
                                  ),
                                )
                              : SizedBox.shrink(),
                        ),
                      )),
                ],
              ),
            ),
    );
  }

  void showOptionsModal(context) {
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
                      setText("${widget.chapter.name} chapter", FontWeight.w600,
                          18.sp, widget.chapter.colorAsColor),
                      SizedBox(
                        height: 6.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: widget.chapter.colorAsColor),
                            width: 38.w,
                            height: 18.h,
                            child: TextButton(
                              onPressed: () {
                                List<Learnedword> word = [];
                                for (McqLevel level in mcqLevels) {
                                  if (level.isPassed == 1) {
                                    word.add(Learnedword(
                                        id: Uuid().v4(),
                                        word: level.word,
                                        type: "",
                                        description: level.description));
                                  }
                                  word.shuffle();
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (BuildContext context) =>
                                          FlashcardsPage(word: word),
                                    ),
                                  );
                                }
                              },
                              style: buttonStyle(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.clipboard,
                                    color: Colors.white,
                                    size: 9.w,
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  setText("Review chapter", FontWeight.w600,
                                      15.sp, Colors.white, true),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: widget.chapter.colorAsColor),
                            width: 38.w,
                            height: 18.h,
                            child: TextButton(
                              onPressed: () async {
                                updateChapterInDB(Chapter(
                                    id: widget.chapter.id,
                                    name: widget.chapter.name,
                                    description: widget.chapter.description,
                                    levelCount: widget.chapter.levelCount,
                                    pointsCollected:
                                        widget.chapter.pointsCollected,
                                    starsCollected: 0,
                                    levelsPassed: 0,
                                    color: widget.chapter.color));
                                setState(() {
                                  chapters[widget.chapter.id - 1] = Chapter(
                                      id: widget.chapter.id,
                                      name: widget.chapter.name,
                                      description: widget.chapter.description,
                                      levelCount: widget.chapter.levelCount,
                                      pointsCollected:
                                          widget.chapter.pointsCollected,
                                      starsCollected: 0,
                                      levelsPassed: 0,
                                      color: widget.chapter.color);
                                  widget.update(chapters);
                                  for (int i = 0; i < mcqLevels.length; i++) {
                                    if (mcqLevels[i].chapterId ==
                                        widget.chapter.id) {
                                      updateMcqLevelInDB(McqLevel(
                                          id: mcqLevels[i].id,
                                          levelType: mcqLevels[i].levelType,
                                          chapterId: mcqLevels[i].chapterId,
                                          description: mcqLevels[i].description,
                                          arabicDescription:
                                              mcqLevels[i].arabicDescription,
                                          isPassed: 0,
                                          isReset: mcqLevels[i].isPassed == 1
                                              ? 1
                                              : 0,
                                          word: mcqLevels[i].word,
                                          stars: 0,
                                          points: mcqLevels[i].points));
                                    }
                                  }
                                  for (int i = 0; i < mcqLevels.length; i++) {
                                    if (mcqLevels[i].chapterId ==
                                        widget.chapter.id) {
                                      mcqLevels[i] = McqLevel(
                                          id: mcqLevels[i].id,
                                          chapterId: mcqLevels[i].chapterId,
                                          description: mcqLevels[i].description,
                                          arabicDescription:
                                              mcqLevels[i].arabicDescription,
                                          isPassed: 0,
                                          levelType: mcqLevels[i].levelType,
                                          word: mcqLevels[i].word,
                                          isReset: mcqLevels[i].isPassed == 1
                                              ? 1
                                              : 0,
                                          stars: 0,
                                          points: mcqLevels[i].points);
                                    }
                                  }
                                });
                                setState(() {
                                  mcqLevels;
                                  progress;
                                });
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => LevelsMenu(
                                              chapter: widget.chapter,
                                              update: widget.update,
                                            )));
                              },
                              style: buttonStyle(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.clockRotateLeft,
                                    color: Colors.white,
                                    size: 8.w,
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  setText("Reset chapter", FontWeight.w600,
                                      15.sp, Colors.white, true),
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

class DashedLinePainter extends CustomPainter {
  final Color color;

  DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    double dashWidth = 5;
    double dashSpace = 3;
    double startX = 0;

    while (startX < size.height) {
      canvas.drawLine(Offset(size.width / 2, startX),
          Offset(size.width / 2, startX + dashWidth), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
