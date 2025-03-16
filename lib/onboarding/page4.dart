import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:sizer/sizer.dart';

class Page4 extends StatelessWidget {
  const Page4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyColor,
      body: SizedBox(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 10.h,
              left: 5.w,
              child: Image.asset(
                "assets/images/blob-2.png",
                width: 90.w,
              ),
            ),
            Center(
              child: SizedBox(
                width: 92.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 25.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Animate(
                          child: Image.asset(
                            'assets/images/healthcare.png',
                            width: 25.w,
                          ),
                        )
                            .scale(
                                begin: Offset(0, 0),
                                end: Offset(1.2, 1.2),
                                curve: Curves.easeOut,
                                duration: 500.ms)
                            .scale(
                                begin: Offset(1.2, 1.2),
                                delay: 500.ms,
                                duration: 500.ms,
                                end: Offset(1, 1),
                                curve: Curves.easeOut),
                        Animate(
                          child: Image.asset(
                            'assets/images/house.png',
                            width: 25.w,
                          ),
                        )
                            .scale(
                                begin: Offset(0, 0),
                                end: Offset(1.2, 1.2),
                                curve: Curves.easeOut,
                                delay: 200.ms,
                                duration: 500.ms)
                            .scale(
                                begin: Offset(1.2, 1.2),
                                delay: 500.ms,
                                duration: 700.ms,
                                end: Offset(1, 1),
                                curve: Curves.easeOut),
                        Animate(
                          child: Image.asset(
                            'assets/images/education.png',
                            width: 25.w,
                          ),
                        )
                            .scale(
                                begin: Offset(0, 0),
                                end: Offset(1.2, 1.2),
                                curve: Curves.easeOut,
                                delay: 400.ms,
                                duration: 500.ms)
                            .scale(
                                begin: Offset(1.2, 1.2),
                                delay: 500.ms,
                                duration: 900.ms,
                                end: Offset(1, 1),
                                curve: Curves.easeOut),
                      ],
                    ),
                    SizedBox(
                      height: 17.h,
                    ),
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          setText(
                              "Learn with ", FontWeight.w600, 17.sp, fontColor),
                          setText("Chapters", FontWeight.w600, 17.sp,
                              primaryPurple),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Animate(
                      child: setText(
                          "Each chapter dives into a fun heme from Travel ✈️ to Healthcare 🏥 helping you learn words in real-life contexts!",
                          FontWeight.w500,
                          14.sp,
                          fontColor.withOpacity(0.6),
                          true),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
