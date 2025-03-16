import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:funlish_app/model/player.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class Winscreen extends StatefulWidget {
  final Color color;
  final Function function;
  final List<Player> players;

  const Winscreen(
      {super.key,
      required this.color,
      required this.players,
      required this.function});

  @override
  State<Winscreen> createState() => _WinscreenState();
}

class _WinscreenState extends State<Winscreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset('assets/animations/won.json', width: 50.w, repeat: false),
        SizedBox(height: 1.h),
        Animate(
          child: setText("You Won!!!", FontWeight.w600, 18.sp, fontColor),
        ).fadeIn(delay: 200.ms, duration: 400.ms, begin: 0),
        Animate(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.coins,
                color: fontColor,
                size: 7.w,
              ),
              SizedBox(width: 3.w),
              setText("Points gained: 40", FontWeight.w600, 14.sp,
                  fontColor.withOpacity(0.7)),
            ],
          ),
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
                        onPressed: () {},
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
}
