import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:funlish_app/body.dart';
import 'package:funlish_app/screens/onboarding.dart';
import 'package:funlish_app/utility/databaseHandler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sizer/sizer.dart';
import 'dart:math' as math;

import '../utility/global.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    awaitDB();
    // });
  }

  void awaitDB() async {
    await openDB();
    preferences = await SharedPreferences.getInstance();
    chapters = await getChaptersFromDB();
    if (chapters.isEmpty) {
      final db = await database;

      await insertChapters(db!);
      await insertMcqLevels(db);
      await insertDefaultPowerUps(db); // Ensure power-ups are preloaded
      await insertDefaultGamesStats(db);
      chapters = await getChaptersFromDB();
    }

    setState(() {});
    Future.delayed(const Duration(seconds: 2), () async {
      if (preferences.getBool("isDarkMode") == null) {
        preferences.setBool("isDarkMode", false);
        preferences.setStringList("userChapters", ["1", "4", "5", "6"]);
        preferences.setBool("isInGameSounds", true);
        preferences.setBool("isShowUserInterests", true);
      } else if (preferences.getBool("isDarkMode") == true) {
        bodyColor = Color.fromARGB(255, 23, 16, 39);
        fontColor = Color(0xffF9F7FF);
      }
      Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: (_) => Sizer(builder: (context, orientation, screenType) {
                return (preferences.getBool("isLoggedIn") != null &&
                        preferences.getBool("isLoggedIn") == true)
                    ? Body(
                        pageIndex: 0,
                      )
                    : Onboarding();
              })));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffF9F7FF),
      child: Animate(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Animate(
                  child: Transform.rotate(
                    angle: 135 * math.pi / 180,
                    child: Container(
                      width: 1.w,
                      height: 3.h,
                      color: primaryBlue,
                    ),
                  ),
                )
                    .slide(
                        delay: 1000.ms,
                        begin: const Offset(0, 0),
                        end: const Offset(-15, -2),
                        curve: Curves.ease,
                        duration: 1000.ms)
                    .fadeIn(delay: 1000.ms)
                    .fadeOut(delay: 1100.ms),
                Animate(
                  child: Positioned(
                    left: 11.w,
                    bottom: 10.h,
                    child: Transform.rotate(
                      angle: 0 * math.pi / 180,
                      child: Container(
                        width: 1.w,
                        height: 4.h,
                        color: primaryBlue,
                      ),
                    ),
                  ),
                )
                    .slide(
                        begin: const Offset(0, 0),
                        end: const Offset(0, -2),
                        curve: Curves.ease,
                        delay: 1000.ms,
                        duration: 1000.ms)
                    .fadeIn(delay: 1000.ms)
                    .fadeOut(delay: 1100.ms),
                Animate(
                  child: Positioned(
                    left: 23.w,
                    child: Transform.rotate(
                      angle: 45 * math.pi / 180,
                      child: Container(
                        width: 1.w,
                        height: 4.h,
                        color: primaryBlue,
                      ),
                    ),
                  ),
                )
                    .slide(
                        begin: const Offset(0, 0),
                        end: const Offset(15, -2),
                        curve: Curves.ease,
                        delay: 1000.ms,
                        duration: 1000.ms)
                    .fadeIn(delay: 1000.ms)
                    .fadeOut(delay: 1100.ms),
                Image.asset(
                  'assets/images/logo.png',
                  width: 45.w,
                ),
              ],
            ),
          ],
        ),
      )
          .slideY(begin: -0.07, end: 0, curve: Curves.ease, duration: 900.ms)
          .fadeIn(duration: 900.ms),
    );
  }
}
