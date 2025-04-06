import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {
  static const String baseUrl = 'https://serpentilec137-fastapi-server.hf.space';

  static Future<String> ping() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body).toString();
      } else {
        return 'Ping failed';
      }
    } catch (e) {
      return 'Ping error: $e';
    }
  }

  static Future<Map<String, dynamic>> uploadImage(File imageFile) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload'));

      final mimeType = imageFile.path.endsWith('.png')
          ? MediaType('image', 'png')
          : MediaType('image', 'jpeg');

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: mimeType,
      ));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final decoded = jsonDecode(responseBody);
        return decoded; // Returning full map
      } else {
        return {'error': 'Upload image failed: ${response.statusCode}'};
      }
    } catch (e) {
      return {'error': 'Upload image error: $e'};
    }
  }

  static Future<Map<String, dynamic>> uploadVideo(File videoFile) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload_video'));

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        videoFile.path,
        contentType: MediaType('video', 'mp4'),
      ));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final decoded = jsonDecode(responseBody);
        return decoded; // Returning full map
      } else {
        return {'error': 'Upload video failed: ${response.statusCode}'};
      }
    } catch (e) {
      return {'error': 'Upload video error: $e'};
    }
  }

  static String getLiveStreamUrl() {
    return '$baseUrl/live';
  }
}
