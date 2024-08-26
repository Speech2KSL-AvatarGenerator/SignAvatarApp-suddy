import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

Future<String> getVideoUrl(String filePath) async {
  final storageRef = FirebaseStorage.instance.ref().child(filePath);
  final url = await storageRef.getDownloadURL();
  return url;
}




class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  final String _videoPath = 'gs://suddy-ea5fa.appspot.com/hello.webm'; // Firebase Storage에 저장된 비디오 경로

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      final videoUrl = await getVideoUrl(_videoPath);
      _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
        ..initialize().then((_) {
          setState(() {});
          _controller!.play();
        }).catchError((e) {
          print("Video initialization error: $e");
        });
    } catch (e) {
      print("Error getting video URL: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Player"),
      ),
      body: Center(
        child: _controller != null && _controller!.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: VideoPlayer(_controller!),
        )
            : CircularProgressIndicator(),
      ),
    );
  }
}
