import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:funlish_app/model/userProgress.dart';
import 'package:funlish_app/screens/splash.dart';
import 'package:funlish_app/utility/global.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black,
  ));

  UserProgress user = await UserProgress.loadProgress();

  runApp(
    ChangeNotifierProvider(
      create: (context) => user,
      child: MyApp(),
    ),
  );
}

Future<void> openExactAlarmSettings() async {
  if (await Permission.scheduleExactAlarm.isPermanentlyDenied) {
    await openAppSettings();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Image.asset("assets/image/mascot-greating.png");
    Image.asset("assets/image/mascot-thinking.png");
    Image.asset("assets/image/mascot-talking.png");
    Image.asset("assets/image/blob-1.png");
    Image.asset("assets/image/blob-2.png");
    Image.asset("assets/image/blob-3.png");
    Image.asset("assets/image/mascot-pink.png");
    Image.asset("assets/image/mascot-green.png");
    Image.asset("assets/image/mascot-login.png");

    return Sizer(builder: (context, orientation, screenType) {
      return SafeArea(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const Splash(),
          // home:SplashScreen(),
        ),
      );
    });
  }
}
