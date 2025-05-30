import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:funlish_app/components/avatar.dart';
import 'package:funlish_app/model/player.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class Lostscreen extends StatefulWidget {
  final Color color;
  final Function function;
  final List<dynamic> words;
  final List<Player> players;

  const Lostscreen(
      {super.key,
      required this.color,
      required this.words,
      required this.players,
      required this.function});

  @override
  State<Lostscreen> createState() => _LostscreenState();
}

class _LostscreenState extends State<Lostscreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset('assets/animations/lost.json', width: 50.w, repeat: true),
        SizedBox(height: 1.h),
        Animate(
          child: setText("You Lost!!!", FontWeight.w600, 18.sp, fontColor),
        ).fadeIn(delay: 200.ms, duration: 400.ms, begin: 0),
        Animate(
          child: setText("Better luck next time", FontWeight.w600, 14.sp,
              fontColor.withOpacity(0.7)),
        ).fadeIn(delay: 400.ms, duration: 400.ms, begin: 0),
        SizedBox(height: 7.h),
        Animate(
          child: Container(
            width: 90.w,
            height: 7.h,
            decoration: BoxDecoration(
                color: widget.color, borderRadius: BorderRadius.circular(16)),
            child: TextButton(
              style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)))),
              onPressed: () {
                widget.function();
              },
              child:
                  setText("Play again", FontWeight.w600, 15.sp, Colors.white),
            ),
          ),
        )
            .fadeIn(begin: 0, delay: 500.ms, duration: 400.ms)
            .slideY(begin: 0.7, end: 0, curve: Curves.ease),
        SizedBox(height: 2.h),
        Animate(
            child: SizedBox(
                width: 90.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 43.w,
                      height: 7.h,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16)),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)))),
                        child: setText(
                            "Leave", FontWeight.w600, 14.5.sp, widget.color),
                      ),
                    ),
                    Container(
                      width: 43.w,
                      height: 7.h,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16)),
                      child: TextButton(
                        onPressed: () {
                          showMatchDetails();
                        },
                        style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)))),
                        child: setText("Match details", FontWeight.w600,
                            14.5.sp, widget.color),
                      ),
                    ),
                  ],
                ))).fadeIn(begin: 0, delay: 600.ms, duration: 500.ms).slideY(
            begin: 1.2, end: 0, curve: Curves.ease),
      ],
    );
  }

  void showMatchDetails() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Animate(
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                insetPadding: EdgeInsets.all(5.w),
                backgroundColor: bodyColor,
                content: Container(
                  height: 60.h,
                  width: double.maxFinite,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 2.h),
                        SizedBox(
                          width: 70.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  setText("Player", FontWeight.w600, 17.sp,
                                      fontColor),
                                  for (var player in widget.players)
                                    SizedBox(
                                      height: 15.h,
                                      child: Column(
                                        children: [
                                          Avatar(
                                              characterIndex:
                                                  player.characterIndex,
                                              hatIndex: player.hatIndex,
                                              width: 10.h),
                                          SizedBox(
                                            height: 1.h,
                                          ),
                                          setText(player.name, FontWeight.w600,
                                              14.sp, fontColor.withOpacity(0.7))
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              Column(
                                children: [
                                  setText("Points", FontWeight.w600, 17.sp,
                                      fontColor),
                                  for (var player in widget.players)
                                    SizedBox(
                                      height: 15.h,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          setText(player.points.toString(),
                                              FontWeight.bold, 16.sp, fontColor)
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 2.h),
                        SizedBox(
                            width: 70.w,
                            child: setText("Answers: ${widget.words}",
                                FontWeight.w600, 15.sp, fontColor)),
                        SizedBox(height: 5.h),
                        Container(
                          width: 60.w,
                          height: 6.5.h,
                          decoration: BoxDecoration(
                              color: widget.color,
                              borderRadius: BorderRadius.circular(16)),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)))),
                            child: setText(
                                "Ok", FontWeight.w600, 14.5.sp, Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
                .slideY(begin: .1, end: 0, curve: Curves.ease, duration: 400.ms)
                .fadeIn();
          });
        });
  }
}
