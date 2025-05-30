import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../utility/global.dart';

void showSuccessModal(BuildContext context, String msg) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        decoration: BoxDecoration(
            color: bodyColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        height: 32.h,
        width: 100.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Animate(
              child: Icon(
                msg == "Code was copied to Clipboard"
                    ? FontAwesomeIcons.clipboardCheck
                    : msg == "You have received 1000 points"
                        ? FontAwesomeIcons.coins
                        : FontAwesomeIcons.fileCircleCheck,
                size: 6.5.h,
                color: primaryPurple,
              ),
            )
                .scaleXY(
                  begin: 0,
                  end: 1.3,
                  curve: Curves.easeOut,
                  duration: 300.ms,
                )
                .scaleXY(
                    begin: 1.2,
                    end: 1,
                    curve: Curves.easeOut,
                    duration: 300.ms,
                    delay: 300.ms),
            SizedBox(
              height: 4.h,
            ),
            setText(msg, FontWeight.w500, 15.sp, fontColor),
            SizedBox(
              height: 2.h,
            ),
            Container(
              width: 50.w,
              height: 6.h,
              decoration: BoxDecoration(
                  color: primaryPurple,
                  borderRadius: BorderRadius.circular(12)),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    setText("Ok", FontWeight.w600, 15.sp,
                        const Color.fromARGB(255, 255, 255, 255)),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
