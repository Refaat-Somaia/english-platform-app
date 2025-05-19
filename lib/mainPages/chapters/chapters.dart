import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:funlish_app/components/chapterIntro.dart';
import 'package:funlish_app/components/chapterMenuContainer.dart';
import 'package:funlish_app/mainPages/chapters/levelsMenu.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';

class Chapters extends StatefulWidget {
  const Chapters({super.key});

  @override
  State<Chapters> createState() => _ChaptersState();
}

class _ChaptersState extends State<Chapters> {
  // final List<String> chap = [];

  late final List<List<String>> images;
  late final List<String> blobs;
  int chapterIndex = 0;
  bool isMenuView = false;
  ValueNotifier<int> activeIndex = ValueNotifier<int>(0);
  ScrollController scrollController = ScrollController();
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    images = chapters.map((theme) {
      return List.generate(
        4,
        (index) =>
            'assets/images/${theme.name.toLowerCase()}/${theme.name.toLowerCase()}${index + 1}.png',
      ).where((path) => AssetImage(path) != null).toList();
    }).toList();

    blobs = chapters
        .map((theme) => 'assets/images/${theme.name.toLowerCase()}/blob.png')
        .toList();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bodyColor,
        body: !isMenuView
            ? AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                color: chapters[chapterIndex].colorAsColor.withOpacity(0.06),
                height: double.infinity,
                width: 100.w,
                child: Stack(
                  children: [
                    SizedBox(
                      height: 10.h,
                      width: 100.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ValueListenableBuilder<int>(
                            valueListenable: activeIndex,
                            builder: (context, value, child) {
                              return Row(
                                children: List.generate(
                                  chapters.length,
                                  (index) => Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 1.w),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeOut,
                                      width: 2.5.w,
                                      height: 2.5.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: value == index
                                            ? fontColor.withOpacity(0.8)
                                            : fontColor.withOpacity(0.2),
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
                    PageView.builder(
                        controller: _pageController,
                        itemCount: chapters.length,
                        itemBuilder: (context, index) {
                          return Chapterintro(
                            chapter: chapters[index],
                            imagesList: images[index],
                            blobPath: blobs[index],
                          );
                        },
                        onPageChanged: (value) {
                          setState(() {
                            chapterIndex = value;
                            activeIndex.value = value;
                          });
                        }),
                    Positioned(
                      bottom: 4.h,
                      left: 5.w,
                      child: SizedBox(
                        width: 90.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildNavigationButton(
                              isEnabled: chapterIndex > 0,
                              icon: Icons.arrow_back_ios_rounded,
                              onPressed: () {
                                if (chapterIndex > 0) {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.ease,
                                  );
                                }
                              },
                            ),
                            _buildNavigationButton(
                              isEnabled: chapterIndex < chapters.length - 1,
                              icon: Icons.arrow_forward_ios_rounded,
                              onPressed: () {
                                if (chapterIndex < chapters.length - 1) {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.ease,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 4.w,
                      top: 2.5.h,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 250),
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: chapters[activeIndex.value].colorAsColor),
                        child: IconButton(
                            style:
                                IconButton.styleFrom(padding: EdgeInsets.zero),
                            onPressed: () {
                              setState(() {
                                isMenuView = !isMenuView;
                              });
                            },
                            icon: Icon(
                              Icons.menu_rounded,
                              size: 7.w,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ],
                ),
              )
            : Animate(
                child: Container(
                    color: bodyColor,
                    height: 100.h,
                    width: 100.w,
                    child: Stack(children: [
                      SingleChildScrollView(
                        child: SizedBox(
                          width: 100.w,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 3.h,
                              ),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 250),
                                width: 60.w,
                                height: 14.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                        color: fontColor.withOpacity(0.2))),
                                child: IconButton(
                                    style: buttonStyle(16),
                                    onPressed: () {
                                      setState(() {
                                        isMenuView = !isMenuView;
                                      });
                                      Timer(Duration(milliseconds: 100), () {
                                        _pageController.animateToPage(
                                            activeIndex.value,
                                            duration: 500.ms,
                                            curve: Curves.easeInOut);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.view_carousel_sharp,
                                      size: 8.w,
                                      color: fontColor,
                                    )),
                              ),
                              SizedBox(
                                height: 3.h,
                              ),
                              for (int i = 0; i < chapters.length; i++)
                                Chaptermenucontainer(
                                    chapter: chapters[i], image: images[i][0])
                            ],
                          ),
                        ),
                      ),
                    ])),
              )
                .slideY(
                    begin: 0.08,
                    end: 0,
                    curve: Curves.ease,
                    duration: 400.ms,
                    delay: 100.ms)
                .fadeIn());
  }

  Widget _buildNavigationButton({
    required bool isEnabled,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      onPressed: isEnabled ? onPressed : null,
      icon: Icon(
        icon,
        size: 8.w,
        color: isEnabled
            ? chapters[chapterIndex].colorAsColor
            : Colors.transparent,
      ),
    );
  }
}
