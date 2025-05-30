import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:funlish_app/components/appButton.dart';
import 'package:funlish_app/components/avatar.dart';
import 'package:funlish_app/components/chart.dart';
import 'package:funlish_app/mainPages/menu/account_info.dart';
import 'package:funlish_app/utility/appTimer.dart';
import 'package:funlish_app/model/userProgress.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  List<String> charctersPaths = [
    'assets/images/shop/characters/penguin-purple.png',
    'assets/images/shop/characters/penguin-pink.png',
    'assets/images/shop/characters/penguin-green.png',
    'assets/images/shop/characters/penguin-blue.png',
    'assets/images/shop/characters/penguin-yellow.png',
    'assets/images/shop/characters/penguin-grey.png',
    'assets/images/shop/characters/penguin-red.png',
    'assets/images/shop/characters/penguin-black.png',
    'assets/images/shop/characters/wolf-blue.png',
    'assets/images/shop/characters/wolf-orange.png',
    'assets/images/shop/characters/wolf-pink.png',
    'assets/images/shop/characters/rabit-grey.png',
    'assets/images/shop/characters/rabit-pink.png',
    'assets/images/shop/characters/hamter-purple.png',
    'assets/images/shop/characters/hamter-blue.png',
    'assets/images/shop/characters/hamter-yellow.png',
    'assets/images/shop/characters/hamter-red.png',
    'assets/images/shop/characters/hamter-green.png',
    'assets/images/shop/characters/hamter-pink.png',
  ];
  List<String> hatsPaths = [
    'assets/images/shop/hats/none.png',
    'assets/images/shop/hats/winter-1.png',
    'assets/images/shop/hats/hat-1.png',
    'assets/images/shop/hats/hat-2.png',
    'assets/images/shop/hats/hat-3.png',
    'assets/images/shop/hats/hat-6.png',
    'assets/images/shop/hats/hat-7.png',
    'assets/images/shop/hats/hat-8.png',
    'assets/images/shop/hats/hat-4.png',
    'assets/images/shop/hats/hat-5.png',
  ];

  List<int> sortedCharacters = [];
  List<int> sortedHats = [];
  SessionTracker sessionTracker = SessionTracker();
  Map<String, int> appTimes = {};

  void sortLists() async {
    List<Map<String, dynamic>> sessions = [];

    final user = Provider.of<UserProgress>(context, listen: false);
    // user.addXP(10000);
    // Sort characters - owned first
    sortedCharacters = [];
    List<int> ownedCharacters =
        user.charactersList.map((e) => int.parse(e)).toList();
    List<int> unownedCharacters =
        List.generate(charctersPaths.length, (index) => index)
            .where((i) => !ownedCharacters.contains(i))
            .toList();

    sortedCharacters.addAll(ownedCharacters);
    sortedCharacters.addAll(unownedCharacters);

    // Sort hats - owned first
    sortedHats = [];
    List<int> ownedHats = user.hatsList.map((e) => int.parse(e)).toList();
    List<int> unownedHats = List.generate(hatsPaths.length, (index) => index)
        .where((i) => !ownedHats.contains(i))
        .toList();

    sortedHats.addAll(ownedHats);
    sortedHats.addAll(unownedHats);

    setState(() {});
    sessions = await sessionTracker.loadSessionLogs();
    // print(DateTime.parse(sessions[0].keys.elementAt(0)));
    // DateTime dateTime = DateTime.parse(sessions[0]['timestamp']);
    for (var s in sessions) {
      appTimes[_getWeekdayName(s['timestamp'].weekday)] =
          int.parse(s['duration'].toString());
    }
    setState(() {});
    print(appTimes);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProgress>(context, listen: false);
    if (sortedCharacters.isEmpty || sortedHats.isEmpty) {
      sortLists();
    }

    return Scaffold(
        backgroundColor: bodyColor,
        body: Animate(
          child: SizedBox(
              width: 100.w,
              height: 100.h,
              child: Stack(alignment: Alignment.center, children: [
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
                Column(children: [
                  SizedBox(
                    height: 4.5.h,
                  ),
                  setText("My account", FontWeight.w600, 17.sp, fontColor),
                  SizedBox(
                    height: 4.h,
                  ),
                  SizedBox(
                    height: 86.h,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Avatar(
                          //     characterIndex: user.characterIndex,
                          //     hatIndex: user.hatIndex,
                          //     width: 14.h),
                          // SizedBox(
                          //   height: 1.h,
                          // ),

                          SizedBox(
                            height: 4.h,
                          ),
                          // setText("My character", FontWeight.w600, 15.sp, fontColor),

                          Container(
                            width: 92.w,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: primaryPurple.withOpacity(0.1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: SizedBox(
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      spacing: 0.5.h,
                                      children: [
                                        Row(
                                          spacing: 2.w,
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.award,
                                              color: fontColor,
                                              size: 5.5.w,
                                            ),
                                            setText(
                                              "level: ${user.level}",
                                              FontWeight.w600,
                                              15.sp,
                                              fontColor,
                                            ),
                                          ],
                                        ),
                                        // setText(
                                        //   "User level",
                                        //   FontWeight.w500,
                                        //   15.sp,
                                        //   fontColor,
                                        // ),
                                        Row(
                                          spacing: 2.w,
                                          children: [
                                            // Icon(
                                            //   FontAwesomeIcons.coins,
                                            //   size: 4.w,
                                            //   color: fontColor.withOpacity(0.6),
                                            // ),
                                            setText(
                                              "Current XP: ${user.xp}",
                                              FontWeight.w500,
                                              13.sp,
                                              fontColor.withOpacity(0.6),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 2.h),
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularPercentIndicator(
                                      radius: 12.w,
                                      backgroundColor: fontColor.withOpacity(
                                        0.2,
                                      ),
                                      animation: true,
                                      curve: Curves.ease,
                                      animationDuration: 800,
                                      progressColor: primaryPurple,
                                      percent: user.xp / user.xpForNextLevel(),
                                      center: setText(
                                        "${(user.xp / user.xpForNextLevel() * 100).toStringAsFixed(0)}%",
                                        FontWeight.w600,
                                        14.sp,
                                        fontColor,
                                        true,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          Container(
                            width: 92.w,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: primaryPurple.withOpacity(0.1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: SizedBox(
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      spacing: 0.5.h,
                                      children: [
                                        Row(
                                          spacing: 3.w,
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.chartPie,
                                              color: fontColor,
                                              size: 5.5.w,
                                            ),
                                            FittedBox(
                                              child: SizedBox(
                                                width: 45.w,
                                                child: setText(
                                                  "Chapters completed: 0",
                                                  FontWeight.w600,
                                                  15.sp,
                                                  fontColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // setText(
                                        //   "User level",
                                        //   FontWeight.w500,
                                        //   15.sp,
                                        //   fontColor,
                                        // ),
                                        Row(
                                          spacing: 2.w,
                                          children: [
                                            // Icon(
                                            //   FontAwesomeIcons.coins,
                                            //   size: 4.w,
                                            //   color: fontColor.withOpacity(0.6),
                                            // ),
                                            setText(
                                              "out of: ${chapters.length}",
                                              FontWeight.w500,
                                              13.sp,
                                              fontColor.withOpacity(0.6),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 2.h),
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularPercentIndicator(
                                      radius: 12.w,
                                      backgroundColor: fontColor.withOpacity(
                                        0.2,
                                      ),
                                      animation: true,
                                      curve: Curves.ease,
                                      animationDuration: 800,
                                      progressColor: primaryPurple,
                                      percent: 0,
                                      center: setText(
                                        "0%",
                                        FontWeight.w600,
                                        14.sp,
                                        fontColor,
                                        true,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Container(
                            width: 92.w,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: primaryPurple.withOpacity(0.1),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 80.w,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          setText(
                                              "Current week's app time",
                                              FontWeight.w600,
                                              15.5.sp,
                                              fontColor),
                                          setText(
                                              "measured in minutes",
                                              FontWeight.w600,
                                              13.sp,
                                              fontColor.withOpacity(0.6)),
                                          setText(
                                              "(Updates when the app is closed)",
                                              FontWeight.w600,
                                              13.sp,
                                              fontColor.withOpacity(0.6)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 3.h),
                                Chart(
                                    values: appTimes,
                                    amountMax: 10,
                                    height: 25.h),
                              ],
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            // color: primaryBlue,
                            width: 92.w,
                            height: 14.h,
                            child: Stack(
                              children: [
                                setText("My characters", FontWeight.w600,
                                    15.5.sp, fontColor),
                                Swiper(
                                    itemCount: user.charactersList.length,
                                    viewportFraction: 0.3,
                                    loop: false,
                                    scale: 0.1,
                                    itemBuilder: (context, index) {
                                      return AnimatedContainer(
                                        duration: Duration(milliseconds: 200),
                                        // width: 50.w,
                                        // height: 7.h,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: user.characterIndex ==
                                                      sortedCharacters[index]
                                                  ? primaryPurple
                                                  : primaryPurple.withOpacity(
                                                      0), // You can change the color
                                              width:
                                                  3, // You can change the width
                                            ),
                                          ),
                                        ),

                                        child: GestureDetector(
                                          onTap: () {
                                            user.characterIndex =
                                                sortedCharacters[index];
                                            setState(() {});
                                          },
                                          child: Avatar(
                                              characterIndex:
                                                  sortedCharacters[index],
                                              hatIndex: 0,
                                              width: 14.h),
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          ),
                          SizedBox(height: 4.h),

                          Container(
                            // color: fontColor.withOpacity(0.1),
                            width: 92.w,
                            height: 14.h,
                            child: Stack(
                              children: [
                                setText("My hats", FontWeight.w600, 15.5.sp,
                                    fontColor),
                                Swiper(
                                    itemCount: user.hatsList.length,
                                    viewportFraction: 0.3,
                                    loop: false,
                                    scale: 0.1,
                                    itemBuilder: (context, index) {
                                      return AnimatedContainer(
                                        duration: Duration(milliseconds: 200),
                                        // width: 50.w,
                                        // height: 7.h,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: user.hatIndex ==
                                                      sortedHats[index]
                                                  ? primaryPurple
                                                  : primaryPurple.withOpacity(
                                                      0), // You can change the color
                                              width:
                                                  3, // You can change the width
                                            ),
                                          ),
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            user.hatIndex = sortedHats[index];
                                            setState(() {});
                                          },
                                          child: Avatar(
                                              characterIndex:
                                                  user.characterIndex,
                                              hatIndex: sortedHats[index],
                                              width: 14.h),
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          ),
                          SizedBox(height: 4.h),
                          AppButton(
                            function: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => AccountInfo()));
                            },
                            height: 7.h,
                            width: 90.w,
                            color: primaryPurple,
                            text: "Personal details",
                            icon: FontAwesomeIcons.user,
                          ),
                          SizedBox(height: 2.5.h),
                        ],
                      ),
                    ),
                  ),
                ])
              ])),
        ).fadeIn(
          duration: 400.ms,
        ));
  }
}

String _getWeekdayName(int weekdayNumber) {
  const weekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  return weekdays[
      weekdayNumber - 1]; // because DateTime.weekday starts from 1 (Monday)
}
