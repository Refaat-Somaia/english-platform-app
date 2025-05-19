import 'package:flutter/cupertino.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class EmptyPlaceHolder extends StatelessWidget {
  final String text;
  const EmptyPlaceHolder({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset('assets/animations/empty.json', width: 30.w),
        SizedBox(
          height: 1.h,
        ),
        SizedBox(
            width: 92.w,
            child: setText(text, FontWeight.w500, 15.sp,
                fontColor.withOpacity(0.6), true)),
      ],
    );
  }
}
