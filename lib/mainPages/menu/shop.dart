import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:funlish_app/model/powerUp.dart';
import 'package:funlish_app/model/userProgress.dart';
import 'package:funlish_app/utility/databaseHandler.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> with SingleTickerProviderStateMixin {
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
  late AnimationController animationController;
  List<PowerUp> powerUps = [];
  void getPowerUps() async {
    powerUps = await getPowerUpsFromDB();
    setState(() {});
    Timer(Duration(milliseconds: 1000), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getPowerUps();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  List<int> sortedCharacters = [];
  List<int> sortedHats = [];

  void sortLists() {
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
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProgress>(context);
    if (sortedCharacters.isEmpty || sortedHats.isEmpty) {
      sortLists();
    }

    return Scaffold(
        backgroundColor: bodyColor,
        body: SizedBox(
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
              Positioned(
                right: 2.w,
                top: 3.5.h,
                child: Container(
                  width: 25.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: primaryPurple),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.coins,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      setText(user.points.toString(), FontWeight.w600, 15.sp,
                          const Color.fromARGB(255, 255, 255, 255))
                    ],
                  ),
                ),
              ),
              Column(children: [
                SizedBox(height: 4.5.h),
                setText("Store", FontWeight.w600, 17.sp, fontColor),
                SizedBox(height: 3.h),
                isLoading
                    ? Animate(
                        child: SizedBox(
                          height: 88.h,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LoadingAnimationWidget.fallingDot(
                                  color: primaryPurple, size: 18.w),
                              SizedBox(height: 1.h),
                              setText("Loading items...", FontWeight.w600,
                                  16.sp, fontColor),
                            ],
                          ),
                        ),
                      ).fadeIn(duration: 400.ms, delay: 200.ms)
                    : Animate(
                        child: SizedBox(
                          height: 88.h,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: 2.h),
                                SizedBox(
                                  width: 100.w,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(width: 5.w),
                                          setText("Power ups", FontWeight.w600,
                                              16.sp, fontColor),
                                        ],
                                      ),
                                      SizedBox(height: 1.h),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            SizedBox(width: 5.w),
                                            for (int i = 0;
                                                i < powerUps.length;
                                                i++)
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 2.h),
                                                width: 42.w,
                                                height: 24.h,
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: const Color
                                                              .fromARGB(255,
                                                              243, 243, 243)
                                                          .withOpacity(
                                                              preferences.getBool(
                                                                          "isDarkMode") ==
                                                                      true
                                                                  ? 0
                                                                  : 0.2),
                                                      spreadRadius: 0.01.h,
                                                      blurRadius: 8,
                                                      offset:
                                                          const Offset(0, 7),
                                                    )
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: preferences.getBool(
                                                              "isDarkMode") ==
                                                          true
                                                      ? Color.fromARGB(
                                                          255, 53, 39, 87)
                                                      : Colors.white,
                                                ),
                                                child: TextButton(
                                                  style: buttonStyle(12),
                                                  onPressed: () {
                                                    showPowerUpDetails(
                                                        powerUps[i], user);
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image.asset(
                                                        powerUps[i].iconPath,
                                                        width: 20.w,
                                                      ),
                                                      SizedBox(height: 1.h),
                                                      setText(
                                                          powerUps[i].name,
                                                          FontWeight.w600,
                                                          14.sp,
                                                          fontColor),
                                                      SizedBox(height: 2.h),
                                                      setText(
                                                          "You have: ${powerUps[i].count}",
                                                          FontWeight.w600,
                                                          14.sp,
                                                          fontColor.withOpacity(
                                                              0.5)),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            FontAwesomeIcons
                                                                .coins,
                                                            color: fontColor
                                                                .withOpacity(
                                                                    0.7),
                                                            size: 5.w,
                                                          ),
                                                          SizedBox(width: 2.w),
                                                          setText(
                                                              "${powerUps[i].price} points",
                                                              FontWeight.w600,
                                                              13.sp,
                                                              fontColor
                                                                  .withOpacity(
                                                                      0.7))
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                SizedBox(
                                  width: 100.w,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(width: 5.w),
                                          setText("Characters", FontWeight.w600,
                                              16.sp, fontColor),
                                        ],
                                      ),
                                      SizedBox(height: 1.h),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            SizedBox(width: 5.w),
                                            for (int i = 0;
                                                i < sortedCharacters.length;
                                                i++)
                                              AnimatedContainer(
                                                duration:
                                                    Duration(milliseconds: 300),
                                                margin:
                                                    EdgeInsets.only(right: 2.h),
                                                width: 40.w,
                                                height: 20.h,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: user.characterIndex ==
                                                              sortedCharacters[
                                                                  i]
                                                          ? primaryPurple
                                                              .withOpacity(0.8)
                                                          : Colors.transparent,
                                                      width: 3),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: const Color
                                                              .fromARGB(255,
                                                              243, 243, 243)
                                                          .withOpacity(
                                                              preferences.getBool(
                                                                          "isDarkMode") ==
                                                                      true
                                                                  ? 0
                                                                  : 0.2),
                                                      spreadRadius: 0.01.h,
                                                      blurRadius: 8,
                                                      offset:
                                                          const Offset(0, 7),
                                                    )
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: preferences.getBool(
                                                              "isDarkMode") ==
                                                          true
                                                      ? Color.fromARGB(
                                                          255, 53, 39, 87)
                                                      : Colors.white,
                                                ),
                                                child: TextButton(
                                                  style: OutlinedButton.styleFrom(
                                                      padding: EdgeInsets.zero,
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)))),
                                                  onPressed: () {
                                                    if (user.charactersList
                                                        .contains(
                                                            sortedCharacters[i]
                                                                .toString())) {
                                                      // Already owned - just equip
                                                      user.changeAvatar(
                                                          sortedCharacters[i],
                                                          user.hatIndex);
                                                    } else {
                                                      // Not owned - show purchase dialog
                                                      showItemDetails(
                                                          charctersPaths[
                                                              sortedCharacters[
                                                                  i]],
                                                          user,
                                                          sortedCharacters[i],
                                                          'character',
                                                          500);
                                                    }
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image.asset(
                                                        charctersPaths[
                                                            sortedCharacters[
                                                                i]],
                                                        width: 22.w,
                                                      ),
                                                      SizedBox(height: 2.h),
                                                      user.charactersList.contains(
                                                              sortedCharacters[
                                                                      i]
                                                                  .toString())
                                                          ? Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                  setText(
                                                                      user.characterIndex ==
                                                                              sortedCharacters[
                                                                                  i]
                                                                          ? "Equipped"
                                                                          : "Unlocked",
                                                                      FontWeight
                                                                          .w600,
                                                                      14.sp,
                                                                      user.characterIndex ==
                                                                              sortedCharacters[i]
                                                                          ? primaryPurple
                                                                          : fontColor.withOpacity(0.7))
                                                                ])
                                                          : Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  FontAwesomeIcons
                                                                      .coins,
                                                                  color: fontColor
                                                                      .withOpacity(
                                                                          0.7),
                                                                  size: 5.w,
                                                                ),
                                                                SizedBox(
                                                                    width: 2.w),
                                                                setText(
                                                                    "500 points",
                                                                    FontWeight
                                                                        .w600,
                                                                    13.sp,
                                                                    fontColor
                                                                        .withOpacity(
                                                                            0.7))
                                                              ],
                                                            )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                SizedBox(
                                  width: 100.w,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(width: 5.w),
                                          setText("Hats", FontWeight.w600,
                                              16.sp, fontColor),
                                        ],
                                      ),
                                      SizedBox(height: 1.h),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            SizedBox(width: 5.w),
                                            for (int i = 0;
                                                i < sortedHats.length;
                                                i++)
                                              AnimatedContainer(
                                                duration:
                                                    Duration(milliseconds: 300),
                                                margin:
                                                    EdgeInsets.only(right: 2.h),
                                                width: 40.w,
                                                height: 20.h,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: user.hatIndex ==
                                                              sortedHats[i]
                                                          ? primaryPurple
                                                              .withOpacity(0.8)
                                                          : Colors.transparent,
                                                      width: 3),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: const Color
                                                              .fromARGB(255,
                                                              243, 243, 243)
                                                          .withOpacity(
                                                              preferences.getBool(
                                                                          "isDarkMode") ==
                                                                      true
                                                                  ? 0
                                                                  : 0.2),
                                                      spreadRadius: 0.01.h,
                                                      blurRadius: 8,
                                                      offset:
                                                          const Offset(0, 7),
                                                    )
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: preferences.getBool(
                                                              "isDarkMode") ==
                                                          true
                                                      ? Color.fromARGB(
                                                          255, 53, 39, 87)
                                                      : Colors.white,
                                                ),
                                                child: TextButton(
                                                  style: OutlinedButton.styleFrom(
                                                      padding: EdgeInsets.zero,
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)))),
                                                  onPressed: () {
                                                    if (user.hatsList.contains(
                                                        sortedHats[i]
                                                            .toString())) {
                                                      // Already owned - just equip
                                                      user.changeAvatar(
                                                          user.characterIndex,
                                                          sortedHats[i]);
                                                    } else {
                                                      // Not owned - show purchase dialog
                                                      showItemDetails(
                                                          hatsPaths[
                                                              sortedHats[i]],
                                                          user,
                                                          sortedHats[i],
                                                          'hat',
                                                          250);
                                                    }
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image.asset(
                                                        hatsPaths[
                                                            sortedHats[i]],
                                                        width: 22.w,
                                                      ),
                                                      SizedBox(height: 2.h),
                                                      user.hatsList.contains(
                                                              sortedHats[i]
                                                                  .toString())
                                                          ? Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                setText(
                                                                    user.hatIndex ==
                                                                            sortedHats[
                                                                                i]
                                                                        ? "Equipped"
                                                                        : "Unlocked",
                                                                    FontWeight
                                                                        .w600,
                                                                    14.sp,
                                                                    user.hatIndex ==
                                                                            sortedHats[
                                                                                i]
                                                                        ? primaryPurple
                                                                        : fontColor
                                                                            .withOpacity(0.7))
                                                              ],
                                                            )
                                                          : Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  FontAwesomeIcons
                                                                      .coins,
                                                                  color: fontColor
                                                                      .withOpacity(
                                                                          0.7),
                                                                  size: 5.w,
                                                                ),
                                                                SizedBox(
                                                                    width: 2.w),
                                                                setText(
                                                                    "250 points",
                                                                    FontWeight
                                                                        .w600,
                                                                    13.sp,
                                                                    fontColor
                                                                        .withOpacity(
                                                                            0.7))
                                                              ],
                                                            )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                SizedBox(height: 3.h)
                              ],
                            ),
                          ),
                        ),
                      ).fadeIn(duration: 400.ms)
              ])
            ])));
  }

  void showPowerUpDetails(PowerUp powerUp, UserProgress user) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            int count = powerUp.count;
            return Animate(
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                insetPadding: EdgeInsets.all(5.w),
                backgroundColor: bodyColor,
                content: Container(
                  height: 47.h,
                  width: double.maxFinite,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 2.h),
                      Image.asset(powerUp.iconPath, height: 15.h),
                      SizedBox(height: 1.h),
                      setText(powerUp.name, FontWeight.w600, 16.sp, fontColor),
                      setText(powerUp.description, FontWeight.w500, 14.sp,
                          fontColor.withOpacity(0.6), true),
                      SizedBox(height: 5.h),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            setText("You have: ", FontWeight.w600, 15.sp,
                                fontColor),
                            Animate(
                              child: setText(" ${count}", FontWeight.w600,
                                      15.sp, fontColor)
                                  .animate(
                                      controller: animationController,
                                      autoPlay: false)
                                  .scaleXY(
                                    begin: 1,
                                    end: 1.3,
                                    curve: Curves.easeOut,
                                    duration: 300.ms,
                                  )
                                  .scaleXY(
                                      begin: 1.3,
                                      end: 1,
                                      curve: Curves.easeOut,
                                      duration: 300.ms,
                                      delay: 300.ms),
                            ),
                          ]),
                      SizedBox(height: 2.h),
                      Container(
                        width: 60.w,
                        height: 6.5.h,
                        decoration: BoxDecoration(
                            color: user.points < powerUp.price
                                ? const Color.fromARGB(255, 200, 176, 255)
                                : primaryPurple,
                            borderRadius: BorderRadius.circular(16)),
                        child: TextButton(
                          onPressed: () {
                            if (user.points < powerUp.price || lock) return;
                            update(user, powerUp);
                            playSound("audio/pop.MP3");
                            setState(() {
                              count++;
                            });
                            updateLock();
                            animationController.forward();
                            Timer(Duration(milliseconds: 1000), () {
                              animationController.reset();
                              updateLock();
                            });
                          },
                          style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.coins,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                size: 5.w,
                              ),
                              SizedBox(width: 2.w),
                              setText(
                                  "${powerUp.price} points",
                                  FontWeight.w600,
                                  14.sp,
                                  const Color.fromARGB(255, 255, 255, 255)),
                            ],
                          ),
                        ),
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

  void showItemDetails(
      String image, UserProgress user, int index, String type, int price) {
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 2.h),
                      setText(
                          "Unlock $type", FontWeight.w600, 17.sp, fontColor),
                      SizedBox(height: 1.h),
                      Image.asset(image, height: 15.h),
                      SizedBox(height: 5.h),
                      Container(
                        width: 60.w,
                        height: 6.5.h,
                        decoration: BoxDecoration(
                            color: user.points < price
                                ? const Color.fromARGB(255, 200, 176, 255)
                                : primaryPurple,
                            borderRadius: BorderRadius.circular(16)),
                        child: TextButton(
                          onPressed: () {
                            if (user.points < price || lock) return;

                            // Deduct points
                            user.points -= price;
                            preferences.setInt("userPoints", user.points);

                            // Add to owned items
                            if (type == 'character') {
                              if (!user.charactersList
                                  .contains(index.toString())) {
                                user.addCharacter(index);
                              }
                              // Equip immediately
                              user.changeAvatar(index, user.hatIndex);
                            } else if (type == "hat") {
                              if (!user.hatsList.contains(index.toString())) {
                                user.addhat(index);
                              }
                              // Equip immediately
                              user.changeAvatar(user.characterIndex, index);
                            }

                            playSound("audio/pop.MP3");
                            updateLock();
                            animationController.forward();
                            Timer(Duration(milliseconds: 1000), () {
                              animationController.reset();
                              updateLock();
                              sortLists(); // Re-sort to move to owned section
                            });
                            Navigator.pop(context); // Close dialog
                          },
                          style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.coins,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                size: 5.w,
                              ),
                              SizedBox(width: 2.w),
                              setText("$price points", FontWeight.w600, 14.sp,
                                  const Color.fromARGB(255, 255, 255, 255)),
                            ],
                          ),
                        ),
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

  void update(UserProgress user, PowerUp powerUp) async {
    user.points -= powerUp.price;
    preferences.setInt("userPoints", user.points);
    updatePowerUp(powerUp.id, powerUp.count + 1);
    setState(() {
      powerUp.count++;
    });
  }

  bool lock = false;

  updateLock() {
    setState(() {
      lock = !lock;
    });
  }
}
