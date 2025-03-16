import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:funlish_app/utility/global.dart';
import 'package:funlish_app/signUp/signUp.dart';
import 'package:sizer/sizer.dart';
import 'afterSignUp.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formField = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor:
            bodyColor, // Assuming `bodyColor` is defined in `global.dart`.
        body: Container(
          width: 100.w,
          height: 100.h,
          color: bodyColor,
          child: SingleChildScrollView(
            child: Form(
              key: formField,
              child: Column(
                children: [
                  SizedBox(
                    height: 8.h,
                  ),
                  Animate(
                    child: Image.asset(
                      'assets/images/login.png',
                      height: 30.h,
                    ),
                  )
                      .slideY(
                          begin: -0.2,
                          end: 0,
                          curve: Curves.easeOut,
                          delay: 200.ms)
                      .fadeIn(),
                  SizedBox(
                    height: 5.h,
                  ),
                  Animate(
                          child: setText("Welcome back!", FontWeight.w600,
                              20.sp, fontColor))
                      .fadeIn(delay: 500.ms),
                  SizedBox(
                    height: 0.6.h,
                  ),
                  Animate(
                    child: setText("Log into your account", FontWeight.w500,
                        14.sp, fontColor.withOpacity(0.5)),
                  ).fadeIn(delay: 600.ms),
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
                            hintText: "Email",
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
                          delay: 700.ms)
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
                          delay: 800.ms)
                      .fadeIn(),
                  SizedBox(
                    height: 4.h,
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
                          if (!emailValid || emailController.text.isEmpty) {
                            _showModalBottomSheet(
                                context, "Please enter a valid email");
                            return;
                          } else if (passwordController.text.length < 8) {
                            _showModalBottomSheet(
                                context, "Please enter a valid password");
                            return;
                          }
                          Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const AfterSignUp()),
                          );
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: primaryPurple,
                            padding: EdgeInsets.all(0)),
                        child: setText(
                            "Login", FontWeight.w600, 15.sp, Colors.white),
                      ),
                    ),
                  ).fadeIn(delay: 700.ms),
                  SizedBox(
                    height: 2.h,
                  ),
                  Animate(
                    child: setText("Wait I don't have an account!",
                        FontWeight.w500, 14.sp, fontColor.withOpacity(0.5)),
                  ).fadeIn(delay: 700.ms),
                  Animate(
                    child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const Signup()),
                          );
                        },
                        child: setText(
                            "Sign up", FontWeight.w600, 15.sp, primaryPurple)),
                  ).fadeIn(delay: 700.ms)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context, String msg) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16))),
          height: 30.h,
          width: 100.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Animate(
                child: Icon(
                  FontAwesomeIcons.circleExclamation,
                  size: 7.h,
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
              setText(msg, FontWeight.w500, 15.sp, fontColor),
            ],
          ),
        );
      },
    );
  }
}
