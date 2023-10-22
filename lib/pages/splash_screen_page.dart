import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:contact_list_app/pages/contact_list_page.dart';
import 'package:flutter/material.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {

  @override
  void initState() {
    super.initState();
    _openHomePage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _openHomePage() {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const ContactListPage();
      }));
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.cyan.shade200, Colors.cyanAccent.shade700],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'My Contacts',
                  textStyle: const TextStyle(
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
