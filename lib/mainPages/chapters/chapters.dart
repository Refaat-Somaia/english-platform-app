import 'package:flutter/material.dart';
import 'package:funlish_app/components/chapterIntro.dart';
import 'package:funlish_app/utility/global.dart';
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
  ValueNotifier<int> activeIndex = ValueNotifier<int>(0);

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
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: chapters[chapterIndex].colorAsColor.withOpacity(0.05),
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
                            padding: EdgeInsets.symmetric(horizontal: 1.w),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
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
          ],
        ),
      ),
    );
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
