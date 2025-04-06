import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:canteen_management/main.dart';
import 'package:canteen_management/api_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
      MaterialPageRoute(builder: (context) => const CameraPage()),
    );
  }

  void openImagePickerPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ImagePickerPage()),
    );
  }

  void openVideoPickerPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VideoPickerPage()),
    );
  }

  void openLiveView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LiveStreamPage()),
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
              child: const Text("Open Camera"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => openImagePickerPage(context),
              child: const Text("Upload Image"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => openVideoPickerPage(context),
              child: const Text("Upload Video"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => openLiveView(context),
              child: const Text("Live View"),
            ),
          ],
        ),
      ),
    );
  }
}

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
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
      appBar: AppBar(title: const Text("Camera")),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: isCameraOpen &&
                  cameraController != null &&
                  cameraController!.value.isInitialized
                  ? CameraPreview(cameraController!)
                  : const CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}

class ImagePickerPage extends StatefulWidget {
  const ImagePickerPage({super.key});

  @override
  State<ImagePickerPage> createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String uploadStatus = '';
  String? processedImageUrl;

  @override
  void initState() {
    super.initState();
    pickImage();
  }

  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File image = File(pickedFile.path);
      setState(() {
        _image = image;
        uploadStatus = "Uploading...";
        processedImageUrl = null;
      });

      // Get result from API
      final Map<String, dynamic> result = await ApiService.uploadImage(image);

      final uploadedFilename = result['filename'] ?? 'N/A';
      final occupiedCount = result['occupied_count']?.toString() ?? 'N/A';
      final emptyCount = result['empty_count']?.toString() ?? 'N/A';
      final resultImageUrl = result['result_image_url'];

      setState(() {
        uploadStatus = '📄 Uploaded: $uploadedFilename\n🟥 Occupied: $occupiedCount | 🟩 Empty: $emptyCount';
        processedImageUrl = resultImageUrl;
      });
    }
  }

  Widget buildImageSection(String title, Widget imageWidget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: imageWidget,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Image")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_image != null)
              buildImageSection(
                "🖼️ Original Image",
                Image.file(_image!, height: 200, fit: BoxFit.cover),
              ),
            if (processedImageUrl != null)
              buildImageSection(
                "✅ Processed Image",
                Image.network(
                  processedImageUrl!,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('⚠️ Failed to load processed image.'),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Text(
              uploadStatus,
              style: TextStyle(
                fontSize: 16,
                color: uploadStatus.toLowerCase().contains('failed') ? Colors.red : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: pickImage,
              icon: const Icon(Icons.image_search),
              label: const Text("Pick Another Image"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPickerPage extends StatefulWidget {
  const VideoPickerPage({super.key});

  @override
  State<VideoPickerPage> createState() => _VideoPickerPageState();
}

class _VideoPickerPageState extends State<VideoPickerPage> {
  final ImagePicker _picker = ImagePicker();
  File? _video;
  String uploadStatus = '';

  @override
  void initState() {
    super.initState();
    pickVideo();
  }

  Future<void> pickVideo() async {
    final XFile? pickedFile =
    await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      File video = File(pickedFile.path);
      setState(() => _video = video);
      final result = await ApiService.uploadVideo(video);
      setState(() {
        uploadStatus = result.containsKey('error')
            ? result['error']
            : "Video uploaded: ${result['filename']}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Video")),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _video != null
                  ? Text("Selected video: ${_video!.path.split('/').last}")
                  : const CircularProgressIndicator(),
            ),
          ),
          const SizedBox(height: 10),
          Text(uploadStatus),
        ],
      ),
    );
  }
}

class LiveStreamPage extends StatelessWidget {
  const LiveStreamPage({super.key});

  @override
  Widget build(BuildContext context) {
    final liveUrl = ApiService.getLiveStreamUrl();

    return Scaffold(
      appBar: AppBar(title: const Text("Live Stream")),
      body: WebViewWidget(
        controller: WebViewController()
          ..loadRequest(Uri.parse(liveUrl))
          ..setJavaScriptMode(JavaScriptMode.unrestricted),
      ),
    );
  }
}
