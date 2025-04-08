import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:funlish_app/model/learnedWord.dart';
import 'package:funlish_app/utility/databaseHandler.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:sizer/sizer.dart';

class Learnedwordspage extends StatefulWidget {
  final String type;
  final List<Learnedword> words;
  const Learnedwordspage({super.key, required this.type, required this.words});

  @override
  State<Learnedwordspage> createState() => _LearnedwordspageState();
}

class _LearnedwordspageState extends State<Learnedwordspage> {
  FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;
  List<Learnedword> words = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initTTS();
    Set<Learnedword> set = widget.words.toSet();
    for (var word in set) {
      words.add(word);
    }
  }

  Future<void> initTTS() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    await flutterTts.awaitSpeakCompletion(true);

    try {
      flutterTts.setStartHandler(() {
        setState(() => isSpeaking = true);
      });

      flutterTts.setCompletionHandler(() {
        setState(() => isSpeaking = false);
      });

      flutterTts.setErrorHandler((msg) {
        print('TTS Error: $msg');
        setState(() => isSpeaking = false);
      });

      print("TTS Engine Initialized Successfully!");
    } catch (e) {
      print('TTS Initialization Error: $e');
    }
  }

  Future<void> speak(String text) async {
    if (isSpeaking) return;

    int engineAvailable = await flutterTts.isLanguageAvailable("en-US") ? 1 : 0;
    if (engineAvailable == 0) {
      print("TTS Engine is not ready yet!");
      await initTTS(); // Re-initialize if needed
      return;
    }

    String processedText = text.replaceAll('_', ' ');

    try {
      await flutterTts.speak(processedText);
    } catch (e) {
      print('TTS Speak Error: $e');
    }
  }

  @override
  void dispose() {
    flutterTts.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyColor,
      body: SizedBox(
          width: 100.w,
          height: 100.h,
          child: SingleChildScrollView(
              child: Stack(alignment: Alignment.center, children: [
            Positioned(
              left: 4.w,
              top: 2.5.h,
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
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                height: 11.h,
              ),
              SizedBox(
                width: 90.w,
                child: Row(
                  children: [
                    setText("Words learned by ${widget.type}", FontWeight.w600,
                        16.sp, fontColor),
                  ],
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Column(
                  mainAxisAlignment: words.isNotEmpty
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: [
                    if (words.isEmpty)
                      SizedBox(
                        width: 90.w,
                        height: 70.h,
                        child: Center(
                          child: setText(
                              "You have no saved words...",
                              FontWeight.w500,
                              16.sp,
                              fontColor.withOpacity(0.6)),
                        ),
                      ),
                    if (words.isNotEmpty)
                      for (var word in words)
                        Container(
                          width: 90.w,
                          constraints: BoxConstraints(minHeight: 12.h),
                          margin: EdgeInsets.only(bottom: 2.h),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: preferences.getBool("isDarkMode") == true
                                  ? primaryPurple.withOpacity(0.3)
                                  : Colors.white),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              setText(word.word, FontWeight.w600, 15.5.sp,
                                  fontColor),
                              SizedBox(height: 1.h),
                              setText(word.description, FontWeight.w500, 14.sp,
                                  fontColor.withOpacity(0.6)),
                              SizedBox(height: 0.5.h),
                              TextButton(
                                onPressed: () {
                                  speak(word.word);
                                },
                                child: Image.asset(
                                  'assets/images/speaker.png',
                                  height: 4.5.h,
                                ),
                              )
                            ],
                          ),
                        ),
                  ])
            ])
          ]))),
    );
  }
}
