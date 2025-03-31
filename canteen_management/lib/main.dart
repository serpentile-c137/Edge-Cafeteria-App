import 'package:canteen_management/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras = <CameraDescription>[];

// void main() {
//   runApp(const MyApp());
// }

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:  SplashScreen(),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}


