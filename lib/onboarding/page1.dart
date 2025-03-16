import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:sizer/sizer.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyColor,
      body: SizedBox(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Image.asset(
              "assets/images/blob-1.png",
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
                    Image.asset(
                      'assets/images/mascot-greating.png',
                      width: 35.w,
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Animate(
                                child: setText(
                                    "The", FontWeight.w600, 17.sp, fontColor))
                            .slideY(
                                begin: 0.8,
                                end: 0,
                                duration: 400.ms,
                                delay: 300.ms,
                                curve: Curves.easeOut)
                            .fadeIn(
                              curve: Curves.easeOut,
                            ),
                        Animate(
                                child: setText(" Fun ", FontWeight.w600, 17.sp,
                                    primaryPurple))
                            .slideY(
                                begin: 0.8,
                                end: 0,
                                duration: 400.ms,
                                delay: 300.ms,
                                curve: Curves.easeOut)
                            .fadeIn(curve: Curves.easeOut),
                        Animate(
                          child: setText("side of English!", FontWeight.w600,
                              17.sp, fontColor),
                        )
                            .slideY(
                                begin: 0.8,
                                end: 0,
                                duration: 400.ms,
                                delay: 300.ms,
                                curve: Curves.easeOut)
                            .fadeIn(curve: Curves.easeOut),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Animate(
                      child: setText(
                          "Ready to dive into a whole new way of learning English? We're here to make it fun, personalized, and unforgettable. ✨",
                          FontWeight.w500,
                          14.sp,
                          fontColor.withOpacity(0.6),
                          true),
                    ).fadeIn(
                        curve: Curves.easeOut, duration: 400.ms, delay: 500.ms)
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
