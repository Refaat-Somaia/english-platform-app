import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:funlish_app/components/modals/alertModal.dart';
import 'package:funlish_app/components/modals/successModal.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:funlish_app/utility/socketIoClient.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

class Createsession extends StatefulWidget {
  final Color color;
  final String gameName;
  const Createsession({super.key, required this.gameName, required this.color});

  @override
  State<Createsession> createState() => _CreatesessionState();
}

class _CreatesessionState extends State<Createsession> {
  late SocketService socketService;
  void initState() {
    // TODO: implement initState

    super.initState();
    if (mounted) {
      socketService = SocketService(
          updateLoading: () {},
          addAnswer: () {},
          friednlyBomb: () {},
          extendTimer: () {},
          hasDraw: () {},
          hasWon: () {},
          addPoints: () {},
          updatePlayers: () {},
          setFirst: () {},
          setId: setId,
          hasLost: () {
            showAlertModal(context, "You have lost!!!");
          },
          addSentence: () {},
          addWord: () {},
          showAlert: () {
            showAlertModal(context, "Session was temrinated");
          });
    }
    socketService.connect();
    socketService.createSession(widget.gameName);
  }

  String sessionId = '';
  bool isLoading = true;

  void setId(String id) {
    setState(() {
      sessionId = id;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    socketService.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bodyColor,
        body: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Container(
                decoration: BoxDecoration(
                    // color: widget.chapter.colorAsColor.withOpacity(0.05),
                    color: widget.color.withOpacity(0.05)),
                height: double.infinity,
                width: 100.w,
                child: isLoading
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LoadingAnimationWidget.fallingDot(
                              color: widget.color, size: 18.w),
                          SizedBox(height: 1.h),
                          setText("Generating session id...", FontWeight.w600,
                              16.sp, fontColor)
                        ],
                      )
                    : Animate(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 92.w,
                              child: setText(
                                  "Send this code to your friends so they can join!",
                                  FontWeight.w600,
                                  15.sp,
                                  fontColor.withOpacity(0.8),
                                  true),
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            SizedBox(
                              width: 95.w,
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 2.w,
                                runSpacing: 1.h,
                                children: [
                                  for (String s in sessionId.split(""))
                                    Container(
                                      width: 13.w,
                                      height: 13.w,
                                      decoration: BoxDecoration(
                                          color: primaryPurple.withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Center(
                                        child: setText(s, FontWeight.w600,
                                            16.sp, fontColor),
                                      ),
                                    )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            Container(
                              width: 43.w,
                              height: 7.h,
                              decoration: BoxDecoration(
                                  color: primaryPurple,
                                  borderRadius: BorderRadius.circular(16)),
                              child: TextButton(
                                onPressed: () async {
                                  await Clipboard.setData(
                                    ClipboardData(
                                      text: sessionId,
                                    ),
                                  );
                                  showSuccessModal(
                                      context, "Code copied to Clipboard");
                                },
                                style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16)))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(FontAwesomeIcons.clipboard,
                                        size: 6.w, color: Colors.white),
                                    SizedBox(
                                      width: 2.w,
                                    ),
                                    setText("Copy code", FontWeight.w600, 15.sp,
                                        Colors.white),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).fadeIn(duration: 400.ms))));
  }
}
