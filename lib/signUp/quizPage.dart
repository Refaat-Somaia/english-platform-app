import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:funlish_app/body.dart';
import 'package:funlish_app/components/modals/alertModal.dart';
import 'package:funlish_app/model/question.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:funlish_app/utility/global.dart';

class Quizpage extends StatefulWidget {
  final List<String> userInterests;

  const Quizpage({super.key, required this.userInterests});

  @override
  State<Quizpage> createState() => _QuizpageState();
}

class _QuizpageState extends State<Quizpage>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  late AnimationController animationController;
  final PageController pageController = PageController();

  int beginnerCorrect = 0;
  int intermediateCorrect = 0;
  int advancedCorrect = 0;
  int beginnerDone = 0;
  int intermediateDone = 0;
  int advancedDone = 0;
  // late var listener;
  int currentDifficultyLevel = 0;
  List<Question> beginnerQuestions = [];
  List<Question> intermediateQuestions = [];
  List<Question> advancedQuestions = [];
  List<Question> questions = [];
  List<Question> answeredQuestions = [];

  late Question currentQuestion;
  String answer = "";
  List<bool> isClicked = [false, false, false, false];

  void fetchQuestions() async {
    animationController.forward();
    // bool isConnected = await InternetConnection().hasInternetAccess;
    // if (!isConnected) {
    //   Navigator.pop(context);

    //   showAlertModal(context, "Please check your internet connection.");
    //   return;
    // }
    var url = Uri.parse('$serverIp/items/question/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      animationController.reverse();
      Timer(Duration(milliseconds: 300), () {
        setState(() {
          isLoading = false;
        });
      });
      QuestionList questionList =
          QuestionList.fromJson(json.decode(response.body));
      questionList.data.forEach((question) {
        print(question);

        switch (question.difficulty) {
          case "beginner":
            beginnerQuestions.add(question);
            break;
          case "intermediate":
            intermediateQuestions.add(question);
            break;
          case "advanced":
            advancedQuestions.add(question);
            break;
          default:
            break;
        }
      });
      print("so far so good");

      setState(() {
        questions = beginnerQuestions;
        currentQuestion = questions[0];
      });
      print("so far so good");

      return;
    }
    showAlertModal(context, "Please check your internet connection.");
    Navigator.pop(context);
    return;
  }

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    animationController.forward();
    super.initState();
    fetchQuestions();
    // listener =
    //     InternetConnection().onStatusChange.listen((InternetStatus status) {
    //   switch (status) {
    //     case InternetStatus.connected:
    //       break;
    //     case InternetStatus.disconnected:
    //       Navigator.pop(context);
    //       showAlertModal(context, "Internet connection was lost.");
    //       break;
    //   }
    // });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    animationController.dispose();
  }

  bool isSingleWordAnswer(Question question) {
    return question.options[0].split(" ").length == 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyColor,
      body: SizedBox(
          width: 100.w,
          height: 100.h,
          child: isLoading
              ? Animate(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.staggeredDotsWave(
                          color: primaryPurple, size: 18.w),
                      SizedBox(height: 1.h),
                      setText(
                          "Please wait...", FontWeight.w600, 16.sp, fontColor),
                    ],
                  ),
                )
                  .animate(controller: animationController, autoPlay: false)
                  .fadeIn(delay: 200.ms, duration: 400.ms, begin: 0)
              : Animate(
                  child: Column(
                    children: [
                      SizedBox(height: 5.h),
                      SizedBox(
                        width: 100.w,
                        height: 80.h,
                        child: PageView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: pageController,
                          onPageChanged: (value) {
                            setState(() {
                              currentQuestion = questions[value];
                              isClicked.clear();
                              isClicked.add(false);
                              isClicked.add(false);
                              isClicked.add(false);
                              isClicked.add(false);
                            });
                          },
                          children: [
                            for (Question question in questions)
                              Container(
                                height: 60.h,
                                width: 100.w,
                                // color: Colors.white,
                                child: Column(
                                  children: [
                                    SizedBox(height: 8.h),
                                    SizedBox(
                                      width: 90.w,
                                      height: 15.h,
                                      child: setText(
                                          question.text,
                                          FontWeight.w600,
                                          17.sp,
                                          fontColor,
                                          true),
                                    ),
                                    SizedBox(height: 10.h),
                                    SizedBox(
                                      width: 100.w,
                                      height: 25.h,
                                      child: Swiper(
                                          itemCount: question.options.length,
                                          viewportFraction: 0.6,
                                          loop: false,
                                          scale: 0.8,
                                          itemBuilder: (context, index) {
                                            return AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 200),
                                              // width: 50.w,
                                              // height: 7.h,
                                              decoration: BoxDecoration(
                                                  color: isClicked[index]
                                                      ? primaryPurple
                                                      : bodyColor,
                                                  border: Border.all(
                                                      color: primaryPurple
                                                          .withOpacity(0.8),
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: TextButton(
                                                onPressed: () {
                                                  answer =
                                                      question.options[index];
                                                  for (int i = 0;
                                                      i < isClicked.length;
                                                      i++) {
                                                    isClicked[i] = false;
                                                  }

                                                  isClicked[index] =
                                                      !isClicked[index];
                                                  setState(() {});
                                                },
                                                style: TextButton.styleFrom(
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: 40.w,
                                                      child: setText(
                                                          "${index + 1}. ${question.options[index]}",
                                                          FontWeight.w600,
                                                          16.sp,
                                                          isClicked[index]
                                                              ? bodyColor
                                                              : fontColor
                                                                  .withOpacity(
                                                                      0.8),
                                                          true),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      // SizedBox(height: 20.h),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: 85.w,
                        height: 7.h,
                        decoration: BoxDecoration(
                            color: answer != ""
                                ? primaryPurple
                                : primaryPurple.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16)),
                        child: TextButton(
                          onPressed: () async {
                            if (answer == "") return;

                            if (answer == currentQuestion.answer) {
                              answeredQuestions.add(currentQuestion);

                              if (currentDifficultyLevel == 0) {
                                beginnerProgress +=
                                    (beginnerThreshold / beginnerAttempts);
                                beginnerProgress =
                                    min(beginnerProgress, beginnerThreshold);
                                beginnerDone++;

                                print(
                                    "Beginner Progress: ${beginnerProgress.toStringAsFixed(2)}%");
                                if (beginnerProgress >= 15) {
                                  showAlertModal(
                                      context, "Moved to Intermediate");

                                  setState(() {
                                    questions = intermediateQuestions;
                                    currentDifficultyLevel = 1;
                                    pageController.jumpToPage(0);
                                  });
                                }
                              } else if (currentDifficultyLevel == 1) {
                                intermediateProgress += (intermediateThreshold /
                                    intermediateAttempts);
                                intermediateProgress = min(intermediateProgress,
                                    intermediateThreshold);
                                intermediateDone++;

                                print(
                                    "Intermediate Progress: ${intermediateProgress.toStringAsFixed(2)}%");
                                if (intermediateProgress >= 35) {
                                  showAlertModal(context, "Moved to advanced");

                                  setState(() {
                                    questions = advancedQuestions;
                                    currentDifficultyLevel = 2;
                                    pageController.jumpToPage(0);
                                  });
                                }
                              } else if (currentDifficultyLevel == 2) {
                                advancedProgress += (advancedThreshold / 2);
                                advancedProgress =
                                    min(advancedProgress, advancedThreshold);
                                advancedDone++;
                                print(
                                    "Advanced Progress: ${advancedProgress.toStringAsFixed(2)}%");
                              }
                            } else {
                              print("Incorrect Answer!");

                              if (currentDifficultyLevel == 0) {
                                beginnerAttempts++;
                                beginnerDone++;
                                beginnerProgress = max(
                                    0,
                                    beginnerProgress -
                                        (beginnerThreshold / beginnerAttempts) *
                                            beginnerPenaltyFactor);
                              } else if (currentDifficultyLevel == 1) {
                                intermediateAttempts++;
                                intermediateDone++;
                                intermediateProgress = max(
                                    0,
                                    intermediateProgress -
                                        (intermediateThreshold /
                                                intermediateAttempts) *
                                            intermeiatePenaltyFactor);

                                if (intermediateProgress <= 0 &&
                                    beginnerDone < beginnerQuestions.length) {
                                  showAlertModal(
                                      context, "Dropped back to Beginner");

                                  setState(() {
                                    questions = beginnerQuestions;
                                    currentDifficultyLevel = 0;
                                    // pageController.jumpToPage(0);
                                  });
                                }
                              } else if (currentDifficultyLevel == 2) {
                                advancedDone++;
                                advancedProgress = max(
                                    0,
                                    advancedProgress -
                                        (advancedThreshold / 2) *
                                            beginnerPenaltyFactor);

                                if (advancedProgress < 0 &&
                                    intermediateDone <
                                        intermediateQuestions.length) {
                                  showAlertModal(
                                      context, "Dropped back to Intermediate");
                                  setState(() {
                                    questions = intermediateQuestions;
                                    currentDifficultyLevel = 1;
                                    // pageController.jumpToPage(0);
                                  });
                                }
                              }
                            }

                            totalProgress = beginnerProgress +
                                intermediateProgress +
                                advancedProgress;
                            print(
                                "Final Level Progress: ${totalProgress.toStringAsFixed(2)}% out of 100%");

                            setState(() {
                              answer = "";
                            });
                            if (beginnerDone >= beginnerQuestions.length ||
                                intermediateDone >=
                                    intermediateQuestions.length ||
                                advancedDone >= advancedQuestions.length - 1 ||
                                totalProgress >= 100) {
                              print(
                                  "All questions completed! Navigating to next page...");
                              await signUserUp();
                            } else {
                              pageController.nextPage(
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.ease);
                            }
                          },
                          child: setText(
                              "Next", FontWeight.w600, 15.sp, Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
                  .scaleXY(
                      begin: 1.3, end: 1, curve: Curves.ease, duration: 400.ms)
                  .fadeIn()),
    );
  }

  Future<void> signUserUp() async {
    var response = await http.post(
      Uri.parse('$serverIp/items/personal_details/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'first_name': preferences.getString("userName"),
        'gender': preferences.getBool('userGender'),
        'email': preferences.getString("userEmail"),
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(jsonDecode(response.body)["data"]["id"]);
      int detailsId = jsonDecode(response.body)["data"]["id"];

      response = await http.post(
        Uri.parse('$serverIp/items/student/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'interests': widget.userInterests,
          'personal_details': detailsId,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        preferences.setBool("isLoggedIn", true);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => Body(
                    pageIndex: 0,
                  )),
          (route) => false,
        );
        showAlertModal(context, "current level: $totalProgress");
      }
    } else {
      print("Error ${response.statusCode}: ${response.body}");
    }
  }

  double intermediateThreshold = 35.0;
  double advancedThreshold = 50.0;
  double beginnerThreshold = 15.0;

  double beginnerProgress = 0.0;
  double intermediateProgress = 0.0;
  double advancedProgress = 0.0;
  double totalProgress = 0;
  int beginnerAttempts = 2;
  int intermediateAttempts = 4;
  double beginnerPenaltyFactor = 0.3;
  double intermeiatePenaltyFactor = 0.4;
}
