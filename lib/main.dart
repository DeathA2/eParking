import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:testapp/constants.dart';
import 'package:testapp/screen/screen_welc/welcome.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Login",
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const WelcomeScreen(),
      localizationsDelegates: const [
        MonthYearPickerLocalizations.delegate
      ],
    );
  }
}
