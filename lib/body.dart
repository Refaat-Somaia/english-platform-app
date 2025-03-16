import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:funlish_app/mainPages/games/games.dart';
import 'package:funlish_app/mainPages/threads/threads.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:funlish_app/mainPages/chapters/chapters.dart';
import 'package:funlish_app/mainPages/home.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:sizer/sizer.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int activeIndex = 0;
  List<Widget> pages = [Home(), Chapters(), Games(), Threads()];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyColor,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(right: 5.w, left: 5.w, bottom: 1.h, top: 1.h),
        child: GNav(
            gap: 3.w,
            padding: EdgeInsets.all(3.w),
            // backgroundColor: fontColor,
            selectedIndex: activeIndex,
            tabs: [
              GButton(
                icon: FontAwesomeIcons.house,
                iconSize: 5.w,
                text: "Home",
                borderRadius: BorderRadius.circular(12),
                textStyle: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'magnet',
                    color: bodyColor,
                    fontWeight: FontWeight.w600),
                iconColor: fontColor.withOpacity(0.5),
                textColor: bodyColor,
                backgroundColor: primaryPurple,
                haptic: true,
                iconActiveColor: bodyColor,
                onPressed: () {
                  setState(() {
                    activeIndex = 0;
                  });
                },
              ),
              GButton(
                icon: FontAwesomeIcons.chartPie,
                iconSize: 5.w,
                text: "Chapters",
                borderRadius: BorderRadius.circular(12),
                textStyle: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'magnet',
                    color: bodyColor,
                    fontWeight: FontWeight.w600),
                iconColor: fontColor.withOpacity(0.5),
                textColor: bodyColor,
                backgroundColor: primaryPurple,
                haptic: true,
                iconActiveColor: bodyColor,
                onPressed: () {
                  setState(() {
                    activeIndex = 1;
                  });
                },
              ),
              GButton(
                icon: FontAwesomeIcons.gamepad,
                iconSize: 5.w,
                text: "Games",
                borderRadius: BorderRadius.circular(12),
                textStyle: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'magnet',
                    color: bodyColor,
                    fontWeight: FontWeight.w600),
                iconColor: fontColor.withOpacity(0.5),
                textColor: bodyColor,
                backgroundColor: primaryPurple,
                haptic: true,
                iconActiveColor: bodyColor,
                onPressed: () {
                  setState(() {
                    activeIndex = 2;
                  });
                },
              ),
              GButton(
                icon: FontAwesomeIcons.podcast,
                iconSize: 5.w,
                text: "Threads",
                borderRadius: BorderRadius.circular(12),
                textStyle: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'magnet',
                    color: bodyColor,
                    fontWeight: FontWeight.w600),
                iconColor: fontColor.withOpacity(0.5),
                textColor: bodyColor,
                backgroundColor: primaryPurple,
                haptic: true,
                iconActiveColor: bodyColor,
                onPressed: () {
                  setState(() {
                    activeIndex = 3;
                  });
                },
              ),
            ]),
      ),
      body: SizedBox(
        height: double.infinity,
        width: 100.w,
        child: Stack(
          children: [
            SizedBox(
              child: pages[activeIndex],
            ),
          ],
        ),
      ),
    );
  }
}
