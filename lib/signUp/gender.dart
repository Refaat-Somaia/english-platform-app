import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:sizer/sizer.dart';

class Gender extends StatefulWidget {
  final bool gender;
  const Gender({super.key, required this.gender});

  @override
  State<Gender> createState() => _GenderState();
}

class _GenderState extends State<Gender> with SingleTickerProviderStateMixin {
  double girlImageWidth = 20.w;
  double guyImageWidth = 0.w;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    preferences.setBool("userGender", false);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyColor,
      body: SizedBox(
        height: 65.h,
        width: 100.w,
        child: Column(
          children: [
            SizedBox(
              height: 5.h,
            ),
            Animate(
                    child:
                        setText("You are a", FontWeight.w600, 19.sp, fontColor))
                .fadeIn(duration: 400.ms, delay: 200.ms),
            SizedBox(
              height: 5.h,
            ),
            Animate(
              child: Stack(
                children: [
                  Positioned(
                    left: 5.w,
                    child: AnimatedBuilder(
                      animation: controller,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1 +
                              (0.8 *
                                  controller.value), // Scale between 1 and 1.4
                          child: Container(
                            width: 4.w,
                            height: 4.w,
                            decoration: BoxDecoration(
                              color: primaryPurple,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryPurple.withOpacity(0.1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          curve: Curves.easeOut,
                          width: girlImageWidth,
                          duration: const Duration(milliseconds: 400),
                          child: Image.asset(
                            'assets/images/girl.png',
                          ),
                        ),
                        AnimatedContainer(
                          curve: Curves.easeOut,
                          width: guyImageWidth,
                          duration: const Duration(milliseconds: 400),
                          child: Image.asset(
                            'assets/images/guy.png',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 5.w,
                    bottom: 0,
                    child: AnimatedBuilder(
                      animation: controller,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1 +
                              (0.8 *
                                  controller.value), // Scale between 1 and 1.4
                          child: Container(
                            width: 4.w,
                            height: 4.w,
                            decoration: BoxDecoration(
                              color: primaryBlue,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
                .slideY(
                    begin: -0.2,
                    end: 0,
                    curve: Curves.ease,
                    duration: 400.ms,
                    delay: 500.ms)
                .fadeIn(),
            SizedBox(
              height: 3.h,
            ),
            Animate(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          guyImageWidth = 0.w;
                          girlImageWidth = 20.w;
                        });
                        preferences.setBool("userGender", false);
                      },
                      child: setText(
                        "Girl",
                        FontWeight.w600,
                        18.sp,
                        fontColor.withOpacity(
                          girlImageWidth == 20.w ? 1 : 0.3,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          guyImageWidth = 20.w;
                          girlImageWidth = 0.w;
                        });
                        preferences.setBool("userGender", true);
                      },
                      child: setText(
                        "Guy",
                        FontWeight.w600,
                        18.sp,
                        fontColor.withOpacity(
                          guyImageWidth == 20.w ? 1 : 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ).fadeIn(duration: 400.ms, delay: 500.ms),
            SizedBox(
              height: 3.h,
            ),
            Animate(
              child: SizedBox(
                width: 90.w,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                        text: "This information won't be shown to ohters ",
                        style: TextStyle(
                            fontFamily: "magnet",
                            fontSize: 16.sp,
                            color: fontColor.withOpacity(0.5),
                            fontWeight: FontWeight.w500)),
                    TextSpan(
                        text: "🥸",
                        style: TextStyle(
                            fontFamily: "magnet",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500)),
                    TextSpan(
                        text:
                            ", we only use it to provide the best possible experience for you.",
                        style: TextStyle(
                            fontFamily: "magnet",
                            fontSize: 16.sp,
                            color: fontColor.withOpacity(0.5),
                            fontWeight: FontWeight.w500)),
                    TextSpan(
                        text: "😁",
                        style: TextStyle(
                            fontFamily: "magnet",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500))
                  ]),
                ),
              ),
            ).fadeIn(duration: 400.ms, delay: 500.ms)
          ],
        ),
      ),
    );
  }
}
