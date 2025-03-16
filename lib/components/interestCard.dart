import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sizer/sizer.dart';

import '../utility/global.dart';

class InterestCard extends StatefulWidget {
  final String title;
  final List<String> userInterests;

  final IconData icon;
  final int index;

  const InterestCard({
    Key? key,
    required this.userInterests,
    required this.title,
    required this.icon,
    required this.index,
  }) : super(key: key);

  @override
  _InterestCardState createState() => _InterestCardState();
}

class _InterestCardState extends State<InterestCard> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Animate(
      child: GestureDetector(
        onTap: () {
          !isPressed
              ? setState(() {
                  widget.userInterests.add(widget.title);
                  isPressed = true;
                })
              : setState(() {
                  isPressed = false;
                  widget.userInterests.remove(widget.title);
                });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          width: 28.w,
          height: 12.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isPressed ? primaryPurple : fontColor.withOpacity(0.2),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: isPressed ? primaryPurple : fontColor.withOpacity(0.5),
                size: 9.w,
              ),
              SizedBox(
                height: 0.5.h,
              ),
              setText(
                widget.title,
                FontWeight.w600,
                14.sp,
                fontColor.withOpacity(0.8),
              ),
            ],
          ),
        ),
      ),
    )
        .fadeIn(
            duration: 300.ms,
            curve: Curves.ease,
            delay: (100 + widget.index).ms)
        .scaleXY(
            begin: 0.6,
            end: 1,
            curve: Curves.ease,
            duration: 300.ms,
            delay: (50 + widget.index).ms);
  }
}
