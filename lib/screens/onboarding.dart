import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:funlish_app/onboarding/page1.dart';
import 'package:funlish_app/onboarding/page2.dart';
import 'package:funlish_app/onboarding/page3.dart';
import 'package:funlish_app/onboarding/page4.dart';
import 'package:funlish_app/screens/login.dart';
import 'package:sizer/sizer.dart';

import '../signUp/signUp.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController pageController = PageController();
  ValueNotifier<int> activeIndex = ValueNotifier<int>(0);

  final List<Widget> pages = const [Page1(), Page2(), Page3(), Page4()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyColor,
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 75.h,
              child: PageView.builder(
                controller: pageController,
                itemCount: 4,
                itemBuilder: (context, index) => pages[index],
                onPageChanged: (value) => activeIndex.value = value,
              ),
            ),
            SizedBox(
              height: 20.h,
              width: 92.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Signup()),
                    ),
                    child: setText("Skip", FontWeight.w500, 15.sp,
                        fontColor.withOpacity(0.5)),
                  ),
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
                              width: value == index ? 6.w : 2.5.w,
                              height: 2.5.w,
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
                  ValueListenableBuilder<int>(
                    valueListenable: activeIndex,
                    builder: (context, value, child) {
                      return Container(
                        // duration: const Duration(milliseconds: 400),
                        width: 14.w,
                        height: 14.w,
                        decoration: BoxDecoration(
                          color: primaryPurple,
                          borderRadius: BorderRadius.circular(20),
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
                            if (value < pages.length - 1) {
                              pageController.nextPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                              activeIndex.value++;
                            } else {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => const Signup()),
                              );
                            }
                          },
                          icon: Icon(
                            Icons.arrow_forward_rounded,
                            color: bodyColor,
                            size: 7.w,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    activeIndex.dispose();
    super.dispose();
  }
}
