// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:funlish_app/utility/global.dart';
// import 'package:sizer/sizer.dart';

// class PasswordModal extends StatefulWidget {
//   @override
//   _PasswordModalState createState() => _PasswordModalState();

//   static void show(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Animate(
//           child: PasswordModal(),
//         )
//             .scaleXY(
//                 begin: 1.2, end: 1, duration: 200.ms, curve: Curves.easeOut)
//             .fadeIn(duration: 200.ms, curve: Curves.easeOut);
//       },
//     );
//   }
// }

// class _PasswordModalState extends State<PasswordModal> {
//   final TextEditingController passwordEditController = TextEditingController();
//   bool isPasswordVisible = false;
//   bool isEditting = false;

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       insetPadding: EdgeInsets.all(5.w),
//       backgroundColor: bodyColor,
//       content: Container(
//         height: 40.h,
//         width: double.maxFinite,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Animate(
//               child: Icon(
//                 Icons.lock,
//                 size: 6.h,
//                 color: primaryPurple,
//               ),
//             )
//                 .scaleXY(
//                   begin: 0,
//                   end: 1.3,
//                   curve: Curves.easeOut,
//                   duration: 300.ms,
//                 )
//                 .scaleXY(
//                     begin: 1.2,
//                     end: 1,
//                     curve: Curves.easeOut,
//                     duration: 300.ms,
//                     delay: 300.ms),
//             SizedBox(
//               height: 4.h,
//             ),
//             setText("Enter your current password", FontWeight.w600, 15.sp,
//                 fontColor),
//             SizedBox(
//               height: 2.h,
//             ),
//             AnimatedContainer(
//               duration: Duration(milliseconds: 300),
//               curve: Curves.easeOut,
//               width: double.infinity,
//               height: 6.5.h,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(
//                   color: (passwordEditController.text.isNotEmpty &&
//                           passwordEditController.text.length < 8)
//                       ? Colors.redAccent.withOpacity(0.3)
//                       : (passwordEditController.text.length >= 8)
//                           ? Colors.green.withOpacity(0.4)
//                           : fontColor.withOpacity(0.1),
//                   width: 2,
//                 ),
//               ),
//               child: Center(
//                 child: Stack(children: [
//                   TextFormField(
//                     style: TextStyle(
//                       fontFamily: "magnet",
//                       fontSize: 15.sp,
//                       fontWeight: FontWeight.w600,
//                       color: fontColor,
//                     ),
//                     decoration: InputDecoration(
//                       counterStyle: TextStyle(fontSize: 0),
//                       hintStyle: TextStyle(
//                         fontFamily: "magnet",
//                         fontSize: 15.sp,
//                         fontWeight: FontWeight.w500,
//                         color: fontColor.withOpacity(0.3),
//                       ),
//                       hintText: "Password",
//                       prefixIcon: Icon(
//                         Icons.lock,
//                         size: 6.w,
//                         color: fontColor.withOpacity(0.4),
//                       ),
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.only(top: 1.4.h),
//                     ),
//                     onChanged: (v) {
//                       setState(() {});
//                     },
//                     controller: passwordEditController,
//                     obscureText: !isPasswordVisible,
//                     maxLength: 50,
//                   ),
//                   Positioned(
//                     right: 0,
//                     child: IconButton(
//                       onPressed: () {
//                         setState(() {
//                           isPasswordVisible = !isPasswordVisible;
//                         });
//                       },
//                       icon: Icon(
//                         isPasswordVisible
//                             ? Icons.visibility_off
//                             : Icons.remove_red_eye_rounded,
//                         size: 6.w,
//                         color: fontColor.withOpacity(0.4),
//                       ),
//                     ),
//                   )
//                 ]),
//               ),
//             ),
//             SizedBox(
//               height: 3.h,
//             ),
//             Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   color: isEditting
//                       ? primaryPurple
//                       : primaryPurple.withOpacity(0.4)),
//               width: double.infinity,
//               height: 6.5.h,
//               child: TextButton(
//                 onPressed: () {
//                   setState(() {
//                     isEditting = !isEditting;
//                   });
//                 },
//                 style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
//                 child: setText("Enter", FontWeight.w600, 15.sp, Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     passwordEditController.dispose();
//     super.dispose();
//   }
// }
