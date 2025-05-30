import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:funlish_app/utility/appTimer.dart';
import 'package:funlish_app/model/userProgress.dart';
import 'package:funlish_app/screens/splash.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black,
  ));

  UserProgress user = await UserProgress.loadProgress();
  await dotenv.load(fileName: ".env");

  runApp(
    ChangeNotifierProvider(
      create: (context) => user,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

Future<void> openExactAlarmSettings() async {
  if (await Permission.scheduleExactAlarm.isPermanentlyDenied) {
    await openAppSettings();
  }
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final SessionTracker sessionTracker = SessionTracker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    sessionTracker.startSession(); // Session starts when app opens
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      // App is backgrounded or closed
      final session = sessionTracker.endSession();
      sessionTracker.saveSessionLog(session);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Just preload assets (this won't display them)
    precacheImage(
        const AssetImage("assets/images/mascot-greating.png"), context);
    precacheImage(
        const AssetImage("assets/images/mascot-thinking.png"), context);
    precacheImage(
        const AssetImage("assets/images/mascot-talking.png"), context);
    precacheImage(const AssetImage("assets/images/blob-1.png"), context);
    precacheImage(const AssetImage("assets/images/blob-2.png"), context);
    precacheImage(const AssetImage("assets/images/blob-3.png"), context);
    precacheImage(const AssetImage("assets/images/mascot-pink.png"), context);
    precacheImage(const AssetImage("assets/images/mascot-green.png"), context);
    precacheImage(const AssetImage("assets/images/login.png"), context);

    return Sizer(builder: (context, orientation, screenType) {
      return SafeArea(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const Splash(),
        ),
      );
    });
  }
}
