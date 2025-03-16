import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funlish_app/components/modals/alertModal.dart';
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
          hasWon: () {},
          addPoints: () {},
          updatePlayers: () {},
          setFirst: () {},
          hasLost: () {
            showAlertModal(context, "You have lost!!!");
          },
          addSentence: () {},
          addWord: () {},
          showAlert: () {
            showAlertModal(context, "Session was temrinated");
          });
    }
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingAnimationWidget.staggeredDotsWave(
                      color: widget.color, size: 18.w),
                  SizedBox(height: 1.h),
                  setText("Generating session id...", FontWeight.w600, 16.sp,
                      fontColor)
                ],
              ),
            )));
  }
}
