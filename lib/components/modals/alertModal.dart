import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../utility/global.dart';

void showAlertModal(BuildContext context, String msg) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        decoration: BoxDecoration(
            color: bodyColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        height: 30.h,
        width: 100.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Animate(
              child: Icon(
                FontAwesomeIcons.circleExclamation,
                size: 7.h,
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
            SizedBox(
                width: 90.w,
                child: setText(msg, FontWeight.w500, 15.sp, fontColor, true)),
          ],
        ),
      );
    },
  );
}
