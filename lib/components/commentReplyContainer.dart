import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:funlish_app/mainPages/threads/viewComment.dart';
import 'package:funlish_app/model/comment.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:sizer/sizer.dart';

class CommentReplycontainer extends StatefulWidget {
  Comment comment;
  bool isLiked;

  CommentReplycontainer(
      {super.key, required this.isLiked, required this.comment});

  @override
  State<CommentReplycontainer> createState() => _CommentReplycontainerState();
}

class _CommentReplycontainerState extends State<CommentReplycontainer> {
  bool isLiked = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLiked = widget.isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Animate(
      child: Container(
        width: 80.w,
        margin: EdgeInsets.only(bottom: 3.h),
        constraints: BoxConstraints(minHeight: 16.h),
        decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              width: 74.w,
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
                      setText(widget.comment.userName, FontWeight.w600, 14.sp,
                          fontColor.withOpacity(0.8)),
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
            SizedBox(
              width: 74.w,
              height: 5.h,
              child: Text(
                widget.comment.text,
                style: TextStyle(
                    fontFamily: 'magnet',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: fontColor.withOpacity(0.8)),
                softWrap: true,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: 74.w,
              child: Row(
                children: [
                  SizedBox(
                    child: IconButton(
                      onPressed: () {
                        if (isLiked) {
                          setState(() {
                            isLiked = false;
                            widget.comment.likeCount--;
                            widget.isLiked = false;
                          });
                        } else {
                          setState(() {
                            isLiked = true;
                            widget.comment.likeCount++;
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
                                color:
                                    primaryBlue.withOpacity(isLiked ? 1 : 0.6),
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
                ],
              ),
            )
          ],
        ),
      ),
    ).fadeIn(duration: 400.ms);
  }
}
