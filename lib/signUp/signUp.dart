import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:funlish_app/components/modals/alertModal.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:funlish_app/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../screens/afterSignUp.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyColor,
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SizedBox(
          width: 100.w,
          height: 94.h,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 18.h,
                ),
                Animate(
                        child: setText(
                            "Sign up", FontWeight.w600, 20.sp, fontColor))
                    .slideY(
                        begin: -0.5,
                        end: 0,
                        curve: Curves.easeOut,
                        delay: 200.ms)
                    .fadeIn(),
                SizedBox(
                  height: 0.6.h,
                ),
                Animate(
                  child: setText("Create a new account", FontWeight.w500, 14.sp,
                      fontColor.withOpacity(0.6)),
                ).fadeIn(delay: 400.ms),
                SizedBox(
                  height: 4.h,
                ),
                Animate(
                  child: Container(
                    width: 90.w,
                    height: 6.5.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: fontColor.withOpacity(0.1),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: TextFormField(
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
                )
                    .slideY(
                        begin: -0.5,
                        end: 0,
                        curve: Curves.easeOut,
                        delay: 500.ms)
                    .fadeIn(),
                SizedBox(
                  height: 2.h,
                ),
                Animate(
                  child: Container(
                    width: 90.w,
                    height: 6.5.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: fontColor.withOpacity(0.1),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: TextFormField(
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
                )
                    .slideY(
                        begin: -0.5,
                        end: 0,
                        curve: Curves.easeOut,
                        delay: 600.ms)
                    .fadeIn(),
                SizedBox(
                  height: 2.h,
                ),
                Animate(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    width: 90.w,
                    height: 6.5.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: (passwordController.text.isNotEmpty &&
                                passwordController.text.length < 8)
                            ? Colors.redAccent.withOpacity(0.3)
                            : (passwordController.text.length >= 8)
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
                          controller: passwordController,
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
                              )),
                        )
                      ]),
                    ),
                  ),
                )
                    .slideY(
                        begin: -0.5,
                        end: 0,
                        curve: Curves.easeOut,
                        delay: 700.ms)
                    .fadeIn(),
                SizedBox(
                  height: 2.h,
                ),
                Animate(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    width: 90.w,
                    height: 6.5.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: (passwordController.text !=
                                    passwordConfirmController.text &&
                                passwordConfirmController.text.isNotEmpty)
                            ? Colors.redAccent.withOpacity(0.3)
                            : (passwordConfirmController.text.isNotEmpty &&
                                    passwordController.text ==
                                        passwordConfirmController.text)
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
                )
                    .slideY(
                        begin: -0.5,
                        end: 0,
                        curve: Curves.easeOut,
                        delay: 800.ms)
                    .fadeIn(),
                SizedBox(
                  height: 8.h,
                ),
                Animate(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: primaryPurple),
                    width: 89.w,
                    height: 6.5.h,
                    child: TextButton(
                      onPressed: () {
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(emailController.text.toString());
                        if (emailController.text.isEmpty ||
                            nameController.text.isEmpty ||
                            passwordController.text.isEmpty ||
                            passwordController.text.isEmpty) {
                          showAlertModal(context, "Please fill all fields");
                          return;
                        } else if (!emailValid ||
                            emailController.text.isEmpty) {
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
                        Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const AfterSignUp()),
                        );
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: primaryPurple,
                          padding: EdgeInsets.all(0)),
                      child:
                          setText("Next", FontWeight.w600, 15.sp, Colors.white),
                    ),
                  ),
                ).fadeIn(delay: 1000.ms),
                SizedBox(
                  height: 2.h,
                ),
                Animate(
                  child: setText("Wait I already have an account!",
                      FontWeight.w500, 14.sp, fontColor.withOpacity(0.5)),
                ).fadeIn(delay: 1000.ms),
                Animate(
                  child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const Login()),
                        );
                      },
                      child: setText(
                          "Login", FontWeight.w600, 15.sp, primaryPurple)),
                ).fadeIn(delay: 1000.ms),
              ],
            ),
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
}
