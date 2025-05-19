import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:funlish_app/components/modals/successModal.dart';
import 'package:lottie/lottie.dart';
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
                      width: 60.w,
                      height: 6.5.h,
                      decoration: BoxDecoration(
                          color: primaryPurple,
                          borderRadius: BorderRadius.circular(16)),
                      child: TextButton(
                        onPressed: () {
                          preferences.setInt(
                              "userPoints",
                              preferences.getInt("userPoints") != null
                                  ? preferences.getInt("userPoints")! + 1000
                                  : 1000);
                          preferences.setBool("isShownGift", true);

                          Navigator.pop(context); // Close dialog
                          Timer(Duration(seconds: 1), () {
                            showSuccessModal(
                                context, "You have received 1000 points");
                          });
                        },
                        style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 2.w),
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
