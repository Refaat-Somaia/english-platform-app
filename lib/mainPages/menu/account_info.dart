import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:funlish_app/components/appButton.dart';
import 'package:funlish_app/components/avatar.dart';
import 'package:funlish_app/components/modals/alertModal.dart';
import 'package:funlish_app/components/modals/passwordModal.dart';
import 'package:funlish_app/components/modals/successModal.dart';
import 'package:funlish_app/model/userProgress.dart';
import 'package:funlish_app/screens/login.dart';
import 'package:funlish_app/screens/splash.dart';
import 'package:funlish_app/utility/databaseHandler.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:sqflite/sqlite_api.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordEditController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  bool isPasswordVisible = false;
  bool isEditting = false;
  late Color borderColor;
  late Color containerColor;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    containerColor =
        isEditting ? Colors.transparent : fontColor.withOpacity(0.05);
    borderColor = isEditting ? borderColor : Colors.transparent;
    nameController.text = preferences.getString("userName")!;
    emailController.text = preferences.getString("userEmail") ?? "tester";
    // passwordConfirmController.text=preferences.getString("userPassword")!;
    passwordController.text = preferences.getString("userPassword") ?? "";
  }

  void updateIsEditting() {
    setState(() {
      isEditting = !isEditting;
      containerColor =
          isEditting ? Colors.transparent : fontColor.withOpacity(0.05);
      borderColor =
          isEditting ? fontColor.withOpacity(0.2) : Colors.transparent;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProgress>(context);

    return Scaffold(
      backgroundColor: bodyColor,
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 4.w,
                top: 3.h,
                child: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      // border: Border.all(
                      //     width: 1.5, color: fontColor.withOpacity(0.2))
                      color: primaryPurple),
                  child: IconButton(
                      style: buttonStyle(16),
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 4.5.h,
                  ),
                  setText(
                      "Personal details", FontWeight.w600, 17.sp, fontColor),
                  SizedBox(
                    height: 4.h,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Avatar(
                          characterIndex: user.characterIndex,
                          hatIndex: user.hatIndex,
                          width: 20.w),
                      SizedBox(
                        height: 1.h,
                      ),
                      setText(nameController.text, FontWeight.w600, 16.sp,
                          fontColor),
                      setText("Level: ${user.level}", FontWeight.w600, 13.sp,
                          fontColor.withOpacity(0.5)),
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Container(
                    width: 90.w,
                    height: 6.5.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: containerColor,
                      border: Border.all(
                        color: borderColor,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: TextFormField(
                        readOnly: !isEditting,
                        style: TextStyle(
                          fontFamily: "magnet",
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: fontColor,
                        ),
                        decoration: InputDecoration(
                          counterStyle: TextStyle(fontSize: 0),
                          hintStyle: TextStyle(
                            fontFamily: "magnet",
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: fontColor.withOpacity(0.3),
                          ),
                          hintText: "User name",
                          prefixIcon: Icon(
                            FontAwesomeIcons.user,
                            size: 6.w,
                            color: fontColor.withOpacity(0.4),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 1.4.h),
                        ),
                        controller: nameController,
                        maxLength: 40,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Container(
                    width: 90.w,
                    height: 6.5.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: containerColor,
                      border: Border.all(
                        color: borderColor,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: TextFormField(
                        readOnly: !isEditting,
                        style: TextStyle(
                          fontFamily: "magnet",
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: fontColor,
                        ),
                        decoration: InputDecoration(
                          counterStyle: TextStyle(fontSize: 0),
                          hintStyle: TextStyle(
                            fontFamily: "magnet",
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: fontColor.withOpacity(0.3),
                          ),
                          hintText: "Enter",
                          prefixIcon: Icon(
                            Icons.email,
                            size: 6.w,
                            color: fontColor.withOpacity(0.4),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 1.4.h),
                        ),
                        controller: emailController,
                        maxLength: 70,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    width: 90.w,
                    height: 6.5.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: containerColor,
                      border: Border.all(
                        color: isEditting
                            ? (passwordController.text.isNotEmpty &&
                                    passwordController.text.length < 8)
                                ? Colors.redAccent.withOpacity(0.3)
                                : (passwordController.text.length >= 8)
                                    ? Colors.green.withOpacity(0.4)
                                    : borderColor
                            : borderColor,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Stack(children: [
                        TextFormField(
                          readOnly: !isEditting,
                          style: TextStyle(
                            fontFamily: "magnet",
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: fontColor,
                          ),
                          decoration: InputDecoration(
                            counterStyle: TextStyle(fontSize: 0),
                            hintStyle: TextStyle(
                              fontFamily: "magnet",
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: fontColor.withOpacity(0.3),
                            ),
                            hintText: "Password",
                            prefixIcon: Icon(
                              Icons.lock,
                              size: 6.w,
                              color: fontColor.withOpacity(0.4),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 1.4.h),
                          ),
                          onChanged: (v) {
                            setState(() {});
                          },
                          controller: passwordController,
                          obscureText: !isPasswordVisible,
                          maxLength: 50,
                        ),
                      ]),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    width: 90.w,
                    height: 6.5.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: containerColor,
                      border: Border.all(
                        color: isEditting
                            ? ((passwordController.text !=
                                        passwordConfirmController.text &&
                                    passwordConfirmController.text.isNotEmpty)
                                ? Colors.redAccent.withOpacity(0.3)
                                : (passwordConfirmController.text.isNotEmpty &&
                                        passwordController.text ==
                                            passwordConfirmController.text)
                                    ? Colors.green.withOpacity(0.4)
                                    : borderColor)
                            : borderColor,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Stack(children: [
                        TextFormField(
                          readOnly: !isEditting,
                          style: TextStyle(
                            fontFamily: "magnet",
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: fontColor,
                          ),
                          decoration: InputDecoration(
                            counterStyle: TextStyle(fontSize: 0),
                            hintStyle: TextStyle(
                              fontFamily: "magnet",
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: fontColor.withOpacity(0.3),
                            ),
                            hintText: "Confirm password",
                            prefixIcon: Icon(
                              Icons.lock,
                              size: 6.w,
                              color: fontColor.withOpacity(0.4),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 1.4.h),
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                          controller: passwordConfirmController,
                          obscureText: !isPasswordVisible,
                          maxLength: 50,
                        ),
                      ]),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  SizedBox(
                    width: 90.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 12.5.w,
                              height: 12.5.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  // border: Border.all(
                                  //     width: 1.5, color: fontColor.withOpacity(0.2))
                                  color: primaryPurple.withOpacity(0.2)),
                              child: IconButton(
                                  style: buttonStyle(16),
                                  onPressed: () {
                                    showPasswordModal();
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.pen,
                                    size: 6.w,
                                    color: primaryPurple,
                                  )),
                            ),
                            SizedBox(height: 0.5.h),
                            setText("Edit", FontWeight.w500, 13.5.sp,
                                fontColor.withOpacity(0.6))
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: 12.5.w,
                              height: 12.5.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  // border: Border.all(
                                  //     width: 1.5, color: fontColor.withOpacity(0.2))
                                  color: primaryPurple.withOpacity(0.2)),
                              child: IconButton(
                                  style: buttonStyle(16),
                                  onPressed: () {},
                                  icon: Icon(
                                    FontAwesomeIcons.share,
                                    size: 6.w,
                                    color: primaryPurple,
                                  )),
                            ),
                            SizedBox(height: 0.5.h),
                            setText("Share", FontWeight.w500, 13.5.sp,
                                fontColor.withOpacity(0.6))
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: 12.5.w,
                              height: 12.5.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  // border: Border.all(
                                  //     width: 1.5, color: fontColor.withOpacity(0.2))
                                  color: primaryPurple.withOpacity(0.2)),
                              child: IconButton(
                                  style: buttonStyle(16),
                                  onPressed: () async {
                                    user.clearUser();
                                    await preferences.clear();
                                    await clearDatabase();

                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (BuildContext context) =>
                                            Login(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.arrowRightFromBracket,
                                    size: 6.w,
                                    color: primaryPurple,
                                  )),
                            ),
                            SizedBox(height: 0.5.h),
                            setText("Sign out", FontWeight.w500, 13.5.sp,
                                fontColor.withOpacity(0.6))
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  AppButton(
                    function: () {
                      if (!isEditting) return;
                      bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(emailController.text.toString());
                      if (emailController.text.isEmpty ||
                          nameController.text.isEmpty ||
                          passwordController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        showAlertModal(context, "Please fill all fields");
                        return;
                      } else if (!emailValid || emailController.text.isEmpty) {
                        showAlertModal(context, "Please enter a valid email");
                        return;
                      } else if (passwordController.text.length < 8) {
                        showAlertModal(context,
                            "Your password must be longer than 8 characters");
                        return;
                      } else if (passwordController.text !=
                          passwordConfirmController.text) {
                        showAlertModal(context, "Passwords don't match");
                        return;
                      }
                      signUserUp();
                      showSuccessModal(
                          context, "AccountInfo updated Succefully!");
                      updateIsEditting();
                    },
                    height: 7.h,
                    width: 90.w,
                    color: primaryPurple,
                    text: "Save",
                    icon: FontAwesomeIcons.floppyDisk,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signUserUp() async {
    preferences.setBool("isLoggedIn", true);
    preferences.setString("userName", nameController.text);
    preferences.setString("userEmail", emailController.text);
    preferences.setString("userPassword", passwordController.text);
  }

  void showPasswordModal() {
    setState(() {
      passwordEditController.text = "";
    });
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Animate(
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                insetPadding: EdgeInsets.all(5.w),
                backgroundColor: bodyColor,
                content: Container(
                  height: 40.h,
                  width: double.maxFinite,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Animate(
                        child: Icon(
                          Icons.lock,
                          size: 6.h,
                          color: primaryPurple,
                        ),
                      )
                          .scaleXY(
                            begin: 0,
                            end: 1.3,
                            curve: Curves.easeOut,
                            duration: 300.ms,
                          )
                          .scaleXY(
                              begin: 1.2,
                              end: 1,
                              curve: Curves.easeOut,
                              duration: 300.ms,
                              delay: 300.ms),
                      SizedBox(
                        height: 4.h,
                      ),
                      setText("Enter your current password", FontWeight.w600,
                          15.sp, fontColor),
                      SizedBox(
                        height: 2.h,
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        width: double.infinity,
                        height: 6.5.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: (passwordEditController.text.isNotEmpty &&
                                    passwordController.text !=
                                        passwordEditController.text)
                                ? Colors.redAccent.withOpacity(0.3)
                                : (passwordEditController.text.length >= 8)
                                    ? Colors.green.withOpacity(0.4)
                                    : fontColor.withOpacity(0.1),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Stack(children: [
                            TextFormField(
                              style: TextStyle(
                                fontFamily: "magnet",
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: fontColor,
                              ),
                              decoration: InputDecoration(
                                counterStyle: TextStyle(fontSize: 0),
                                hintStyle: TextStyle(
                                  fontFamily: "magnet",
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: fontColor.withOpacity(0.3),
                                ),
                                hintText: "Password",
                                prefixIcon: Icon(
                                  Icons.lock,
                                  size: 6.w,
                                  color: fontColor.withOpacity(0.4),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 1.4.h),
                              ),
                              onChanged: (v) {
                                setState(() {});
                              },
                              controller: passwordEditController,
                              obscureText: !isPasswordVisible,
                              maxLength: 50,
                            ),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility_off
                                      : Icons.remove_red_eye_rounded,
                                  size: 6.w,
                                  color: fontColor.withOpacity(0.4),
                                ),
                              ),
                            )
                          ]),
                        ),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: (passwordEditController.text ==
                                    passwordController.text)
                                ? primaryPurple
                                : primaryPurple.withOpacity(0.4)),
                        width: double.infinity,
                        height: 6.5.h,
                        child: TextButton(
                          onPressed: () {
                            if (passwordEditController.text ==
                                passwordController.text) {
                              updateIsEditting();
                              Navigator.pop(context);
                            } else {
                              return;
                            }
                          },
                          style: buttonStyle(24),
                          child: setText(
                              "Enter", FontWeight.w600, 15.sp, Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
                .slideY(begin: .1, end: 0, curve: Curves.ease, duration: 400.ms)
                .fadeIn();
          });
        });
  }
}
