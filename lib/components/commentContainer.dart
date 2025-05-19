import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:funlish_app/mainPages/threads/viewComment.dart';
import 'package:funlish_app/model/comment.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:sizer/sizer.dart';
import 'dart:math';

class Commentcontainer extends StatefulWidget {
  Comment comment;
  Function update;
  final bool isViewing;
  bool isLiked;
  Commentcontainer(
      {super.key,
      required this.isLiked,
      required this.update,
      required this.comment,
      required this.isViewing});

  @override
  State<Commentcontainer> createState() => _CommentcontainerState();
}

class _CommentcontainerState extends State<Commentcontainer> {
  bool isLiked = false;
  int colorIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLiked = widget.isLiked;
      Random random = new Random();
      colorIndex = random.nextInt(colors.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Animate(
      child: Stack(
        children: [
          Container(
            width: 92.w,
            margin: EdgeInsets.only(bottom: 3.h),
            constraints: BoxConstraints(minHeight: 17.h),
            decoration: BoxDecoration(
              color: preferences.getBool("isDarkMode") == true
                  ? primaryPurple.withOpacity(0.3)
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 2.h,
                ),
                SizedBox(
                  width: 84.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/avatar.png',
                            width: 10.w,
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          setText(widget.comment.userName, FontWeight.w600,
                              14.sp, fontColor.withOpacity(0.8)),
                        ],
                      ),
                      setText(
                          "${widget.comment.date.year}/${widget.comment.date.month}/${widget.comment.date.day}",
                          FontWeight.w500,
                          12.sp,
                          fontColor.withOpacity(0.6))
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Container(
                  width: 84.w,
                  child: Text(
                    widget.comment.text,
                    style: TextStyle(
                        fontFamily: 'magnet',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: fontColor.withOpacity(0.8)),
                    softWrap: true,
                    maxLines: widget.isViewing ? 25 : 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 3.h),
                SizedBox(
                  width: 84.w,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 4.w,
                      ),
                      SizedBox(
                        child: IconButton(
                          onPressed: () {
                            if (isLiked) {
                              setState(() {
                                isLiked = false;
                                widget.comment.likeCount--;
                                widget.update;
                                widget.isLiked = false;
                              });
                            } else {
                              setState(() {
                                isLiked = true;
                                widget.comment.likeCount++;
                                widget.update;
                                widget.isLiked = true;
                              });
                            }
                          },
                          icon: Column(
                            children: [
                              AnimatedSwitcher(
                                duration: Duration(milliseconds: 400),
                                child: Animate(
                                  child: Icon(
                                    Icons.thumb_up,
                                    color: primaryBlue
                                        .withOpacity(isLiked ? 1 : 0.6),
                                  ),
                                )
                                    .scaleXY(
                                      begin: 0,
                                      end: 1,
                                      curve: Curves.easeOut,
                                      duration: isLiked ? 300.ms : 0.ms,
                                    )
                                    .scaleXY(
                                        begin: 1.2,
                                        end: 1,
                                        curve: Curves.easeOut,
                                        duration: isLiked ? 300.ms : 0.ms,
                                        delay: isLiked ? 300.ms : 0.ms),
                              ),
                              setText(
                                  widget.comment.likeCount.toString(),
                                  FontWeight.w500,
                                  13.sp,
                                  fontColor.withOpacity(0.6))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      if (!widget.isViewing)
                        SizedBox(
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (BuildContext context) =>
                                        Viewcomment(
                                      comment: widget.comment,
                                      isLiked: isLiked,
                                    ),
                                  ));
                            },
                            icon: Column(
                              children: [
                                Icon(
                                  Icons.comment,
                                  color: primaryBlue.withOpacity(0.6),
                                ),
                                setText(
                                    widget.comment.commentCount.toString(),
                                    FontWeight.w500,
                                    13.sp,
                                    fontColor.withOpacity(0.6))
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 1.9.h,
            child: Container(
              width: 1.w,
              height: 5.h,
              decoration: BoxDecoration(
                  color: colors[colorIndex],
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    ).fadeIn(duration: 400.ms);
  }
}
