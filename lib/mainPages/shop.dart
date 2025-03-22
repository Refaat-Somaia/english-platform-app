import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:funlish_app/model/userProgress.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  List<String> charctersPaths = [
    'assets/images/shop/characters/penguin-purple.png',
    'assets/images/shop/characters/penguin-pink.png',
    'assets/images/shop/characters/penguin-green.png',
    'assets/images/shop/characters/penguin-blue.png',
    'assets/images/shop/characters/penguin-yellow.png',
    'assets/images/shop/characters/hamter-purple.png',
    'assets/images/shop/characters/hamter-blue.png',
    'assets/images/shop/characters/hamter-yellow.png',
    'assets/images/shop/characters/hamter-green.png',
  ];
  List<String> hatsPaths = [
    'assets/images/shop/hats/winter-1.png',
    'assets/images/shop/hats/hat-1.png',
    'assets/images/shop/hats/hat-2.png',
    'assets/images/shop/hats/hat-3.png',
    'assets/images/shop/hats/hat-4.png',
    'assets/images/shop/hats/hat-5.png',
  ];
  List<String> powerUpPaths = [
    'assets/images/bomb.png',
    'assets/images/clock.png',
    'assets/images/castle.png',
    'assets/images/lock.png',
    'assets/images/puzzle.png',
  ];
  List<String> powerUpNames = [
    'Friendly bomb',
    'Extended time',
    'Word defence',
    'Question lock',
    'Puzzle unlock',
  ];
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProgress>(context);

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
              Column(children: [
                SizedBox(
                  height: 4.5.h,
                ),
                setText("Store", FontWeight.w600, 17.sp, fontColor),
                SizedBox(
                  height: 3.h,
                ),
                SizedBox(
                  height: 88.h,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 2.h,
                        ),
                        SizedBox(
                          width: 100.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  setText("Power ups", FontWeight.w600, 16.sp,
                                      fontColor),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    for (int i = 0;
                                        i < powerUpPaths.length;
                                        i++)
                                      Container(
                                        margin: EdgeInsets.only(right: 2.h),
                                        width: 40.w,
                                        height: 22.h,
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color.fromARGB(
                                                        255, 243, 243, 243)
                                                    .withOpacity(0.2),
                                                spreadRadius: 0.01.h,
                                                blurRadius: 8,
                                                offset: const Offset(0, 7),
                                              )
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              powerUpPaths[i],
                                              width: 20.w,
                                            ),
                                            SizedBox(height: 1.h),
                                            setText(
                                                powerUpNames[i],
                                                FontWeight.w600,
                                                14.sp,
                                                fontColor),
                                            SizedBox(height: 2.h),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.coins,
                                                  color: fontColor
                                                      .withOpacity(0.7),
                                                  size: 5.w,
                                                ),
                                                SizedBox(width: 2.w),
                                                setText(
                                                    "900 points",
                                                    FontWeight.w600,
                                                    13.sp,
                                                    fontColor.withOpacity(0.7))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        SizedBox(
                          width: 100.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  setText("Characters", FontWeight.w600, 16.sp,
                                      fontColor),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    for (int i = 0;
                                        i < charctersPaths.length;
                                        i++)
                                      AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        margin: EdgeInsets.only(right: 2.h),
                                        width: 40.w,
                                        height: 20.h,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: user.characterIndex == i
                                                    ? primaryPurple
                                                        .withOpacity(0.8)
                                                    : Colors.transparent,
                                                width: 3),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color.fromARGB(
                                                    255, 243, 243, 243),
                                                spreadRadius: 0.01.h,
                                                blurRadius: 8,
                                                offset: const Offset(0, 7),
                                              )
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255)),
                                        child: TextButton(
                                          style: OutlinedButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)))),
                                          onPressed: () {
                                            user.changeAvatar(i, user.hatIndex);
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                charctersPaths[i],
                                                width: 22.w,
                                              ),
                                              SizedBox(height: 2.h),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    FontAwesomeIcons.coins,
                                                    color: fontColor
                                                        .withOpacity(0.7),
                                                    size: 5.w,
                                                  ),
                                                  SizedBox(width: 2.w),
                                                  setText(
                                                      "800 points",
                                                      FontWeight.w600,
                                                      13.sp,
                                                      fontColor
                                                          .withOpacity(0.7))
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  setText("Hats", FontWeight.w600, 16.sp,
                                      fontColor),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    for (int i = 0; i < hatsPaths.length; i++)
                                      AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        margin: EdgeInsets.only(right: 2.h),
                                        width: 40.w,
                                        height: 20.h,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: user.hatIndex == i
                                                    ? primaryPurple
                                                        .withOpacity(0.8)
                                                    : Colors.transparent,
                                                width: 3),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color.fromARGB(
                                                    255, 243, 243, 243),
                                                spreadRadius: 0.01.h,
                                                blurRadius: 8,
                                                offset: const Offset(0, 7),
                                              )
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255)),
                                        child: TextButton(
                                          style: OutlinedButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)))),
                                          onPressed: () {
                                            user.changeAvatar(
                                                user.characterIndex, i);
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                hatsPaths[i],
                                                width: 22.w,
                                              ),
                                              SizedBox(height: 2.h),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    FontAwesomeIcons.coins,
                                                    color: fontColor
                                                        .withOpacity(0.7),
                                                    size: 5.w,
                                                  ),
                                                  SizedBox(width: 2.w),
                                                  setText(
                                                      "500 points",
                                                      FontWeight.w600,
                                                      13.sp,
                                                      fontColor
                                                          .withOpacity(0.7))
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
                          height: 3.h,
                        )
                      ],
                    ),
                  ),
                )
              ])
            ])));
  }
}
