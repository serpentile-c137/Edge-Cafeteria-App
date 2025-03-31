import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:canteen_management/home_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Center(
          child: Lottie.asset('assets/Animation1.json'),
        ),
        nextScreen: MyHomePage(title: 'Canteen Crowd Detector'),
      splashIconSize: 400,
      backgroundColor: Colors.black,
      duration: 5000,
    );
  }
}
