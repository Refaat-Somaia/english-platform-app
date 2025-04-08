import 'dart:async';

import 'package:flash_card/flash_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:funlish_app/model/learnedWord.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:sizer/sizer.dart';

class FlashcardsPage extends StatefulWidget {
  final List<Learnedword> word;

  const FlashcardsPage({super.key, required this.word});

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage>
    with SingleTickerProviderStateMixin {
  int activeIndex = 0;
  late AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  bool isAnimating = false; // Prevent multiple swipes

  void _onSwipe(String direction) {
    if (isAnimating) return; // Ignore swipe if animation is running

    if (direction == "right" && activeIndex < widget.word.length - 1) {
      isAnimating = true;
      animationController.reverse();

      Timer(Duration(milliseconds: 700), () {
        setState(() {
          activeIndex++;
        });
        animationController.forward().then((_) {
          isAnimating = false; // Allow next swipe
        });
      });
    } else if (direction == "left" && activeIndex > 0) {
      isAnimating = true;
      animationController.reverse();

      Timer(Duration(milliseconds: 700), () {
        setState(() {
          activeIndex--;
        });
        animationController.forward().then((_) {
          isAnimating = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              Positioned(
                right: 4.w,
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
                        Icons.question_mark_rounded,
                        size: 6.w,
                        color: Colors.white,
                      )),
                ),
              ),
              Column(children: [
                SizedBox(
                  height: 4.5.h,
                ),
                setText("Flash cards", FontWeight.w600, 17.sp, fontColor),
                SizedBox(
                  height: 10.h,
                ),
                GestureDetector(
                    onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity! > 0) {
                        _onSwipe("left");
                      } else if (details.primaryVelocity! < 0) {
                        _onSwipe("right");
                      }
                    },
                    child: SizedBox(
                      width: 100.w,
                      child: Center(
                        child: Animate(
                          child: FlashCard(
                            key: ValueKey(
                                activeIndex), // 👈 Forces a rebuild when activeIndex changes!
                            width: 70.w,
                            height: 40.h,
                            frontWidget: () => Container(
                              width: 70.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: primaryPurple.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 60.w,
                                    child: setText(
                                        widget.word[activeIndex]
                                            .description, // Now updates correctly
                                        FontWeight.w600,
                                        15.sp,
                                        fontColor,
                                        true),
                                  )
                                ],
                              ),
                            ),
                            backWidget: () => Container(
                              width: 70.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: primaryPurple.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  setText(
                                      widget.word[activeIndex]
                                          .word, // Now updates correctly
                                      FontWeight.bold,
                                      18.sp,
                                      fontColor)
                                ],
                              ),
                            ),
                          ),
                        )
                            .animate(
                                controller: animationController, autoPlay: true)
                            .rotate(
                                begin: -0.3,
                                end: 0,
                                delay: 200.ms,
                                duration: 600.ms,
                                curve: Curves.ease)
                            .fadeIn(),
                      ),
                    )),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  width: 90.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Animate(
                        child: Container(
                          width: 60.w,
                          height: 7.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              // border: Border.all(
                              //     width: 1.5, color: fontColor.withOpacity(0.2))
                              color: primaryPurple),
                          child: TextButton(
                              style: buttonStyle(8),
                              onPressed: () {
                                if (activeIndex < widget.word.length - 1) {
                                  animationController.reverse();

                                  Timer(Duration(milliseconds: 700), () {
                                    setState(() {
                                      activeIndex++;
                                    });
                                    animationController.forward();
                                  });
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 3.w,
                                children: [
                                  setText("Next", FontWeight.w600, 15.sp,
                                      Colors.white),
                                  Icon(
                                    Icons.arrow_forward_sharp,
                                    size: 7.w,
                                    color: Colors.white,
                                  )
                                ],
                              )),
                        ),
                      ).fadeIn(delay: 500.ms),
                    ],
                  ),
                )
              ])
            ])));
  }
}
