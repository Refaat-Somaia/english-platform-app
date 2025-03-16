import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:funlish_app/utility/custom_icons_icons.dart';
import 'package:sizer/sizer.dart';

import '../components/interestCard.dart';
import '../utility/global.dart';

class Interests extends StatefulWidget {
  final List<String> userInterests;
  const Interests({super.key, required this.userInterests});

  @override
  State<Interests> createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      widget.userInterests.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bodyColor,
        body: SizedBox(
            height: 70.h,
            width: 100.w,
            child: Column(children: [
              SizedBox(
                height: 4.h,
              ),
              SizedBox(
                width: 90.w,
                child: setText("What are the things you find interesting 🤔",
                    FontWeight.w600, 17.sp, fontColor, true),
              ),
              SizedBox(
                height: 5.h,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(2.w),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 0.w,
                        mainAxisSpacing: 0.h,
                        childAspectRatio: 1,
                      ),
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        List<Map<String, dynamic>> interestItems = [
                          {
                            "title": "Sports",
                            "icon": Icons.sports_baseball_rounded,
                            "index": 300
                          },
                          {
                            "title": "Food",
                            "icon": CustomIcons.noun_healthy_food_3504100_1,
                            "index": 400
                          },
                          {
                            "title": "Reading",
                            "icon": Icons.book_rounded,
                            "index": 500
                          },
                          {
                            "title": "Painting",
                            "icon": CustomIcons.brush_svgrepo_com_1,
                            "index": 600
                          },
                          {
                            "title": "Tech",
                            "icon": Icons.laptop_chromebook_rounded,
                            "index": 700
                          },
                          {
                            "title": "Healthcare",
                            "icon": Icons.health_and_safety_rounded,
                            "index": 800
                          },
                          {
                            "title": "Engineering",
                            "icon": Icons.settings,
                            "index": 900
                          },
                          {
                            "title": "Movies",
                            "icon": Icons.movie_sharp,
                            "index": 1000
                          },
                          {
                            "title": "Fashion",
                            "icon": CustomIcons.group_101,
                            "index": 1100
                          },
                          {
                            "title": "Traveling",
                            "icon": FontAwesomeIcons.plane,
                            "index": 1100
                          },
                          {
                            "title": "Music",
                            "icon": FontAwesomeIcons.music,
                            "index": 1100
                          },
                          {
                            "title": "Cars",
                            "icon": FontAwesomeIcons.car,
                            "index": 1100
                          },
                        ];

                        var item = interestItems[index];
                        return InterestCard(
                          title: item['title'],
                          userInterests: widget.userInterests,
                          icon: item['icon'],
                          index: item['index'],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ])));
  }
}
