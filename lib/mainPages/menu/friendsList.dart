import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:funlish_app/components/avatar.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

class Friendslist extends StatefulWidget {
  const Friendslist({super.key});

  @override
  State<Friendslist> createState() => _FriendslistState();
}

class _FriendslistState extends State<Friendslist> {
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          backgroundColor: bodyColor,
          body: SizedBox(
              width: 100.w,
              height: 100.h,
              child: Stack(alignment: Alignment.center, children: [
                Positioned(
                  left: 4.w,
                  top: 3.h,
                  child: Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        // border: Border.all(
                        //     width: 1.5, color: fontColor.withOpacity(0.2))
                        color: primaryPurple),
                    child: IconButton(
                        style: IconButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          size: 7.w,
                          color: Colors.white,
                        )),
                  ),
                ),
                Column(children: [
                  SizedBox(
                    height: 4.5.h,
                  ),
                  setText("Friends list", FontWeight.w600, 17.sp, fontColor),
                  SizedBox(
                    height: 3.h,
                  ),
                  SizedBox(
                      height: 88.h,
                      child: isLoading
                          ? Animate(
                              child: SizedBox(
                                height: 88.h,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    LoadingAnimationWidget.fallingDot(
                                        color: primaryPurple, size: 18.w),
                                    SizedBox(height: 1.h),
                                    setText("Loading items...", FontWeight.w600,
                                        16.sp, fontColor),
                                  ],
                                ),
                              ),
                            ).fadeIn(duration: 400.ms, delay: 200.ms)
                          : Animate(
                              child: Column(
                              children: [
                                Container(
                                    width: 90.w,
                                    height: 6.5.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: fontColor.withOpacity(0.1),
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: TextFormField(
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontFamily: "magnet",
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600,
                                            color: fontColor),
                                        decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.zero,
                                            counterText: "",
                                            hintStyle: TextStyle(
                                              fontFamily: "magnet",
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w500,
                                              color: fontColor.withOpacity(0.3),
                                            ),
                                            hintText: "Search...",
                                            border: InputBorder.none,
                                            prefixIcon: Icon(
                                              Icons.search_rounded,
                                              size: 7.w,
                                              // color: fontColor,
                                            )),
                                        maxLength: 70,
                                        controller: searchController,
                                      ),
                                    )),
                                SizedBox(height: 2.5.h),
                                friendContiner("user name", 6),
                                friendContiner("user name", 6),
                                friendContiner("user name", 6),
                              ],
                            )).fadeIn(
                              duration: 400.ms,
                            ))
                ])
              ]))),
    );
  }

  Widget friendContiner(String name, int level) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.5.h),
      width: 90.w,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: primaryPurple.withOpacity(0.1)),
      child: Row(
        children: [
          Avatar(characterIndex: 1, hatIndex: 1, width: 15.w),
          SizedBox(width: 3.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              setText(name, FontWeight.w500, 15.5.sp, fontColor),
              setText("Level $level", FontWeight.w500, 14.sp,
                  fontColor.withOpacity(0.6)),
            ],
          )
        ],
      ),
    );
  }
}
