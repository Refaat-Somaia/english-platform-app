import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:funlish_app/components/modals/alertModal.dart';
import 'package:funlish_app/signUp/gender.dart';
import 'package:funlish_app/signUp/interests.dart';
import 'package:funlish_app/signUp/quiz.dart';
import 'package:funlish_app/signUp/quizPage.dart';
import 'package:sizer/sizer.dart';

import '../utility/global.dart';

class AfterSignUp extends StatefulWidget {
  const AfterSignUp({super.key});

  @override
  State<AfterSignUp> createState() => _AfterSignUpState();
}

class _AfterSignUpState extends State<AfterSignUp> {
  ValueNotifier<int> activeIndex = ValueNotifier<int>(0);
  List<Widget> pages = [];
  PageController pageController = PageController();
  bool gender = false;
  List<String> userInterests = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      pages = [
        Gender(gender: gender),
        Interests(
          userInterests: userInterests,
          addInterest: addInterest,
        ),
        Quiz()
      ];
    });
  }

  void addInterest(String interest) {
    setState(() {
      userInterests.add(interest);
    });
    print(userInterests);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyColor,
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: Stack(
          children: [
            Positioned(
              right: 5.w,
              top: 3.5.h,
              child: setText("${activeIndex.value + 1}/3", FontWeight.w600,
                  15.sp, fontColor.withOpacity(0.8)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10.h,
                  width: 92.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ValueListenableBuilder<int>(
                        valueListenable: activeIndex,
                        builder: (context, value, child) {
                          return Row(
                            children: List.generate(
                              pages.length,
                              (index) => Padding(
                                padding: EdgeInsets.symmetric(horizontal: 1.w),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                  width: 10.w,
                                  height: 0.5.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: value == index
                                        ? primaryPurple
                                        : primaryPurple.withOpacity(0.2),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    height: 73.h,
                    child: PageView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: pageController,
                      children: pages,
                    )),
                SizedBox(
                  height: 10.h,
                  width: 90.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          if (activeIndex.value > 0) {
                            setState(() {
                              activeIndex.value--;
                            });
                            pageController.animateToPage(activeIndex.value,
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeInOut);
                          }
                        },
                        child: setText(
                            "Back",
                            FontWeight.w500,
                            15.sp,
                            fontColor.withOpacity(
                                activeIndex.value != 0 ? 0.5 : 0.1)),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        // duration: const Duration(milliseconds: 400),
                        width: 22.w,
                        height: 7.h,
                        decoration: BoxDecoration(
                          color: primaryPurple,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          style: IconButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                          ),
                          onPressed: () {
                            if (userInterests.isEmpty &&
                                activeIndex.value == 1) {
                              showAlertModal(context,
                                  "You need to select at least one interest");
                              return;
                            }
                            if (activeIndex.value < pages.length - 1) {
                              setState(() {
                                activeIndex.value++;
                              });
                              pageController.animateToPage(activeIndex.value,
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeInOut);
                            } else {
                              // Navigator.pushAndRemoveUntil(
                              //   context,
                              //   CupertinoPageRoute(
                              //     builder: (BuildContext context) =>
                              //         const Body(),
                              //   ),
                              //   (route) => false,
                              // );
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (BuildContext context) => Quizpage(
                                    userInterests: userInterests,
                                  ),
                                ),
                              );
                            }
                          },
                          icon: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              setText(
                                  "Next", FontWeight.w600, 15.sp, bodyColor),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
