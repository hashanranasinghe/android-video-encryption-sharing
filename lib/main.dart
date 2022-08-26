import 'package:app/screens/contactlistscreen.dart';
import 'package:app/screens/favoritecontactlistscreen.dart';
import 'package:app/screens/fingerprintscreen.dart';
import 'package:app/screens/forgetpasswordscreen.dart';
import 'package:app/screens/invitationscreen.dart';
import 'package:app/screens/loginscreen.dart';
import 'package:app/screens/profilescreen.dart';
import 'package:app/screens/settingsscreen.dart';
import 'package:app/screens/sharevideolistscreen.dart';
import 'package:app/screens/signupscreen.dart';
import 'package:app/screens/splashscreen.dart';
import 'package:app/screens/uploadscreen.dart';
import 'package:app/screens/videolistscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app/screens/verificationscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          create: (ctx) => ShareData(),
        )
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'InriaSans'),
          home: FingerprintPage(),
          builder: (context, widget) {
            return MediaQuery(
              //Setting font does not change with system font size
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),

              child: widget!,
            );
          },
          routes: {
            SplashScreen.routName: (ctx) => const SplashScreen(),
            SignupScreen.routeName: (ctx) => const SignupScreen(),
            LoginScreen.routeName: (ctx) => const LoginScreen(),
            VideoListScreen.routeName: (ctx) => const VideoListScreen(),
            UploadScreen.routeName: (ctx) => const UploadScreen(),
            ContactListScreen.routeName: (ctx) => const ContactListScreen(),
            ShareVideoListScreen.routeName: (ctx) =>
                const ShareVideoListScreen(),
            FavoriteContactListScreen.routeName: (ctx) =>
                const FavoriteContactListScreen(),
            ProfileScreen.routeName: (ctx) => const ProfileScreen(),
            VerificationEmailScreen.routeName: (ctx) =>
                const VerificationEmailScreen(),
            ForgetPasswordScreen.routeName: (ctx) => ForgetPasswordScreen(),
            InvitationScreen.routeName: (ctx) => InvitationScreen(),
            SettingsScreen.routeName: (ctx) => SettingsScreen()
          },
        ),
      ),
    );
  }
}
