import 'package:app/screens/loginscreen.dart';
import 'package:app/screens/signupscreen.dart';
import 'package:app/screens/uploadscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp();

  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: UploadScreen(),
      routes: {
        SignupScreen.routeName: (ctx) => const SignupScreen(),
        LoginScreen.routeName: (ctx) => const LoginScreen(),
      },
    );
  }
}
