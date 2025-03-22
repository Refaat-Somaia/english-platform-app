import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:funlish_app/mainPages/menu/stats/learnedWordsPage.dart';
import 'package:funlish_app/model/learnedWord.dart';
import 'package:funlish_app/utility/custom_icons_icons.dart';
import 'package:funlish_app/utility/databaseHandler.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:sizer/sizer.dart';

class Stats extends StatefulWidget {
  const Stats({super.key});

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  List<Learnedword> words = [];
  List<Learnedword> listenWords = [];

  List<Learnedword> diffWords = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getWords();
    });
  }

  void getWords() async {
    words = await getLearnedWordsFromDB();
    for (var word in words) {
      if (word.type == "listen") {
        listenWords.add(word);
      } else {
        diffWords.add(word);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyColor,
      body: Container(
        height: double.infinity,
        child: Column(
          // alignment: Alignment.center,
          children: [
            SizedBox(
              height: 2.5.h,
            ),
            SizedBox(
              width: 92.w,
              child: Row(
                children: [
                  Container(
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
                ],
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
            SizedBox(
              height: 90.h,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 2.h,
                    ),
                    SizedBox(
                        width: 90.w,
                        child: setText(
                            "Here is a summary of your learning journy, words you learned, how you learend them and more.",
                            FontWeight.w500,
                            14.sp,
                            fontColor.withOpacity(0.7),
                            true)),
                    SizedBox(
                      height: 3.h,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              buttonOfMenu(
                                  primaryPurple,
                                  "By meaning",
                                  FontAwesomeIcons.file,
                                  500.ms,
                                  0,
                                  diffWords.length),
                              buttonOfMenu(
                                  primaryBlue,
                                  "By listening",
                                  Icons.headphones_rounded,
                                  600.ms,
                                  1,
                                  listenWords.length),
                              buttonOfMenu(primaryPurple, "Threads",
                                  FontAwesomeIcons.podcast, 700.ms, 2),
                              SizedBox(
                                height: 3.h,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              buttonOfMenu(primaryBlue, "Daily challenges",
                                  Icons.schedule, 700.ms, 3),
                              buttonOfMenu(primaryPurple, "My level",
                                  FontAwesomeIcons.barsProgress, 900.ms, 4),

                              // SizedBox(
                              //   height: 20.h,
                              // ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonOfMenu(Color color, text, icon, duration, [index, count]) {
    return Animate(
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        width: 40.w,
        height: 25.h,
        decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(32)),
        child: TextButton(
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32))),
          ),
          onPressed: () {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (BuildContext context) => Learnedwordspage(
                            type: "meaning",
                            words: diffWords,
                          )),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (BuildContext context) => Learnedwordspage(
                            type: "listening",
                            words: listenWords,
                          )),
                );
                break;
              case 2:
                break;
              case 3:
                break;
              case 4:
                break;
              default:
                break;
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 16.w,
                    color: color,
                  ),
                  icon == CustomIcons.cloud
                      ? SizedBox(width: 6.w)
                      : const SizedBox()
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              SizedBox(
                width: 37.w,
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: setText(text, FontWeight.w600, 15.sp, fontColor)),
              ),
              setText("${count ?? "2"} words", FontWeight.w600, 13.sp,
                  fontColor.withOpacity(0.5))
            ],
          ),
        ),
      ),
    )
        .slideY(begin: 1, end: 0, curve: Curves.ease, duration: duration)
        .fadeIn(duration: 500.ms);
  }
}
