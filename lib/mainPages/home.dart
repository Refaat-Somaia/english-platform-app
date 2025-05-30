import 'dart:async';
import 'dart:math';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:funlish_app/body.dart';
import 'package:funlish_app/components/avatar.dart';
import 'package:funlish_app/components/modals/giftModal.dart';
import 'package:funlish_app/mainPages/flashCards.dart';
import 'package:funlish_app/mainPages/games/gameIntro.dart';
import 'package:funlish_app/mainPages/menu/account.dart';
import 'package:funlish_app/mainPages/chapters/levelsMenu.dart';
import 'package:funlish_app/mainPages/menu/friendsList.dart';
import 'package:funlish_app/mainPages/menu/leaderboard.dart';
import 'package:funlish_app/mainPages/menu/settings.dart';
import 'package:funlish_app/mainPages/menu/stats.dart';
import 'package:funlish_app/mainPages/menu/shop.dart';
import 'package:funlish_app/model/learnedWord.dart';
import 'package:funlish_app/model/userProgress.dart';
import 'package:funlish_app/utility/databaseHandler.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:funlish_app/utility/noti_service.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../model/Chapter.dart';

class Home extends StatefulWidget {
  final Function update;
  const Home({super.key, required this.update});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  double btnSize = 12.w;
  late Chapter _chapter;
  bool isDrawerOpen = false;
  String userName = "";
  double progress = 0;
  double bgOpacity = 0;
  bool isViewingFlashCard = false;
  String welcomeMsg = '';
  late AnimationController _animationController;
  ScrollController scrollController = ScrollController();
  List<Learnedword> flashCardsWord = [];
  ValueNotifier<int> activeIndex = ValueNotifier<int>(0);
  ValueNotifier<int> activeIndex2 = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    getChapter();
    welcomeMsg = getWelcomeMessage();
    getUserName();
    initSwiperPage();
    initGamesSwiperPages();
    generateGift();
  }

  void getUserName() async {
    setState(() {
      userName = (preferences.getString("userName"))!;
    });
  }

  void generateGift() {
    if (preferences.getBool("isShownGift") == true) return;
    Timer(Duration(milliseconds: 1500), () {
      if (mounted) {
        showGiftModal(context);
      }
    });
  }

  String getWelcomeMessage() {
    List<String> messages = [
      "Let’s make today count. 🚀",
      "Look who’s here! 😏",
      "Another step closer to fluency! 💪",
      "Let’s crush it today. 🔥",
      "It's perfect day to level up! 🎮",
      "Back again! Love the dedication. 💙",
      "Let’s keep that streak going! 🔥",
      "One step closer to mastering English. 🌟"
    ];

    return messages[Random().nextInt(messages.length)];
  }

  void updateChpaters(List<Chapter> newChapters) {
    setState(() {
      chapters = newChapters;
    });
    getChapter();
  }

  void getPrgress() async {
    List<String> words = await getWordsByChapterId(_chapter.id);

    progress = chapters[_chapter.id - 1].levelsPassed / words.length;
    setState(() {
      progress;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }

  void getChapter() async {
    Chapter max = Chapter(
        id: -1,
        name: "name",
        description: "description",
        levelCount: 0,
        pointsCollected: 0,
        starsCollected: 0,
        levelsPassed: 0,
        color: 0);
    for (Chapter c in chapters) {
      if (c.levelsPassed > max.levelsPassed && c.levelsPassed != c.levelCount) {
        max = c;
      }
    }
    if (max.id != -1) {
      setState(() {
        _chapter = max;
      });
    } else {
      _chapter = chapters[0];
    }
    flashCardsWord = await getLearnedWordsFromDB();
    setState(() {});

    getPrgress();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProgress>(context);

    return Scaffold(
      backgroundColor: bodyColor,
      body: SizedBox(
        width: 100.w,
        height: 94.h,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 12.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 6.w,
                      ),

                      // color: fontColor.withOpacity(0.6),
                      // width: 37.w,

                      Animate(
                        child: setText("Hello $userName,", FontWeight.bold,
                            18.5.sp, fontColor, null, null),
                      )
                          .slideY(
                              begin: 0.5,
                              end: 0,
                              curve: Curves.ease,
                              duration: 500.ms)
                          .fadeIn(
                            curve: Curves.ease,
                          ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 6.w,
                      ),
                      Animate(
                        child: setText(welcomeMsg, FontWeight.w500, 13.2.sp,
                            fontColor.withOpacity(0.5)),
                      )
                          .slideY(
                              begin: 0.5,
                              end: 0,
                              curve: Curves.ease,
                              delay: 200.ms,
                              duration: 500.ms)
                          .fadeIn(
                            curve: Curves.ease,
                          ),
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Animate(
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 20.h,
                          child: Swiper(
                            viewportFraction: 0.86,
                            scale: 0.9,
                            itemBuilder: (context, index) {
                              return swiperPages[index];
                            },
                            indicatorLayout: PageIndicatorLayout.COLOR,
                            autoplay: true,
                            autoplayDelay: 5000,
                            itemCount: 2,
                            onIndexChanged: (value) {
                              setState(() {
                                activeIndex.value = value;
                              });
                            },
                          ),
                        ),

                        // .scaleXY(begin: 1.2, end: 1, curve: Curves.ease),
                        SizedBox(
                          height: 1.h,
                        ),
                        Animate(
                          child: ValueListenableBuilder<int>(
                            valueListenable: activeIndex,
                            builder: (context, value, child) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  swiperPages.length,
                                  (index) => Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 1.w),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeOut,
                                      width: 1.5.w,
                                      height: 1.5.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: value == index
                                            ? fontColor.withOpacity(0.7)
                                            : fontColor.withOpacity(0.2),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ).fadeIn(
                            curve: Curves.ease,
                            duration: 400.ms,
                            delay: 400.ms),
                        // .scaleXY(begin: 1.2, end: 1, curve: Curves.ease),
                        SizedBox(
                          height: 2.5.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Container(
                            width: 90.w,
                            height: 20.h,
                            decoration: BoxDecoration(
                                color: primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(18)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 60.w,
                                  height: 16.h,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      setText("Flash cards 🎯", FontWeight.w600,
                                          16.sp, fontColor),
                                      // SizedBox(
                                      //   height: 1.h,
                                      // ),
                                      setText(
                                          "Review what you have learned so far!",
                                          FontWeight.w600,
                                          14.sp,
                                          fontColor.withOpacity(0.7)),
                                      SizedBox(height: 1.h),
                                      Container(
                                        width: 30.w,
                                        height: 5.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            color: primaryBlue),
                                        child: TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (context) =>
                                                        FlashcardsPage(
                                                          word: flashCardsWord,
                                                        )),
                                              );
                                            },
                                            child: setText(
                                                "Start",
                                                FontWeight.w600,
                                                14.sp,
                                                Colors.white)),
                                      )
                                    ],
                                  ),
                                ),
                                Image.asset(
                                  'assets/images/task.png',
                                  width: 20.w,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // .scaleXY(begin: 1.2, end: 1, curve: Curves.ease),
                        SizedBox(
                          height: 3.h,
                        ),
                        SizedBox(
                          width: 90.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  width: 56.w,
                                  height: 30.h,
                                  padding: EdgeInsets.symmetric(vertical: 2.h),
                                  decoration: BoxDecoration(
                                      color: _chapter.colorAsColor
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(18)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularPercentIndicator(
                                        radius: 12.w,
                                        animation: true,
                                        curve: Curves.easeOut,
                                        backgroundColor:
                                            fontColor.withOpacity(0.2),
                                        progressColor: _chapter.colorAsColor,
                                        percent: progress,
                                        center: Image.asset(
                                          'assets/images/chapters/${_chapter.name.toLowerCase()}/${_chapter.name.toLowerCase()}1.png',
                                          width: 15.w,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      SizedBox(
                                        width: 50.w,
                                        height: 7.h,
                                        child: _chapter.levelsPassed > 0
                                            ? setText(
                                                "You're ${(progress * 100).ceil()}% through the ${_chapter.name} chapter! Keep it up!",
                                                FontWeight.w600,
                                                13.sp,
                                                fontColor.withOpacity(0.8),
                                                true)
                                            : setText(
                                                "Begin the ${_chapter.name} chapter now! 🚀",
                                                FontWeight.w600,
                                                13.sp,
                                                fontColor.withOpacity(0.8),
                                                true),
                                      ),
                                      SizedBox(
                                        height: 0.5.h,
                                      ),
                                      Container(
                                        width: 30.w,
                                        height: 5.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            color: _chapter.colorAsColor),
                                        child: TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        LevelsMenu(
                                                      chapter: _chapter,
                                                      update: updateChpaters,
                                                    ),
                                                  ));
                                            },
                                            child: setText(
                                                _chapter.levelsPassed > 0
                                                    ? "Continue"
                                                    : "Begin",
                                                FontWeight.w600,
                                                14.sp,
                                                Colors.white)),
                                      )
                                    ],
                                  )),
                              Column(
                                children: [
                                  Container(
                                    width: 30.w,
                                    height: 14.h,
                                    decoration: BoxDecoration(
                                        color: primaryPurple.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(18)),
                                    child: TextButton(
                                      style: buttonStyle(18),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        Account()));
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircularPercentIndicator(
                                              radius: 9.w,
                                              backgroundColor:
                                                  fontColor.withOpacity(0.2),
                                              progressColor: primaryPurple,
                                              percent: user.xp /
                                                  user.xpForNextLevel(),
                                              center: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  setText(
                                                      user.level.toString(),
                                                      FontWeight.bold,
                                                      18.sp,
                                                      fontColor),
                                                  setText(
                                                      "Level",
                                                      FontWeight.w600,
                                                      12.sp,
                                                      fontColor
                                                          .withOpacity(0.6))
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Container(
                                    width: 30.w,
                                    height: 14.h,
                                    decoration: BoxDecoration(
                                        color: primaryPurple.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(18)),
                                    child: TextButton(
                                      style: buttonStyle(18),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        Account()));
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                FontAwesomeIcons.coins,
                                                color: primaryPurple,
                                              ),
                                              setText(
                                                  "${user.points}",
                                                  FontWeight.w600,
                                                  16.sp,
                                                  fontColor.withOpacity(1)),
                                              setText(
                                                  "Points",
                                                  FontWeight.w600,
                                                  12.sp,
                                                  fontColor.withOpacity(0.6)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),

                        // .scaleXY(begin: 1.2, end: 1, curve: Curves.ease),
                        SizedBox(
                          height: 3.h,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 20.h,
                          child: Swiper(
                            viewportFraction: 0.86,
                            scale: 0.9,
                            itemBuilder: (context, index) {
                              return gamesSwiperPages[index];
                            },
                            indicatorLayout: PageIndicatorLayout.COLOR,
                            autoplay: true,
                            autoplayDelay: 5000,
                            itemCount: gamesSwiperPages.length,
                            onIndexChanged: (value) {
                              setState(() {
                                activeIndex2.value = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        ValueListenableBuilder<int>(
                          valueListenable: activeIndex2,
                          builder: (context, value, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                gamesSwiperPages.length,
                                (index) => Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 1.w),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                    width: 1.5.w,
                                    height: 1.5.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: value == index
                                          ? fontColor.withOpacity(0.7)
                                          : fontColor.withOpacity(0.2),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: 2.5.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Container(
                            width: 90.w,
                            height: 20.h,
                            decoration: BoxDecoration(
                                color: primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(18)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 60.w,
                                  height: 16.h,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      setText("Leaderboard 🌟", FontWeight.w600,
                                          16.sp, fontColor),
                                      // SizedBox(
                                      //   height: 1.h,
                                      // ),
                                      setText(
                                          "View your rank among top learners",
                                          FontWeight.w600,
                                          14.sp,
                                          fontColor.withOpacity(0.7)),
                                      SizedBox(height: 1.h),
                                      Container(
                                        width: 30.w,
                                        height: 5.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            color: primaryBlue),
                                        child: TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (context) =>
                                                        Leaderboard()),
                                              );
                                            },
                                            child: setText(
                                                "View",
                                                FontWeight.w600,
                                                14.sp,
                                                Colors.white)),
                                      )
                                    ],
                                  ),
                                ),
                                Image.asset(
                                  'assets/images/leaderboard.png',
                                  width: 20.w,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                      ],
                    ),
                  )
                      .slideY(
                          begin: 0.1,
                          end: 0,
                          curve: Curves.ease,
                          delay: 300.ms,
                          duration: 700.ms)
                      .fadeIn()
                ],
              ),
            ),
            TopBar(),
            Animate(
              child: Positioned(
                  right: 0,
                  top: 0,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Image.asset(
                      "assets/images/circle-top.png",
                      height: 8.h,
                    ),
                  )),
            )
                .slideY(
                    begin: -0.3,
                    end: 0,
                    curve: Curves.ease,
                    delay: 200.ms,
                    duration: 600.ms)
                .fadeIn(
                  curve: Curves.ease,
                ),
            if (isDrawerOpen)
              GestureDetector(
                onTap: () {
                  _animationController.reverse();
                  setState(() {
                    bgOpacity = 0;
                  });
                  Timer(Duration(milliseconds: 300), () {
                    setState(() {
                      isDrawerOpen = false;
                    });
                  });
                },
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: bgOpacity,
                  child: Container(
                    width: 100.w,
                    height: 100.h,
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
              ),
            if (isDrawerOpen)
              Animate(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: 65.w,
                  height: 100.h,
                  color: bodyColor,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4.h),
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Avatar(
                                  characterIndex: user.characterIndex,
                                  hatIndex: user.hatIndex,
                                  width: 20.w),
                              SizedBox(
                                height: 1.h,
                              ),
                              setText(
                                  userName, FontWeight.w600, 16.sp, fontColor),
                              setText("Level: ${user.level}", FontWeight.w600,
                                  13.sp, fontColor.withOpacity(0.5)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Center(
                          child: Container(
                            width: 55.w,
                            height: 1,
                            decoration: BoxDecoration(
                                color: fontColor.withOpacity(0.1)),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        NavButton("Review", FontAwesomeIcons.clipboardList,
                            primaryPurple, () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (BuildContext context) => Stats(),
                            ),
                          );
                        }),
                        NavButton("Leaderboard", Icons.leaderboard_rounded,
                            primaryPurple, () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (BuildContext context) => Leaderboard(),
                            ),
                          );
                        }),
                        NavButton("Chatbot", FontAwesomeIcons.robot,
                            primaryPurple, () {}),
                        NavButton(
                            "Store", FontAwesomeIcons.store, primaryPurple, () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (BuildContext context) => Shop(),
                            ),
                          );
                        }),
                        NavButton("Friends list", FontAwesomeIcons.users,
                            primaryPurple, () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (BuildContext context) => Friendslist(),
                            ),
                          );
                        }),
                        NavButton(
                            "My account", FontAwesomeIcons.user, primaryPurple,
                            () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (BuildContext context) => Account(),
                            ),
                          );
                        }),
                        NavButton(
                            "Settings", FontAwesomeIcons.gear, primaryPurple,
                            () async {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  Settings(update: () {
                                initSwiperPage();
                                initGamesSwiperPages();
                                widget.update();
                              }),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              )
                  .animate(controller: _animationController, autoPlay: false)
                  .slideX(
                      begin: -1.5,
                      end: 0,
                      curve: Curves.easeOut,
                      duration: 300.ms)
          ],
        ),
      ),
    );
  }

  Widget TopBar() {
    return Positioned(
      child: Container(
        color: bodyColor,
        height: 10.h,
        width: 100.w,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 92.w,
              child: Animate(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: btnSize,
                          height: btnSize,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: primaryPurple.withOpacity(0.1),
                            // border: Border.all(
                            //     width: 1.5,
                            //     color: primaryPurple.withOpacity(0.2))
                          ),
                          child: TextButton(
                            onPressed: () {
                              _animationController.forward();
                              setState(() {
                                isDrawerOpen = true;
                              });
                              Timer(Duration(milliseconds: 100), () {
                                setState(() {
                                  bgOpacity = 1;
                                });
                              });
                            },
                            style: buttonStyle(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/menu.png',
                                  width: 8.w,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 3.w,
                        ),
                        Container(
                          width: btnSize,
                          height: btnSize,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: primaryPurple.withOpacity(0.1),
                            // border: Border.all(
                            //     width: 1.5,
                            //     color: primaryPurple.withOpacity(0.2))
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/notification.png',
                                width: 8.w,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
                  .slideY(
                      begin: -0.3,
                      end: 0,
                      curve: Curves.ease,
                      delay: 200.ms,
                      duration: 600.ms)
                  .fadeIn(
                    curve: Curves.ease,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget NavButton(
      String text, IconData icon, Color color, void Function() func) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h, left: 1.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
      width: 60.w,
      child: IconButton(
        onPressed: func,
        icon: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 3.w,
            ),
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(
                icon,
                color: color,
              ),
            ),
            SizedBox(
              width: 3.w,
            ),
            SizedBox(
                width: 28.w,
                child: setText(text, FontWeight.w600, 14.sp, fontColor))
          ],
        ),
      ),
    );
  }

  List<Widget> swiperPages = [];

  List<Widget> gamesSwiperPages = [];

  initGamesSwiperPages() {
    gamesSwiperPages = [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: Container(
          width: 90.w,
          height: 20.h,
          decoration: BoxDecoration(
              color: primaryPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 0.w),
              SizedBox(
                width: 55.w,
                height: 16.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    setText(
                        "Play Bomb Relay", FontWeight.w600, 16.sp, fontColor),
                    // SizedBox(
                    //   height: 1.h,
                    // ),
                    setText("Solve grammar questions to defuse bombs!",
                        FontWeight.w600, 14.sp, fontColor.withOpacity(0.7)),
                    SizedBox(height: 1.h),
                    Container(
                      width: 30.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: primaryPurple),
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (BuildContext context) =>
                                        Gameintro(
                                          gameName: "Bomb Relay",
                                          color:
                                              Color.fromARGB(255, 235, 140, 50),
                                          text:
                                              "A grammar bomb is passed between players ⏳. A sentence with a missing word is given. The player must fill in the blank correctly before time runs out! If they fail or take too long, they lose the game. Last player standing wins!",
                                          path: "assets/animations/bomb.json",
                                        )));
                          },
                          child: setText(
                              "Play", FontWeight.w600, 14.sp, Colors.white)),
                    )
                  ],
                ),
              ),
              Lottie.asset('assets/animations/bomb.json',
                  animate: false, width: 20.w)
            ],
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: Container(
          width: 90.w,
          height: 20.h,
          decoration: BoxDecoration(
              color: primaryPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 0.w),
              SizedBox(
                width: 55.w,
                height: 16.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: setText("Play Word Puzzle", FontWeight.w600, 16.sp,
                          fontColor),
                    ),
                    // SizedBox(
                    //   height: 1.h,
                    // ),
                    setText("Solve words from shuffled letters!",
                        FontWeight.w600, 14.sp, fontColor.withOpacity(0.7)),
                    SizedBox(height: 1.h),
                    Container(
                      width: 30.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: primaryPurple),
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (BuildContext context) =>
                                        Gameintro(
                                          gameName: "Word Puzzle",
                                          color: const Color.fromARGB(
                                              255, 90, 63, 151),
                                          text:
                                              "Each player is given scattered letters on the screen. They must rearrange them to form a word. The fastest player to solve 4 words wins!",
                                          path: "assets/animations/puzzle.json",
                                        )));
                          },
                          child: setText(
                              "Play", FontWeight.w600, 14.sp, Colors.white)),
                    )
                  ],
                ),
              ),
              Lottie.asset('assets/animations/puzzle.json',
                  animate: false, width: 20.w)
            ],
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: Container(
          width: 90.w,
          height: 20.h,
          decoration: BoxDecoration(
              color: primaryPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 0.w),
              SizedBox(
                width: 55.w,
                height: 16.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: setText("Play Castle Escape", FontWeight.w600,
                          16.sp, fontColor),
                    ),
                    // SizedBox(
                    //   height: 1.h,
                    // ),
                    setText("Solve questions to escape the castle first!",
                        FontWeight.w600, 14.sp, fontColor.withOpacity(0.7)),
                    SizedBox(height: 1.h),
                    Container(
                      width: 30.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: primaryPurple),
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (BuildContext context) =>
                                        Gameintro(
                                          gameName: "Castle Escape",
                                          color: const Color.fromARGB(
                                              255, 48, 79, 139),
                                          text:
                                              "Each player is trapped in a virtual castle 🏰. To escape, they must solve grammar puzzles, fix incorrect sentences, or choose the right words.",
                                          path: "assets/animations/castle.json",
                                        )));
                          },
                          child: setText(
                              "Play", FontWeight.w600, 14.sp, Colors.white)),
                    )
                  ],
                ),
              ),
              Lottie.asset('assets/animations/castle.json',
                  animate: false, width: 20.w)
            ],
          ),
        ),
      )
    ];
    setState(() {});
  }

  initSwiperPage() {
    swiperPages = [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: Container(
          width: 90.w,
          height: 20.h,
          decoration: BoxDecoration(
              color: primaryPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 0.w),
              SizedBox(
                width: 55.w,
                height: 16.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    setText("Thread of the week", FontWeight.w600, 16.sp,
                        fontColor),
                    // SizedBox(
                    //   height: 1.h,
                    // ),
                    setText("What do you think about global warming 🤔",
                        FontWeight.w600, 14.sp, fontColor.withOpacity(0.7)),
                    SizedBox(height: 1.h),
                    Container(
                      width: 30.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: primaryPurple),
                      child: TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => Body(
                                        pageIndex: 3,
                                      )),
                              (route) => false,
                            );
                          },
                          child: setText(
                              "Join", FontWeight.w600, 14.sp, Colors.white)),
                    )
                  ],
                ),
              ),
              Image.asset(
                'assets/images/chat.png',
                width: 20.w,
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: Container(
          width: 90.w,
          height: 20.h,
          decoration: BoxDecoration(
              color: primaryPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 0.w),
              SizedBox(
                width: 55.w,
                height: 16.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: setText("Follow us on Instagram", FontWeight.w600,
                          16.sp, fontColor),
                    ),
                    // SizedBox(
                    //   height: 1.h,
                    // ),
                    setText("We post Daily English content!", FontWeight.w600,
                        14.sp, fontColor.withOpacity(0.7)),
                    SizedBox(height: 1.h),
                    Container(
                      width: 30.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: primaryPurple),
                      child: TextButton(
                          onPressed: () {},
                          child: setText(
                              "Follow", FontWeight.w600, 14.sp, Colors.white)),
                    )
                  ],
                ),
              ),
              Image.asset(
                'assets/images/instagram.png',
                width: 20.w,
              ),
            ],
          ),
        ),
      )
    ];
    setState(() {});
  }
}
