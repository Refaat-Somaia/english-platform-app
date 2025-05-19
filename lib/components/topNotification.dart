import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funlish_app/model/powerUp.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:sizer/sizer.dart';

class Topnotification extends StatefulWidget {
  final PowerUp powerUp;
  final String sender;
  const Topnotification(
      {super.key, required this.powerUp, required this.sender});

  @override
  State<Topnotification> createState() => _TopnotificationState();
}

class _TopnotificationState extends State<Topnotification> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92.w,
      height: 13.h,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: preferences.getBool("isDarkMode") == true
              ? Color.fromARGB(255, 53, 39, 87)
              : Colors.white,
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Image.asset(
            widget.powerUp.iconPath == ""
                ? "assets/images/bomb.png"
                : widget.powerUp.iconPath,
            width: 30.w,
          ),
          SizedBox(
            width: 50.w,
            child: setText(
                preferences.getString("userName") != widget.sender
                    ? "${widget.sender} has acivated ${widget.powerUp.name}!"
                    : "You have acivated ${widget.powerUp.name}!",
                FontWeight.w600,
                14.5.sp,
                fontColor,
                true),
          )
        ],
      ),
    );
  }
}
