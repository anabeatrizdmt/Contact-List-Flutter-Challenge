import 'package:contact_list_app/pages/splash_screen_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: const SplashScreenPage(),
        theme: ThemeData(
          primarySwatch: Colors.cyan,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ));
  }
}
