import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:funlish_app/mainPages/chapters/levelsMenu.dart';
import 'package:funlish_app/model/Chapter.dart';
import 'package:funlish_app/utility/databaseHandler.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';

class Chaptermenucontainer extends StatefulWidget {
  final String image;
  final Chapter chapter;
  final bool isLocked;
  const Chaptermenucontainer(
      {required this.chapter,
      required this.image,
      super.key,
      required this.isLocked});

  @override
  State<Chaptermenucontainer> createState() => _ChaptermenucontainerState();
}

class _ChaptermenucontainerState extends State<Chaptermenucontainer> {
  double progress = 0;
  void getProgress() async {
    List<String> words = await getWordsByChapterId(widget.chapter.id);

    setState(() {
      progress = chapters[widget.chapter.id - 1].levelsPassed / words.length;
    });
  }

  void updateChpaters(List<Chapter> newChapters) {
    setState(() {
      chapters = newChapters;
    });
    getProgress();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      constraints: BoxConstraints(minHeight: 23.h),
      margin: EdgeInsets.only(bottom: 3.h),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: widget.chapter.colorAsColor.withOpacity(0.2)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          TextButton(
            style: OutlinedButton.styleFrom(
                padding: EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)))),
            onPressed: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (BuildContext context) => LevelsMenu(
                      chapter: widget.chapter,
                      update: updateChpaters,
                    ),
                  ));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  widget.image,
                  width: 30.w,
                ),
                SizedBox(
                    width: 50.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SizedBox(
                        //   height: 1.h,
                        // ),
                        setText(widget.chapter.name, FontWeight.bold, 17.sp,
                            widget.chapter.colorAsColor, true),
                        SizedBox(
                          height: 2.h,
                        ),
                        CircularPercentIndicator(
                          radius: 11.w,
                          backgroundColor: fontColor.withOpacity(0.2),
                          animation: true,
                          curve: Curves.easeOut,
                          animationDuration: 800,
                          progressColor: widget.chapter.colorAsColor,
                          percent: progress,
                          center: setText(
                              "${(progress * 100).ceil()}%",
                              FontWeight.bold,
                              13.sp,
                              fontColor.withOpacity(0.8),
                              true),
                        ),
                      ],
                    ))
              ],
            ),
          ),
          if (widget.isLocked)
            Container(
              width: 90.w,
              height: 23.h,
              color: Colors.black.withOpacity(0.4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 1.h,
                children: [
                  Icon(
                    FontAwesomeIcons.lock,
                    color: const Color.fromARGB(255, 225, 225, 225),
                    size: 12.w,
                  ),
                  setText("Unlock Chapter from the store", FontWeight.w600,
                      15.sp, Colors.white, true)
                ],
              ),
            ),
        ],
      ),
    );
  }
}
