import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:funlish_app/mainPages/chapters/levelsMenu.dart';
import 'package:funlish_app/model/Chapter.dart';
import 'package:funlish_app/utility/databaseHandler.dart';
import 'package:funlish_app/utility/global.dart';

import 'package:sizer/sizer.dart';

class Chapterintro extends StatefulWidget {
  final List<String> imagesList;
  final Chapter chapter;
  final String blobPath;

  const Chapterintro(
      {super.key,
      required this.imagesList,
      required this.chapter,
      required this.blobPath});

  @override
  State<Chapterintro> createState() => _ChapterintroState();
}

class _ChapterintroState extends State<Chapterintro>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _hoverAnimation;
  double _width = 0;
  late AnimationController _scaleController;
  int _currentImageIndex = 0;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    getPrgress();

    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _hoverAnimation = Tween<double>(begin: -15.0, end: 10.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) {
        timer.cancel(); // Cancel the timer if the widget is disposed
        return;
      }
      setState(() {
        _scaleController.reset(); // Reset the scale animation
        _currentImageIndex =
            (_currentImageIndex + 1) % widget.imagesList.length;
        _scaleController.forward(); // Start the scale animation
      });
    });

    // Start initial animation
    _scaleController.forward();
  }

  void getPrgress() async {
    List<String> words = await getWordsByChapterId(widget.chapter.id);

    setState(() {
      progress = chapters[widget.chapter.id - 1].levelsPassed / words.length;
      _width = progress * 80.w;
    });
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void updateChpaters(List<Chapter> newChapters) {
    setState(() {
      chapters = newChapters;
    });
    getPrgress();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10.h,
        ),
        // setText(
        //     "Chpater", FontWeight.w600, 15.sp, fontColor.withOpacity(0.5)),
        Animate(
          child: SizedBox(
            width: 90.w,
            child: setText(
              widget.chapter.name,
              FontWeight.w800,
              21.sp,
              widget.chapter.colorAsColor,
              true,
            ),
          ),
        ).fadeIn(duration: 600.ms, begin: 0, delay: 200.ms),

        Animate(
          child: SizedBox(
            width: 90.w,
            child: setText(
              widget.chapter.description,
              FontWeight.w600,
              13.sp,
              fontColor.withOpacity(0.5),
              true,
            ),
          ),
        ).fadeIn(begin: 0, delay: 600.ms),
        SizedBox(
          height: 2.h,
        ),
        SizedBox(
          height: 35.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background Circle
              Center(
                child: Container(
                  height: 35.h,
                  child: Image.asset(widget.blobPath),
                ),
              ),
              Positioned(
                left: 13.w,
                bottom: 30.h,
                child: Container(
                  width: 4.w,
                  height: 4.w,
                  decoration: BoxDecoration(
                      // shape: BoxShape.circle,
                      ),
                  child: Transform.flip(
                    flipX: true,
                    child: Icon(
                      Icons.bubble_chart,
                      size: 12.w,
                      color: widget.chapter.colorAsColor,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 20.w,
                bottom: 26.h,
                child: Container(
                  width: 4.w,
                  height: 4.w,
                  decoration: BoxDecoration(
                    color: widget.chapter.colorAsColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              AnimatedBuilder(
                animation: _hoverAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _hoverAnimation.value),
                    child: child,
                  );
                },
                child: Animate(
                  child: Image.asset(
                    widget.imagesList[_currentImageIndex],
                    height: 22.h,
                  ),
                )
                    .animate(controller: _scaleController)
                    .scale(
                      begin: const Offset(0, 0),
                      end: const Offset(1.1, 1.1),
                      curve: Curves.easeOut,
                      duration: 500.ms,
                    )
                    .scale(
                      begin: const Offset(1.1, 1.1),
                      end: const Offset(0.9, 0.9),
                      curve: Curves.easeOut,
                      duration: 500.ms,
                    ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 3.h,
        ),
        setText("Chapter progress", FontWeight.w600, 14.sp,
            fontColor.withOpacity(0.6)),
        SizedBox(
          height: 1.h,
        ),
        Stack(
          children: [
            Container(
              width: 80.w,
              height: 1.5.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: widget.chapter.colorAsColor.withOpacity(0.3)),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOut,
              width: _width,
              height: 1.5.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: widget.chapter.colorAsColor),
            ),
          ],
        ),
        SizedBox(
          height: 1.h,
        ),
        setText("${(progress * 100).ceil()}%", FontWeight.w600, 14.sp,
            fontColor.withOpacity(0.6)),
        SizedBox(
          height: 5.h,
        ),
        Container(
          width: 40.w,
          height: 7.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: widget.chapter.colorAsColor,
            boxShadow: [
              BoxShadow(
                color: widget.chapter.colorAsColor.withOpacity(0.5),
                spreadRadius: 0.01.h,
                blurRadius: 8,
                offset: const Offset(0, 7),
              )
            ],
          ),
          child: TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (BuildContext context) => LevelsMenu(
                      chapter: widget.chapter,
                      update: updateChpaters,
                    ),
                  ));
            },
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: Center(
                child: setText(
                    widget.chapter.levelsPassed == 0 ? "Begin" : "Continue",
                    FontWeight.w600,
                    16.sp,
                    Colors.white)),
          ),
        )
      ],
    );
  }
}
