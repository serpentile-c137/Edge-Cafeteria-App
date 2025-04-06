import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:canteen_management/api_service.dart';
import 'package:canteen_management/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkApiAndNavigate();
  }

  Future<void> _checkApiAndNavigate() async {
    try {
      await ApiService.ping(); // ✅ Calls your GET /
      await Future.delayed(const Duration(seconds: 2)); // Optional: keep splash duration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const MyHomePage(title: 'Canteen Crowd Detector')),
      );
    } catch (e) {
      // Handle error (show dialog or retry)
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Unable to connect to the API.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Lottie.asset('assets/Animation1.json', width: 300),
      ),
    );
  }
}
