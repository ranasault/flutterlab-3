import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(DigitalPictureFrameApp());
}

class DigitalPictureFrameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PictureFrameScreen(),
    );
  }
}

class PictureFrameScreen extends StatefulWidget {
  @override
  _PictureFrameScreenState createState() => _PictureFrameScreenState();
}

class _PictureFrameScreenState extends State<PictureFrameScreen> {
  final List<String> imageUrls = [
    'https://your-bucket.s3.amazonaws.com/image1.jpg',
    'https://your-bucket.s3.amazonaws.com/image2.jpg',
    'https://your-bucket.s3.amazonaws.com/image3.jpg',
    'https://your-bucket.s3.amazonaws.com/image4.jpg',
  ];

  int _currentIndex = 0;
  Timer? _timer;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _startImageRotation();
  }

  void _startImageRotation() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (!_isPaused) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % imageUrls.length;
        });
      }
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: 300,
          height: 400,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 10),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.blueAccent, blurRadius: 15, spreadRadius: 5)
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: imageUrls[_currentIndex],
              fit: BoxFit.cover,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _togglePause,
        backgroundColor: Colors.blue,
        child: Icon(_isPaused ? Icons.play_arrow : Icons.pause, color: Colors.white),
      ),
    );
  }
}
