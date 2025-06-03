import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:funlish_app/components/textBar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:funlish_app/utility/global.dart';
import 'package:uuid/uuid.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    animationController.forward();
    Timer(Duration(seconds: 1), () {
      messages[Uuid().v4()] = TextButton(
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
          ),
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          onLongPress: () {
            // messageOptions(id, message.message);
          },
          child: messageBubble(
            "Hello English learner, how can i help you today 😊",
            "${DateTime.now().hour}:${DateTime.now().minute}".toString(),
            false,
          ));
      setState(() {});
    });
  }

  Map<String, Widget> messages = {};

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: bodyColor,
        body: SizedBox(
            width: 100.w,
            height: 100.h,
            child: Stack(alignment: Alignment.center, children: [
              Positioned(
                left: 4.w,
                top: 3.h,
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
              Column(children: [
                SizedBox(
                  height: 4.5.h,
                ),
                setText("Chatbot", FontWeight.w600, 17.sp, fontColor),
                SizedBox(
                  height: 3.h,
                ),
                SizedBox(
                    // height: 88.h,

                    child: Animate(
                        child: Column(children: [
                  SizedBox(
                    height: 80.66.h,
                    width: 100.w,
                    child: SizedBox(
                      width: 100.w,
                      child: ListView(
                        children: messages.values.toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100.w,
                    child: Textbar(
                      enterMethod: sendMsg,
                    ),
                  ),
                ])))
              ]),
              if (isLoading)
                Animate(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.fallingDot(
                          color: primaryPurple, size: 16.w),
                      SizedBox(height: 1.h),
                      setText("Getting response...", FontWeight.w600, 15.sp,
                          fontColor),
                    ],
                  ),
                ).fadeIn(duration: 400.ms)
            ])),
      ),
    );
  }

  Widget messageBubble(String msg, String date, bool isSender,
      [String? sender]) {
    Color color = isSender ? bodyColor : Colors.black;
    Color bgColor = isSender ? Colors.white : primaryPurple.withOpacity(0.1);
    return Animate(
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        width: 100.w,
        child: Row(
          mainAxisAlignment:
              isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: !isSender ? bgColor : bgColor,
                        // : orangeColor,
                        borderRadius: BorderRadius.circular(16)),
                    padding: EdgeInsets.only(
                        top: isSender ? 12 : 20,
                        left: 12,
                        right: 12,
                        bottom: 25),
                    margin: EdgeInsets.only(left: 2.w, right: 2.w),
                    constraints: BoxConstraints(maxWidth: 70.w, minWidth: 20.w),
                    child: setText(msg, FontWeight.w500, 15.sp, fontColor)),
                if (!isSender)
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18)),
                        margin:
                            const EdgeInsets.only(right: 15, left: 17, top: 3),
                        child: setText(
                            sender ?? "", FontWeight.w500, 13.sp, fontColor)),
                  ),
                Positioned(
                  right: isSender ? 0 : null,
                  left: isSender ? null : 0,
                  bottom: 0,
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      margin:
                          EdgeInsets.only(bottom: 0.5.h, right: 15, left: 17),
                      child: setText(date, FontWeight.w500, 13.sp,
                          fontColor.withOpacity(0.5))),
                ),
              ],
            ),
          ],
        ),
      ),
    ).fadeIn().slide(
          curve: Curves.easeInOut,
        );
  }

  void sendMsg(String text) {
    messages[Uuid().v4()] = TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
        ),
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onLongPress: () {
          // messageOptions(id, message.message);
        },
        child: messageBubble(
            text, "${DateTime.now().hour}:${DateTime.now().minute}", true));
    setState(() {});
    receiveMsg(text);
  }

  void receiveMsg(String text) async {
    setState(() {
      isLoading = true;
    });
    try {
      // final token = preferences.getString("userToken");

      final url = Uri.parse(
        '${dotenv.env['API_URL']}/flows/trigger/f04999b8-835c-49cb-98a8-56704d734258',
      );

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          // if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'user_message': text}),
      );

      final decoded = jsonDecode(response.body);

      final content = decoded['data']['choices'][0]['message']['content'];
      messages[Uuid().v4()] = TextButton(
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
          ),
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          onLongPress: () {
            // messageOptions(id, message.message);
          },
          child: messageBubble(
            content,
            "${DateTime.now().hour}:${DateTime.now().minute}",
            false,
          ));
      setState(() {});
    } catch (e) {
      print("⚠️ Could not extract message content: $e");
      messages[Uuid().v4()] = TextButton(
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
          ),
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          onLongPress: () {
            // messageOptions(id, message.message);
          },
          child: messageBubble(
            "Error sending message",
            "${DateTime.now().hour}:${DateTime.now().minute}",
            false,
          ));
    }
    setState(() {
      isLoading = false;
    });
  }
}
