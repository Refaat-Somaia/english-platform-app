import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:funlish_app/components/avatar.dart';
import 'package:funlish_app/model/player.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:sizer/sizer.dart';

class Countdownscreen extends StatefulWidget {
  final List<Player> players;
  final int time;
  final Color color;
  const Countdownscreen(
      {super.key,
      required this.players,
      required this.time,
      required this.color});

  @override
  State<Countdownscreen> createState() => _CountdownscreenState();
}

class _CountdownscreenState extends State<Countdownscreen> {
  @override
  void initState() {
    super.initState();
    // _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Animate(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        setText("Match found!", FontWeight.w600, 17.sp, fontColor),
        SizedBox(height: 4.h),
        Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.w,
            runSpacing: 2.h,
            children: List.generate(
                widget.players.length,
                (index) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.w),
                      child: Animate(
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: index % 2 == 0
                                  ? primaryPurple.withOpacity(0.15)
                                  : primaryBlue.withOpacity(0.15)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Avatar(
                                  characterIndex:
                                      widget.players[index].characterIndex,
                                  hatIndex: widget.players[index].hatIndex,
                                  width: 18.w),
                              SizedBox(
                                height: 1.h,
                              ),
                              setText(
                                  widget.players[index].name.toString(),
                                  FontWeight.w600,
                                  14.5.sp,
                                  fontColor.withOpacity(0.8)),
                              setText(
                                  "Level: ${widget.players[index].level}",
                                  FontWeight.w600,
                                  13.sp,
                                  fontColor.withOpacity(0.5)),
                              // setText(
                              //     "Level: 1",
                              //     FontWeight.w600,
                              //     13.sp,
                              //     fontColor.withOpacity(0.5)),
                            ],
                          ),
                        ),
                      )
                          .scaleXY(
                              begin: 0,
                              end: 1,
                              curve: Curves.easeOut,
                              duration: 300.ms,
                              delay: (index * 200).ms)
                          .scaleXY(
                              begin: 1.2,
                              end: 1,
                              curve: Curves.easeOut,
                              duration: 300.ms,
                              delay: (300 + (index * 200)).ms),
                    ))),
        SizedBox(
          height: 8.h,
        ),
        setText(widget.time.toString(), FontWeight.w600, 18.sp, widget.color),
      ],
    )).fadeIn(delay: 200.ms, duration: 400.ms, begin: 0);
  }
}
