import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funlish_app/components/commentContainer.dart';
import 'package:funlish_app/components/commentReplyContainer.dart';
import 'package:funlish_app/components/textBar.dart';
import 'package:funlish_app/model/comment.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

class Viewcomment extends StatefulWidget {
  final Comment comment;
  final bool isLiked;

  const Viewcomment({super.key, required this.isLiked, required this.comment});

  @override
  State<Viewcomment> createState() => _ViewcommentState();
}

class _ViewcommentState extends State<Viewcomment> {
  List<Widget> replies = [];

  void addReplay(String text) {
    setState(() {
      replies.add(CommentReplycontainer(
          isLiked: false,
          comment: Comment(
              text: text,
              id: Uuid().v4(),
              threadId: widget.comment.id,
              userName: preferences.getString("userName")!,
              commentCount: 0,
              likeCount: 0,
              date: DateTime.now(),
              isReported: false)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bodyColor,
        body: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: SizedBox(
                width: 100.w,
                height: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 75.h,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Commentcontainer(
                              comment: widget.comment,
                              isViewing: true,
                              isLiked: widget.isLiked,
                              update: () {},
                            ),
                            for (Widget replay in replies) replay,
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 5.w,
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
                    ),
                    Textbar(enterMethod: addReplay),
                  ],
                ))));
  }
}
