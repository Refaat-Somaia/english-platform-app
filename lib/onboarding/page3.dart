import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:funlish_app/utility/custom_icons_icons.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;

class Page3 extends StatelessWidget {
  const Page3({super.key});

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
              left: 7.5.w,
              child: Image.asset(
                "assets/images/blob-3.png",
                width: 85.w,
              ),
            ),
            Animate(
              child: Positioned(
                  left: 20.w,
                  height: 52.h,
                  child: Icon(
                    Icons.chat_rounded,
                    color: primaryBlue.withOpacity(0.5),
                    size: 10.w,
                  )),
            )
                .slideY(
                    begin: 0.05,
                    end: 0,
                    curve: Curves.easeOut,
                    duration: 400.ms,
                    delay: 400.ms)
                .fadeIn(),
            Animate(
              child: Positioned(
                  left: 47.w,
                  height: 56.h,
                  child: Transform.flip(
                    flipX: true,
                    child: Icon(
                      Icons.chat_rounded,
                      color: primaryPurple.withOpacity(0.7),
                      size: 10.w,
                    ),
                  )),
            )
                .slideY(
                    begin: 0.05,
                    end: 0,
                    curve: Curves.easeOut,
                    duration: 400.ms,
                    delay: 600.ms)
                .fadeIn(),
            Center(
              child: SizedBox(
                width: 90.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Image.asset(
                        'assets/images/mascot-talking.png',
                        width: 23.w,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Image.asset(
                        'assets/images/mascot-pink.png',
                        width: 23.w,
                      ),
                      Image.asset(
                        'assets/images/mascot-green.png',
                        width: 23.w,
                      ),
                    ]),
                    SizedBox(
                      height: 7.h,
                    ),
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          setText(
                              "Join the ", FontWeight.w600, 17.sp, fontColor),
                          setText("Conversation! ", FontWeight.w600, 17.sp,
                              primaryPurple),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    setText(
                        "Engage in exciting discussions️. Share your thoughts and hot takes🔥, explore new ideas all in a community that loves learning just like you!",
                        FontWeight.w500,
                        14.sp,
                        fontColor.withOpacity(0.6),
                        true)
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
