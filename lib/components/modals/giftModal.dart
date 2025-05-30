import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:funlish_app/components/modals/successModal.dart';
import 'package:funlish_app/model/userProgress.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../utility/global.dart';

void showGiftModal(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Animate(
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              insetPadding: EdgeInsets.all(5.w),
              backgroundColor: bodyColor,
              content: SizedBox(
                height: 40.h,
                width: double.maxFinite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 2.h),
                    setText("A gift from the developer", FontWeight.w600, 16.sp,
                        fontColor, true),
                    SizedBox(height: 1.h),
                    Lottie.asset("assets/animations/gift.json", width: 40.w),
                    SizedBox(height: 5.h),
                    Container(
                      width: 50.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                          color: primaryPurple,
                          borderRadius: BorderRadius.circular(16)),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                          showMsgModal(context);
                        },
                        style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            setText("Open", FontWeight.w600, 14.sp,
                                const Color.fromARGB(255, 255, 255, 255)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
              .slideY(begin: .1, end: 0, curve: Curves.ease, duration: 400.ms)
              .fadeIn();
        });
      });
}

void showMsgModal(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Animate(
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              insetPadding: EdgeInsets.all(5.w),
              backgroundColor: bodyColor,
              content: SizedBox(
                height: 40.h,
                width: double.maxFinite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 5.h),
                    Icon(
                      FontAwesomeIcons.coins,
                      color: primaryPurple,
                      size: 8.h,
                    ),
                    SizedBox(height: 3.h),
                    setText("You have received 1500 points!", FontWeight.w600,
                        16.sp, fontColor, true),
                    SizedBox(height: 5.h),
                    Container(
                      width: 50.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                          color: primaryPurple,
                          borderRadius: BorderRadius.circular(16)),
                      child: TextButton(
                        onPressed: () {
                          final user =
                              Provider.of<UserProgress>(context, listen: false);

                          user.addPoints(1500);
                          preferences.setBool("isShownGift", true);

                          Navigator.pop(context); // Close dialog
                        },
                        style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            setText("Collect", FontWeight.w600, 14.sp,
                                const Color.fromARGB(255, 255, 255, 255)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
              .slideY(begin: .1, end: 0, curve: Curves.ease, duration: 400.ms)
              .fadeIn();
        });
      });
}
