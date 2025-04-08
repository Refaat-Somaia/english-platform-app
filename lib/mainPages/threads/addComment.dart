import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:funlish_app/components/gradText.dart';
import 'package:funlish_app/model/comment.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

class Addcomment extends StatefulWidget {
  final Function update;
  final List<Comment> comments;
  final String description;
  final String word;
  const Addcomment(
      {super.key,
      required this.update,
      required this.comments,
      required this.description,
      required this.word});

  @override
  State<Addcomment> createState() => _AddcommentState();
}

class _AddcommentState extends State<Addcomment> {
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyColor,
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SingleChildScrollView(
          child: SizedBox(
            width: 100.w,
            height: 100.h,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment,
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
                            style:
                                IconButton.styleFrom(padding: EdgeInsets.zero),
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
                  height: 5.h,
                ),
                setText(widget.description, FontWeight.bold, 17.sp, fontColor),
                SizedBox(
                  height: 0.5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GradientText(
                      "'${widget.word}'",
                      style: TextStyle(
                          fontFamily: "magnet",
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold),
                      gradient:
                          LinearGradient(colors: [primaryBlue, primaryPurple]),
                    ),
                    setText(" 🤔", FontWeight.bold, 18.sp, fontColor)
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                setText("Comment strength", FontWeight.w600, 13.sp,
                    fontColor.withOpacity(0.5)),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 90.w,
                      height: 1.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: fontColor.withOpacity(0.1)),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      // width: _width,
                      height: 1.h,
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(32),
                      //     color: _width > 60.w
                      //         ? Colors.redAccent
                      //         : _width > 30.w
                      //             ? Colors.orangeAccent
                      //             : const Color.fromARGB(255, 68, 186, 129)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 4.h,
                ),
                Container(
                  width: 90.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: preferences.getBool("isDarkMode") == true
                        ? Color.fromARGB(255, 54, 35, 97)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: preferences.getBool("isDarkMode") == true
                            ? Color.fromARGB(255, 0, 0, 0)
                            : const Color.fromARGB(255, 241, 241, 241),
                        spreadRadius: 0.01.h,
                        blurRadius: 8,
                        offset: const Offset(0, 7),
                      )
                    ],
                  ),
                  child: TextFormField(
                    controller: commentController,
                    style: TextStyle(
                      fontFamily: "magnet",
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: fontColor,
                    ),
                    decoration: InputDecoration(
                      counterStyle: TextStyle(fontSize: 0),
                      hintStyle: TextStyle(
                        fontFamily: "magnet",
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: fontColor.withOpacity(0.3),
                      ),
                      hintText: "Type here...",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
                    ),
                    maxLines: null,
                    // keyboardType: TextInputType.multiline,
                    maxLength: 400,
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                SizedBox(
                  width: 90.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 15.w,
                            height: 15.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                // border: Border.all(
                                //     width: 1.5, color: fontColor.withOpacity(0.2))
                                color: primaryPurple.withOpacity(0.2)),
                            child: IconButton(
                                style: IconButton.styleFrom(
                                    padding: EdgeInsets.zero),
                                onPressed: () {
                                  // showPasswordModal();
                                },
                                icon: Icon(
                                  FontAwesomeIcons.robot,
                                  size: 6.w,
                                  color: primaryPurple,
                                )),
                          ),
                          SizedBox(height: 0.8.h),
                          setText("Check text", FontWeight.w500, 13.5.sp,
                              fontColor.withOpacity(0.6))
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 19.h),
                Container(
                  width: 90.w,
                  height: 7.h,
                  decoration: BoxDecoration(
                      color: primaryPurple,
                      borderRadius: BorderRadius.circular(16)),
                  child: TextButton(
                    onPressed: () {
                      if (commentController.text.isEmpty) return;
                      setState(() {
                        widget.comments.add(Comment(
                            text: commentController.text,
                            id: Uuid().v4(),
                            threadId: "",
                            userName: preferences.getString("userName")!,
                            commentCount: 0,
                            likeCount: 0,
                            date: DateTime.now(),
                            isReported: false));
                      });

                      widget.update(widget.comments);
                      Navigator.pop(context);
                    },
                    child:
                        setText("Post", FontWeight.w600, 15.sp, Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
