import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:canteen_management/main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void openCameraPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CameraPage()),
    );
  }

  void openImagePickerPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ImagePickerPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => openCameraPage(context),
              child: Text("Open Camera"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => openImagePickerPage(context),
              child: Text("Upload Image"),
            ),
          ],
        ),
      ),
    );
  }
}

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? cameraController;
  bool isCameraOpen = false;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  void initCamera() {
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    cameraController!.initialize().then((_) {
      if (!mounted) return;
      setState(() {
        isCameraOpen = true;
      });
    });
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Camera")),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: isCameraOpen && cameraController != null && cameraController!.value.isInitialized
                  ? CameraPreview(cameraController!)
                  : CircularProgressIndicator(),
            ),
          ),
          SizedBox(height: 20), // Added space below camera preview
        ],
      ),
    );
  }
}

class ImagePickerPage extends StatefulWidget {
  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  @override
  void initState() {
    super.initState();
    pickImage();
  }

  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Image")),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _image != null
                  ? Image.file(_image!, height: 500) // Increased image size
                  : CircularProgressIndicator(),
            ),
          ),
          SizedBox(height: 20), // Added space below the image
        ],
      ),
    );
  }
}
