import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

class Joinsession extends StatefulWidget {
  final String gameName;
  final Color color;
  const Joinsession({super.key, required this.gameName, required this.color});

  @override
  State<Joinsession> createState() => _JoinsessionState();
}

class _JoinsessionState extends State<Joinsession> {
  String sessionId = "154654";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bodyColor,
        body: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Container(
                decoration: BoxDecoration(
                    // color: widget.chapter.colorAsColor.withOpacity(0.05),
                    color: widget.color.withOpacity(0.05)),
                height: double.infinity,
                width: 100.w,
                child: Animate(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 92.w,
                        child: setText("Enter Session Code", FontWeight.w600,
                            15.sp, fontColor.withOpacity(0.8), true),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      SizedBox(
                        width: 95.w,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 2.w,
                          runSpacing: 1.h,
                          children: [
                            for (String s in sessionId.split(""))
                              Container(
                                width: 13.w,
                                height: 13.w,
                                decoration: BoxDecoration(
                                    color: primaryPurple.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: setText(s, FontWeight.w600, 16.sp,
                                      Colors.transparent),
                                ),
                              )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Container(
                        width: 43.w,
                        height: 7.h,
                        decoration: BoxDecoration(
                            color: primaryPurple.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16)),
                        child: TextButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(FontAwesomeIcons.arrowRightFromBracket,
                                  size: 6.w,
                                  color: Colors.white.withOpacity(0.5)),
                              SizedBox(
                                width: 2.w,
                              ),
                              setText("Join", FontWeight.w600, 15.sp,
                                  Colors.white.withOpacity(0.5)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ).fadeIn(duration: 400.ms))));
  }
}
