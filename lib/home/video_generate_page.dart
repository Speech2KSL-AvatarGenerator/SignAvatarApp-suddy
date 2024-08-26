import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class VideoGeneratorPage extends StatefulWidget {
  @override
  _VideoGeneratorPageState createState() => _VideoGeneratorPageState();
}

class _VideoGeneratorPageState extends State<VideoGeneratorPage> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = '';
  VideoPlayerController? _videoController;
  List<String> _videoPaths = [];

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {});
    } else {
      print("The user has denied the use of speech recognition.");
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _text = result.recognizedWords;
            });
          },
          listenFor: Duration(seconds: 30),
          pauseFor: Duration(seconds: 5),
          partialResults: false,
          onSoundLevelChange: (level) => print(level),
          cancelOnError: true,
          listenMode: stt.ListenMode.confirmation,
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      _convertTextToVideo();
    }
  }

  Future<void> _convertTextToVideo() async {
    List<String> words = _text.split(" ");
    _videoPaths.clear();

    for (var word in words) {
      String videoPath = 'assets/videos/${word.toLowerCase()}.mp4';
      try {
        await rootBundle.load(videoPath);
        _videoPaths.add(videoPath);
      } catch (e) {
        print("Video for '$word' not found.");
      }
    }

    if (_videoPaths.isNotEmpty) {
      _playVideos();
    } else {
      print("No matching videos found.");
    }
  }

  void _playVideos() {
    if (_videoPaths.isEmpty) return;

    _videoController?.dispose();
    _videoController = VideoPlayerController.asset(_videoPaths.first)
      ..initialize().then((_) {
        setState(() {});
        _videoController!.play();
        _videoController!.addListener(() {
          if (_videoController!.value.position >= _videoController!.value.duration) {
            _playNextVideo();
          }
        });
      });
  }

  void _playNextVideo() {
    if (_videoPaths.isNotEmpty) {
      _videoPaths.removeAt(0);
      if (_videoPaths.isNotEmpty) {
        _playVideos();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Generator')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _listen,
            child: Text(_isListening ? 'Stop Listening' : 'Start Listening'),
          ),
          Text('Recognized words: $_text'),
          _videoController != null && _videoController!.value.isInitialized
              ? AspectRatio(
            aspectRatio: _videoController!.value.aspectRatio,
            child: VideoPlayer(_videoController!),
          )
              : Container(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }
}