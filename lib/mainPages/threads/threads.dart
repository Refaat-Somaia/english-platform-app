import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funlish_app/components/commentContainer.dart';
import 'package:funlish_app/components/gradText.dart';
import 'package:funlish_app/mainPages/threads/addComment.dart';
import 'package:funlish_app/model/comment.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:sizer/sizer.dart';

class Threads extends StatefulWidget {
  const Threads({super.key});

  @override
  State<Threads> createState() => _ThreadsState();
}

class _ThreadsState extends State<Threads> {
  List<Comment> comments = [];
  void updateComments(List<Comment> updatedComments) {
    setState(() {
      comments = updatedComments;
    });
  }

  String description = "How would you describe";
  String word = "Propaganda";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bodyColor,
        body: PageView(children: [
          SizedBox(
            width: 100.w,
            height: 94.h,
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      width: 100.w,
                      height: 22.h,
                      decoration: BoxDecoration(
                        color: Color(0xffF2EDFF),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 237, 237, 237),
                            spreadRadius: 0.01.h,
                            blurRadius: 8,
                            offset: const Offset(0, 7),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 4.h,
                          ),
                          setText("Thread of the week", FontWeight.w600,
                              13.5.sp, fontColor.withOpacity(0.5)),
                          SizedBox(
                            height: 2.h,
                          ),
                          setText(
                              description, FontWeight.bold, 17.sp, fontColor),
                          SizedBox(
                            height: 0.5.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GradientText(
                                "'$word'",
                                style: TextStyle(
                                    fontFamily: "magnet",
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold),
                                gradient: LinearGradient(
                                    colors: [primaryBlue, primaryPurple]),
                              ),
                              setText(" 🤔", FontWeight.bold, 18.sp, fontColor)
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    SizedBox(
                      height: 58.h,
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        children: [
                          for (Comment comment in comments)
                            Commentcontainer(
                              comment: comment,
                              isLiked: false,
                              update: updateComments,
                              isViewing: false,
                            )
                        ],
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      width: 85.w,
                      height: 7.h,
                      decoration: BoxDecoration(
                          color: primaryPurple,
                          borderRadius: BorderRadius.circular(16)),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (BuildContext context) => Addcomment(
                                  update: updateComments,
                                  comments: comments,
                                  description: description,
                                  word: word,
                                ),
                              ));
                        },
                        child: setText("Comment your thoughts", FontWeight.w600,
                            15.sp, Colors.white),
                      ),
                    )
                  ],
                ),
                Positioned(
                    right: 2.w,
                    top: 2.h,
                    child: Image.asset(
                      'assets/images/line.png',
                      width: 13.w,
                    )),
              ],
            ),
          ),
          Container(
            width: 100.w,
            height: 94.h,
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      width: 100.w,
                      height: 18.h,
                      decoration: BoxDecoration(
                        color: primaryBlue.withOpacity(0.05),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 4.h,
                          ),
                          setText(
                              "Talk about whatever comes to your mind",
                              FontWeight.w600,
                              13.5.sp,
                              fontColor.withOpacity(0.5)),
                          SizedBox(
                            height: 2.h,
                          ),
                          setText("Open threads", FontWeight.bold, 17.sp,
                              fontColor),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    SizedBox(
                      height: 58.h,
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        children: [],
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      width: 85.w,
                      height: 7.h,
                      decoration: BoxDecoration(
                          color: primaryPurple,
                          borderRadius: BorderRadius.circular(16)),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (BuildContext context) => Addcomment(
                                  update: updateComments,
                                  comments: comments,
                                  description: description,
                                  word: word,
                                ),
                              ));
                        },
                        child: setText("Comment your thoughts", FontWeight.w600,
                            15.sp, Colors.white),
                      ),
                    )
                  ],
                ),
                Positioned(
                    right: 2.w,
                    top: 2.h,
                    child: Image.asset(
                      'assets/images/line.png',
                      width: 13.w,
                    )),
              ],
            ),
          ),
        ]));
  }
}
