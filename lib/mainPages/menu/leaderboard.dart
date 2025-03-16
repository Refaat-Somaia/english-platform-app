import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funlish_app/components/userPointsContainer.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:sizer/sizer.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  bool showWeekly = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyColor,
      body: SizedBox(
          width: 100.w,
          height: double.infinity,
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
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                height: 4.5.h,
              ),
              setText("Leaderboard", FontWeight.w600, 17.sp, fontColor),
              SizedBox(
                height: 4.h,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Container(
                  width: 85.w,
                  height: 6.h,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: primaryPurple.withOpacity(0.08)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 400),
                        width: 40.w,
                        curve: Curves.ease,
                        decoration: BoxDecoration(
                            color:
                                showWeekly ? primaryPurple : Colors.transparent,
                            borderRadius: BorderRadius.circular(16)),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              showWeekly = !showWeekly;
                            });
                          },
                          child: Center(
                            child: setText(
                                "Weekly",
                                FontWeight.w600,
                                14.sp,
                                showWeekly
                                    ? bodyColor
                                    : fontColor.withOpacity(0.7)),
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 400),
                        width: 40.w,
                        curve: Curves.ease,
                        decoration: BoxDecoration(
                            // color: const Color.fromARGB(255, 234, 228, 255),
                            color:
                                showWeekly ? Colors.transparent : primaryPurple,
                            borderRadius: BorderRadius.circular(16)),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              showWeekly = !showWeekly;
                            });
                          },
                          child: Center(
                            child: setText(
                                "All time",
                                FontWeight.w600,
                                14.sp,
                                showWeekly
                                    ? fontColor.withOpacity(0.7)
                                    : bodyColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 1.h),
                SizedBox(
                  width: 90.w,
                  height: 35.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/avatar.png',
                                width: 10.w,
                              ),
                              SizedBox(
                                height: 0.5.h,
                              ),
                              setText("userName", FontWeight.w600, 13.sp,
                                  fontColor.withOpacity(0.7)),
                            ],
                          ),
                          Container(
                            width: 15.w,
                            height: 15.h,
                            decoration: BoxDecoration(
                                color: primaryPurple,
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          SizedBox(
                            height: 0.5.h,
                          ),
                          setText(
                              "500 points", FontWeight.bold, 13.sp, fontColor),
                        ],
                      ),
                      SizedBox(width: 5.w),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/avatar.png',
                                width: 10.w,
                              ),
                              SizedBox(
                                height: 0.5.h,
                              ),
                              setText("userName", FontWeight.w600, 13.sp,
                                  fontColor.withOpacity(0.7)),
                            ],
                          ),
                          Container(
                            width: 15.w,
                            height: 20.h,
                            decoration: BoxDecoration(
                                color: primaryBlue,
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          SizedBox(
                            height: 0.5.h,
                          ),
                          setText(
                              "500 points", FontWeight.bold, 13.sp, fontColor),
                        ],
                      ),
                      SizedBox(width: 5.w),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/avatar.png',
                                width: 10.w,
                              ),
                              SizedBox(
                                height: 0.5.h,
                              ),
                              setText("userName", FontWeight.w600, 13.sp,
                                  fontColor.withOpacity(0.7)),
                            ],
                          ),
                          Container(
                            width: 15.w,
                            height: 10.h,
                            decoration: BoxDecoration(
                                color: primaryPurple,
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          SizedBox(
                            height: 0.5.h,
                          ),
                          setText(
                              "500 points", FontWeight.bold, 13.sp, fontColor),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
                SizedBox(
                    height: 36.h,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Userpointscontainer(),
                          Userpointscontainer(),
                          Userpointscontainer(),
                          Userpointscontainer(),
                        ],
                      ),
                    )),
              ])
            ])
          ])),
    );
  }
}
