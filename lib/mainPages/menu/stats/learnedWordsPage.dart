import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funlish_app/model/learnedWord.dart';
import 'package:funlish_app/utility/databaseHandler.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:sizer/sizer.dart';

class Learnedwordspage extends StatefulWidget {
  final String type;
  final List<Learnedword> words;
  const Learnedwordspage({super.key, required this.type, required this.words});

  @override
  State<Learnedwordspage> createState() => _LearnedwordspageState();
}

class _LearnedwordspageState extends State<Learnedwordspage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyColor,
      body: SizedBox(
          width: 100.w,
          height: 100.h,
          child: SingleChildScrollView(
              child: Stack(alignment: Alignment.center, children: [
            Positioned(
              left: 4.w,
              top: 2.5.h,
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
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                height: 11.h,
              ),
              SizedBox(
                width: 90.w,
                child: Row(
                  children: [
                    setText("Words learned by ${widget.type}", FontWeight.w600,
                        16.sp, fontColor),
                  ],
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Column(children: [
                for (var word in widget.words)
                  Container(
                    width: 90.w,
                    constraints: BoxConstraints(minHeight: 12.h),
                    margin: EdgeInsets.only(bottom: 2.h),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        setText(word.word, FontWeight.w600, 15.sp, fontColor),
                        SizedBox(height: 1.h),
                        setText(word.description, FontWeight.w500, 14.sp,
                            fontColor.withOpacity(0.6))
                      ],
                    ),
                  ),
              ])
            ])
          ]))),
    );
  }
}
