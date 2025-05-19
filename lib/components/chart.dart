import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:sizer/sizer.dart';

class Chart extends StatefulWidget {
  final Map<String, int> values;
  final double amountMax;
  final double height;

  const Chart(
      {super.key,
      required this.values,
      required this.amountMax,
      required this.height});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> with SingleTickerProviderStateMixin {
  List<double> lengthsOfValues = [];
  late List<double> animatedHeights; // List for animated heights
  late AnimationController controller; // Controller for animation
  late Animation<double> animation; // Animation property

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(milliseconds: 1000), // Duration of the animation
      vsync: this,
    );

    animation = Tween<double>(begin: 0, end: 1).animate(controller);
    controller.forward(); // Start the animation
  }

  void formattedValues() {
    if (widget.values.isNotEmpty) {
      int max = 1;
      widget.values.forEach((key, value) {
        if (max < value) {
          max = value;
        }
      });
      double percentage = 20 / max;
      lengthsOfValues = []; // Reset the list
      widget.values.forEach((key, value) {
        lengthsOfValues.add((percentage * value));
      });
    }
  }

  @override
  void dispose() {
    controller.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    formattedValues();

    // print(widget.values.length);
    return SizedBox(
      width: 90.w,
      height: widget.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 20.h,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: fontColor.withOpacity(0.3)))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (lengthsOfValues.isNotEmpty)
                  for (int i = 0; i < widget.values.length; i++)
                    AnimatedBuilder(
                      animation: animation, // Use the animation for building
                      builder: (context, child) {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: (lengthsOfValues[i] * animation.value).h,
                              width: 5.w,
                              decoration: BoxDecoration(
                                color: primaryPurple,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                            ),
                            if (widget.amountMax > 0)
                              Positioned(
                                top: -2.5.h,
                                left: 1.w,
                                child: Container(
                                    decoration: const BoxDecoration(),
                                    child: setText(
                                        "${widget.values.values.elementAt(i)}",
                                        FontWeight.bold,
                                        13.sp,
                                        fontColor.withOpacity(0.8))),
                              ),
                          ],
                        );
                      },
                    ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (lengthsOfValues.isNotEmpty)
                for (int i = 0; i < widget.values.length; i++)
                  Text(
                    widget.values.keys.elementAt(i),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: fontColor.withOpacity(0.5),
                    ),
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
