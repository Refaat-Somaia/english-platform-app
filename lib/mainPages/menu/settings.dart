import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:sizer/sizer.dart';

class Settings extends StatefulWidget {
  final Function update;

  const Settings({super.key, required this.update});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  List<double> slides = [];
  final double offsetX = 1.55;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < 7; i++) {
      slides.add(0.3);
    }
    slides[0] = preferences.getBool("isDarkMode") == true ? offsetX : 0.3;
    slides[3] = offsetX;
    slides[4] = preferences.getBool("isInGameSounds") == true ? offsetX : 0.3;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bodyColor,
        body: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: 100.w,
            height: 100.h,
            color: bodyColor,
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
                setText("Settings", FontWeight.w600, 17.sp, fontColor),
                SizedBox(
                  height: 3.h,
                ),
                Animate(
                    child: SizedBox(
                        height: 88.h,
                        child: SingleChildScrollView(
                            child: Column(children: [
                          SizedBox(
                            height: 2.h,
                          ),
                          optionContainer(0, "Dark mode", FontAwesomeIcons.moon,
                              () {
                            if (preferences.getBool("isDarkMode") == null) {
                              preferences.setBool("isDarkMode", true);
                              bodyColor = Color.fromARGB(255, 23, 16, 39);
                              fontColor = Color(0xffF9F7FF);
                              setState(() {});
                              return;
                            }
                            preferences.setBool("isDarkMode",
                                !preferences.getBool("isDarkMode")!);
                            bodyColor == Color.fromARGB(255, 23, 16, 39)
                                ? {
                                    bodyColor = const Color(0xffF9F7FF),
                                    fontColor = const Color(0xff32356D)
                                  }
                                : {
                                    bodyColor = Color.fromARGB(255, 23, 16, 39),
                                    fontColor = Color(0xffF9F7FF)
                                  };
                            widget.update();
                            setState(() {});
                          }),
                          optionContainer(1, "Auto download new content",
                              FontAwesomeIcons.download, () {}),
                          optionContainer(2, "Get daily notifications",
                              FontAwesomeIcons.bell, () {}),
                          optionContainer(3, "Show my name in the leaderboard",
                              Icons.leaderboard_rounded, () {}),
                          optionContainer(4, "Play in game sounds",
                              Icons.volume_mute_rounded, () {
                            preferences.setBool("isInGameSounds",
                                !preferences.getBool("isInGameSounds")!);
                          }),
                        ]))))
              ])
            ])));
  }

  Widget optionContainer(int index, String text, IconData icon, Function func) {
    return Container(
      width: 92.w,
      constraints: BoxConstraints(minHeight: 7.h),
      margin: EdgeInsets.only(bottom: 2.5.h),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            icon,
            size: 7.w,
            color: fontColor,
          ),
          SizedBox(
            width: 2.w,
          ),
          SizedBox(
            width: 55.w,
            child: setText(text, FontWeight.w600, 15.sp, fontColor),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                slides[index] = (slides[index] == .3 ? offsetX : .3);
              });
              func();
            },
            child: Stack(
              children: [
                Container(
                  width: 70,
                  height: 34,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: slides[index] == .3
                          ? const Color.fromARGB(255, 213, 213, 213)
                          : const Color.fromARGB(255, 240, 240, 240)),
                ),
                AnimatedSlide(
                  offset: Offset(slides[index], .17),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: primaryPurple),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
