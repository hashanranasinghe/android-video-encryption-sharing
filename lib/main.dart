import 'package:app/screens/contactlistscreen.dart';
import 'package:app/screens/loginscreen.dart';
import 'package:app/screens/sharevideolistscreen.dart';
import 'package:app/screens/signupscreen.dart';
import 'package:app/screens/splashscreen.dart';
import 'package:app/screens/uploadscreen.dart';
import 'package:app/screens/videolistscreen.dart';
import 'package:app/widgets/video_card.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'models/provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp();

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:(ctx)=> ShareData(),)

      ],
      child: MaterialApp(
        home: const SplashScreen(),
        routes: {
          SplashScreen.routName: (ctx) => const SplashScreen(),
          SignupScreen.routeName: (ctx) => const SignupScreen(),
          LoginScreen.routeName: (ctx) => const LoginScreen(),
          VideoListScreen.routeName: (ctx) => const VideoListScreen(),
          UploadScreen.routeName: (ctx) => const UploadScreen(),
          ContactListScreen.routeName: (ctx) => const ContactListScreen(),
          ShareVideoListScreen.routeName: (ctx) => const ShareVideoListScreen(),
        },
      ),
    );
  }
}
