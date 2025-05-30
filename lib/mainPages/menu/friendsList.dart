import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:funlish_app/components/avatar.dart';
import 'package:funlish_app/components/modals/alertModal.dart';
import 'package:funlish_app/model/userModel.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

class Friendslist extends StatefulWidget {
  const Friendslist({super.key});

  @override
  State<Friendslist> createState() => _FriendslistState();
}

class _FriendslistState extends State<Friendslist>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();
  late AnimationController animationController;

  List<UserProfile> users = [];

  void fetchUsers() async {
    var url = Uri.parse('${dotenv.env['API_URL']}/items/student/');

    try {
      final headers = {
        'Content-Type': 'application/json',
      };
      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 10));
      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); // Decode the string response
        users = (data['data'] as List)
            .map((item) => UserProfile.fromJson(item))
            .toList();

        animationController.reverse();
        Timer(const Duration(milliseconds: 300), () {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        });
      }
    } catch (e) {
      Navigator.pop(context);
      showAlertModal(context, "A network Error had occurred");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    animationController.forward();
    fetchUsers();
  }

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
                  setText("Friends list", FontWeight.w600, 17.sp, fontColor),
                  SizedBox(
                    height: 3.h,
                  ),
                  SizedBox(
                      height: 88.h,
                      child: isLoading
                          ? Animate(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  LoadingAnimationWidget.fallingDot(
                                      color: primaryPurple, size: 18.w),
                                  SizedBox(height: 1.h),
                                  setText("Please wait...", FontWeight.w600,
                                      16.sp, fontColor),
                                ],
                              ),
                            )
                              .animate(
                                  controller: animationController,
                                  autoPlay: false)
                              .fadeIn(duration: 400.ms)
                          : Animate(
                              child: Column(
                              children: [
                                Container(
                                    width: 90.w,
                                    height: 6.5.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: fontColor.withOpacity(0.1),
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: TextFormField(
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontFamily: "magnet",
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600,
                                            color: fontColor),
                                        decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.zero,
                                            counterText: "",
                                            hintStyle: TextStyle(
                                              fontFamily: "magnet",
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w500,
                                              color: fontColor.withOpacity(0.3),
                                            ),
                                            hintText: "Search...",
                                            border: InputBorder.none,
                                            prefixIcon: Icon(
                                              Icons.search_rounded,
                                              size: 7.w,
                                              // color: fontColor,
                                            )),
                                        maxLength: 70,
                                        controller: searchController,
                                      ),
                                    )),
                                SizedBox(height: 2.5.h),
                                SizedBox(
                                  width: 92.w,
                                  child: setText("My Friends", FontWeight.w600,
                                      16.sp, fontColor),
                                ),
                                SizedBox(height: 2.5.h),
                                Expanded(
                                  child: ListView.builder(
                                      padding: EdgeInsets.only(
                                          bottom: 4.h, top: 2.h),
                                      itemCount: users.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 4.w),
                                            child: friendContiner(
                                                "users[index]",
                                                users[index].leaderboardScore ??
                                                    0,
                                                users[index].characterIndex ??
                                                    0,
                                                users[index].hatIndex ?? 0));
                                      }),
                                ),
                              ],
                            )).fadeIn(
                              duration: 400.ms,
                            ))
                ])
              ]))),
    );
  }

  Widget friendContiner(
      String name, int level, int characterIndex, int hatIndex) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.5.h),
      width: 90.w,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: primaryPurple.withOpacity(0.1)),
      child: Row(
        children: [
          Avatar(
              characterIndex: characterIndex, hatIndex: hatIndex, width: 15.w),
          SizedBox(width: 3.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              setText(name, FontWeight.w500, 15.5.sp, fontColor),
              setText("Level $level", FontWeight.w500, 14.sp,
                  fontColor.withOpacity(0.6)),
            ],
          )
        ],
      ),
    );
  }
}
