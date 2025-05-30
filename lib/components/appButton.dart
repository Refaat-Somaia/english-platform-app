import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:sizer/sizer.dart';

class AppButton extends StatefulWidget {
  final Function function;
  final double width;
  final Color color;
  final double height;
  final String text;
  IconData? icon;

  AppButton(
      {super.key,
      required this.function,
      required this.height,
      required this.width,
      required this.color,
      this.icon,
      required this.text});

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: widget.color),
      width: widget.width,
      height: widget.height,
      child: TextButton(
        onPressed: () {
          widget.function();
        },
        style: buttonStyle(12),
        child: widget.icon == null
            ? setText(widget.text, FontWeight.w600, 15.sp, Colors.white)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    size: 6.w,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  setText(widget.text, FontWeight.w600, 15.sp, Colors.white)
                ],
              ),
      ),
    );
  }
}
