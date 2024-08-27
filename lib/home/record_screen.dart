// 이 페이지를 홈과 연결

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';

import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:suddy/home/video_app.dart';
import 'package:suddy/home/video_generate_page.dart';
import 'package:suddy/home/video_player_screen.dart';
import 'package:video_player/video_player.dart';

import '../model/script.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final _formKey = GlobalKey<FormState>();
  List<String> _videoPaths = []; // List to store video paths
  int _currentVideoIndex = 0; // Index of the currently playing video

  final db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  Uint8List? imageData;
  XFile? image;
  VideoPlayerController? _videoController;

  TextEditingController titleTEC = TextEditingController();
  TextEditingController contentTEC = TextEditingController();

  // Speech-to-text related variables
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _speechText = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  // Function to start listening to speech
  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) => setState(() {
          _speechText = val.recognizedWords;
          contentTEC.text = _speechText;
        }),
      );
    }
  }

  // Function to stop listening to speech
  void _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("영상으로 변환할까요?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("취소"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _convertTextToVideo(); // 영상 변환 함수 호출
              },
              child: Text("확인"),
            ),
          ],
        );
      },
    );
  }

  // Image compression function
  Future<Uint8List> imageCompressList(Uint8List list) async {
    try {
      var result =
      await FlutterImageCompress.compressWithList(list, quality: 50);
      return result;
    } catch (e) {
      print("Image compression error: $e");
      rethrow;
    }
  }

  String _convertToEnglish(String word) {
    if (RegExp(r'^걱정').hasMatch(word)) return 'worry';
    if (RegExp(r'^많').hasMatch(word)) return 'many';
    if (RegExp(r'^같').hasMatch(word)) return 'same';
    if (RegExp(r'^오늘').hasMatch(word)) return 'today';
    if (RegExp(r'^이번').hasMatch(word)) return 'thistime';
    // 다른 단어도 동일하게 처리
    return word;
  }

  // Function to convert the speech text to video
  Future<void> _convertTextToVideo() async {
    List<String> words = _speechText.split(" ");
    _videoPaths.clear();
    // List<String> videoPaths = [];

    // 영상 파일을 불러와 연결하는 작업
    for (var word in words) {
      String videoPath = 'videos/${_convertToEnglish(word)}.webm';
      try {
        videoPath = Uri.decodeComponent(videoPath);

        // 해당 단어에 맞는 영상 파일이 있는지 확인
        await rootBundle.load(videoPath);
        _videoPaths.add(videoPath);
      } catch (e) {
        print("Video for '$word' not found.");
      }
    }

    if (_videoPaths.isNotEmpty) {
      // 연결된 영상들을 재생 (여기서는 첫 번째 영상만 예시로 재생)
      //_playVideo(videoPaths.first);
      _currentVideoIndex = 0;
      await _playVideo(_videoPaths[_currentVideoIndex]);
      // for (var path in videoPaths) {
      //   await _playVideo(path);
      // }
    } else {
      print("No matching videos found.");
    }
  }

  Future<void> _playVideo(String videoPath) async {
    try {
      // 비디오 컨트롤러 생성 및 초기화
      _videoController = VideoPlayerController.asset(videoPath);

      await _videoController!.initialize();
      setState(() {}); // 화면 업데이트를 위해 호출
      _videoController!.play();

      // 비디오가 끝날 때 다음 비디오를 재생
      // _videoController!.addListener(_videoListener);
      _videoController!.addListener(() async {
        if (_videoController!.value.position ==
            _videoController!.value.duration) {
          _videoController!.removeListener(() {}); // Remove listener
          // _videoController!.dispose(); // Dispose of the controller
          // setState(() {
          //   _videoController = null; // Set controller to null
          // });
          await _playNextVideo();
        }
      });
    } catch (e, stackTrace) {
      print("Error playing video: $e");
      print("Stack Trace: $stackTrace");
    }
  }

  // Function to play the next video in the list
  Future<void> _playNextVideo() async {
    _currentVideoIndex++;
    if (_currentVideoIndex < _videoPaths.length) {
      await _videoController!.dispose(); // Dispose of the previous controller
      await _playVideo(_videoPaths[_currentVideoIndex]); // Play the next video
    } else {
      print("All videos played.");
    }
  }

  void _videoListener() {
    if (_videoController != null &&
        _videoController!.value.position == _videoController!.value.duration) {
      _videoController!.removeListener(_videoListener); // 리스너 제거
      _videoController!.pause();
      _videoController!.dispose(); // 현재 비디오 컨트롤러를 정리
      setState(() {
        _videoController = null; // 컨트롤러를 null로 설정
      });
    }
  }

  // @override
  // void dispose() {
  //   // 위젯이 폐기될 때 컨트롤러를 정리
  //   if (_videoController != null) {
  //     _videoController!.removeListener(_videoListener);
  //     _videoController!.dispose();
  //   }
  //   super.dispose();
  // }
  @override
  void dispose() {
    // Dispose of the video controller if it exists
    _videoController?.dispose();
    super.dispose();
  }



  Future<String?> combineVideos(List<String> videoPaths) async {
    String outputFile = '/path/to/output/video.mp4';

    String inputCommand = videoPaths.map((path) => '-i $path').join(' ');

    String filterComplex = videoPaths
        .asMap()
        .entries
        .map((entry) => '[$entry.key:v] [$entry.key:a]')
        .join(' ') +
        ' concat=n=${videoPaths.length}:v=1:a=1 [v] [a]';

    String command = '$inputCommand -filter_complex "$filterComplex" -map "[v]" -map "[a]" $outputFile';

    final session = await FFmpegKit.execute(command);

    final returnCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      return outputFile;
    } else {
      print('FFmpeg failed to combine videos');
      return null;
    }
  }

  Future<String?> uploadCombinedVideo(String videoPath) async {
    try {
      final storageRef = storage.ref().child("videos/${DateTime.now().millisecondsSinceEpoch}_combined.webm");
      await storageRef.putFile(File(videoPath)); // No need to store in a variable
      String downloadUrl = await storageRef.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print("Failed to upload video: $e");
      return null;
    }
  }

  Future<List<String>> uploadVideos(List<String> videoPaths) async {
    List<String> videoUrls = [];

    for (String videoPath in videoPaths) {
      try {
        final storageRef = storage.ref().child("videos/${DateTime.now().millisecondsSinceEpoch}_${videoPath.split('/').last}");
        await storageRef.putFile(File(videoPath)); // Upload each video to Firebase Storage
        String downloadUrl = await storageRef.getDownloadURL();
        videoUrls.add(downloadUrl);
      } catch (e) {
        print("Failed to upload video: $e");
      }
    }

    return videoUrls;
  }


  // Function to add a single script to Firestore
  Future<void> addScript() async {
    if (_videoPaths.isEmpty) {
      print("No video path available.");
      return;
    }

    // Upload the videos to Firebase Storage
    List<String> videoUrls = await uploadVideos(_videoPaths);

    // String? combinedVideoPath = await combineVideos(_videoPaths);
    // if (combinedVideoPath == null) {
    //   print("Failed to combine videos.");
    //   return;
    // }

    // Upload the combined video to Firebase Storage
    // String? videoUrl = await uploadCombinedVideo(combinedVideoPath);
    // if (videoUrl == null) {
    //   print("Failed to upload the combined video.");
    //   return;
    // }

    // Prepare the script object
    final sampleData = Script(
      title: titleTEC.text,
      content: contentTEC.text,
      videoUrls: videoUrls,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    // try {
    //   final storageRef = storage.ref().child(
    //       "${DateTime.now().millisecondsSinceEpoch}_${image?.name ?? "unknown"}.jpg");
    //   await storageRef.putData(imageData!);
    //
    //   final downloadLink = await storageRef.getDownloadURL();
    //   final sampleData = Script(
    //     title: titleTEC.text,
    //     content: contentTEC.text,
    //     videoUrl: downloadLink,
    //     timestamp: DateTime.now().millisecondsSinceEpoch,
    //   );
    //
    //   final doc = await db.collection("scripts").add(sampleData.toJson());
    //   print("Document added with ID: ${doc.id}");
    //
    //   // Show a snackbar indicating success
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Save completed')),
    //   );
    //
    //   // Navigate back to the previous page and refresh it
    //   Navigator.of(context)
    //       .pop(true); // Passing true indicates a successful save
    // } catch (e) {
    //   print("Firebase error: $e");
    // }
    // Save the script to Firestore
    try {
      final doc = await db.collection("scripts").add(sampleData.toJson());
      print("Document added with ID: ${doc.id}");

      // Show a snackbar indicating success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Save completed')),
      );

      // Navigate back to the previous page and refresh it
      Navigator.of(context).pop(true);
    } catch (e) {
      print("Firebase error: $e");
    }
  }

  Widget _buildVideoPlayer() {
    if (_videoController == null) {
      return Container(
        height: 500,
        width: 500,
        color: Colors.grey,
        child: Center(child: Text("영상 없음")),
      );
    }

    return Container(
      height: 500,
      width: 500,
      child: _videoController!.value.isInitialized
          ? AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: VideoPlayer(_videoController!),
      )
          : Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "새 대화",
          style: TextStyle(
              color: Colors.white, fontFamily: 'YourSoftFont', fontSize: 24),
        ),
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => VideoPlayerScreen()),
              );
            },
            icon: Icon(Icons.camera),
          ),
          IconButton(
            onPressed: () {
              addScript(); // Save the script to Firebase
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: _buildVideoPlayer(),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text("정보"),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleTEC,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "제목",
                          hintText: "제목을 입력하세요"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "This field is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: contentTEC,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "텍스트",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "This field is required";
                              }
                              return null;
                            },
                            maxLength: 254,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isListening ? Icons.mic_off : Icons.mic,
                            color: _isListening ? Colors.red : Colors.blue,
                          ),
                          onPressed:
                          _isListening ? _stopListening : _startListening,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    // Other form fields (commented out)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
