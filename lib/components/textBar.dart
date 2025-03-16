import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';

import 'package:flutter/material.dart';
import 'package:funlish_app/utility/global.dart';

class Textbar extends StatefulWidget {
  Function enterMethod;
  Textbar({super.key, required this.enterMethod});

  @override
  State<Textbar> createState() => _TextbarState();
}

class _TextbarState extends State<Textbar> {
  @override
  Widget build(BuildContext context) {
    return MessageBar(
      textFieldTextStyle: TextStyle(
          fontFamily: 'magnet',
          fontWeight: FontWeight.w500,
          color: fontColor,
          fontSize: 14.sp),
      messageBarHintText: 'Type here...',
      messageBarColor: primaryPurple,
      onTextChanged: (p0) {},
      sendButtonColor: bodyColor,
      messageBarHintStyle: TextStyle(
          fontFamily: 'magnet',
          fontWeight: FontWeight.w500,
          color: fontColor.withOpacity(0.5),
          fontSize: 14.sp),
      onSend: (msg) async {
        widget.enterMethod(msg);
      },
      actions: [],
    );
  }
}
