import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sizer/sizer.dart';

import '../utility/global.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bodyColor,
        body: SizedBox(
            height: 70.h,
            width: 100.w,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                  width: 90.w,
                  child: Animate(
                    child: setText("Ready for a quiz? 🤓", FontWeight.w600,
                        18.sp, fontColor, true),
                  ).fadeIn(duration: 400.ms, delay: 200.ms)),
              SizedBox(
                height: 1.h,
              ),
              Animate(
                child: SizedBox(
                  width: 90.w,
                  child: setText(
                      "This quiz will help us best understand your level at Engilsh in order for us to be able to track your progress.",
                      FontWeight.w500,
                      14.sp,
                      fontColor.withOpacity(0.6),
                      true),
                ),
              ).fadeIn(duration: 400.ms, delay: 400.ms),
              SizedBox(
                height: 5.h,
              ),
              Animate(
                child: SizedBox(
                  width: 90.w,
                  height: 25.h,
                  child: Image.asset(
                    'assets/images/mascot-quiz.png',
                  ),
                ),
              )
                  .slideX(
                      begin: -0.2,
                      end: 0,
                      curve: Curves.ease,
                      duration: 400.ms,
                      delay: 300.ms)
                  .fadeIn(),
            ])));
  }
}
