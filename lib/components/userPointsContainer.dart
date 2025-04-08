import 'package:flutter/cupertino.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:sizer/sizer.dart';

class Userpointscontainer extends StatefulWidget {
  const Userpointscontainer({super.key});

  @override
  State<Userpointscontainer> createState() => _UserpointscontainerState();
}

class _UserpointscontainerState extends State<Userpointscontainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: 92.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: primaryPurple.withOpacity(0.08)),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: primaryPurple),
            child: Center(
              child: setText("1", FontWeight.bold, 13.sp, bodyColor),
            ),
          ),
          SizedBox(
            width: 3.w,
          ),
          Container(
            // width: 75.w,
            height: 10.h,
            child: Center(
              child: SizedBox(
                width: 73.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/avatar.png",
                          height: 6.5.h,
                        ),
                        SizedBox(width: 3.w),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            setText(
                                "Refaat", FontWeight.w600, 14.sp, fontColor),
                            setText("level 1", FontWeight.w600, 13.sp,
                                fontColor.withOpacity(0.6))
                          ],
                        ),
                      ],
                    ),
                    setText("300 points", FontWeight.bold, 14.sp, fontColor)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
