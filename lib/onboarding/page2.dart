import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:sizer/sizer.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

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
                width: 90.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 25.h,
                    ),
                    Stack(children: [
                      Positioned(
                        left: 5.w,
                        child: Animate(
                          child: Icon(
                            Icons.sports_baseball_sharp,
                            color: primaryPurple.withOpacity(0.8),
                          ),
                        )
                            .slide(
                                end: Offset(-2, -1),
                                delay: 300.ms,
                                curve: Curves.easeOut,
                                duration: 800.ms)
                            .fade(
                              curve: Curves.easeOut,
                            ),
                      ),
                      Positioned(
                        left: 5.w,
                        child: Animate(
                          child: Icon(
                            Icons.book,
                            color: primaryPurple.withOpacity(0.8),
                          ),
                        )
                            .slide(
                                end: Offset(0, -2),
                                delay: 400.ms,
                                curve: Curves.easeOut,
                                duration: 800.ms)
                            .fade(
                              curve: Curves.easeOut,
                            ),
                      ),
                      Positioned(
                        left: 5.w,
                        child: Animate(
                          child: Icon(
                            Icons.headset_outlined,
                            color: primaryPurple.withOpacity(0.8),
                          ),
                        )
                            .slide(
                                end: Offset(2, -2),
                                curve: Curves.easeOut,
                                delay: 500.ms,
                                duration: 800.ms)
                            .fade(
                              curve: Curves.easeOut,
                            ),
                      ),
                      Positioned(
                        left: 5.w,
                        child: Animate(
                          child: Icon(
                            Icons.camera_alt_rounded,
                            color: primaryPurple.withOpacity(0.8),
                          ),
                        )
                            .slide(
                                end: Offset(4, -1),
                                delay: 600.ms,
                                curve: Curves.easeOut,
                                duration: 800.ms)
                            .fade(
                              curve: Curves.easeOut,
                            ),
                      ),
                      Image.asset(
                        'assets/images/mascot-thinking.png',
                        width: 30.w,
                      ),
                      Positioned(
                        top: 11.5.h,
                        left: 10.w,
                        child: Animate(
                          child: Image.asset(
                            'assets/images/pencil.png',
                            width: 5.w,
                          ),
                        ).rotate(
                            delay: 500.ms,
                            begin: 0,
                            end: 0.5,
                            duration: 400.ms,
                            curve: Curves.easeOut),
                      ),
                    ]),
                    SizedBox(
                      height: 9.h,
                    ),
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          setText("Your", FontWeight.w600, 17.sp, fontColor),
                          setText(" Personalized ", FontWeight.w600, 17.sp,
                              primaryPurple),
                          setText(
                              "experience", FontWeight.w600, 17.sp, fontColor),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    setText(
                        "Our AI studies your vibes and in-app adventures to craft the ultimate learning experience just for you!",
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
