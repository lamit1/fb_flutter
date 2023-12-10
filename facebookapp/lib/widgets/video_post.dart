import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      widget.videoUrl,
    )..initialize().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return CircularProgressIndicator(); // Or any loading indicator
    }
    return Column(
      children: [
        Container(
          width: 500,
          height: 400,
          child: VideoPlayer(_controller),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: () {
                setState(() {
                  isPlaying ? _controller.pause() : _controller.play();
                  isPlaying = !isPlaying;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.stop),
              onPressed: () {
                setState(() {
                  _controller.pause();
                  _controller.seekTo(Duration.zero);
                  isPlaying = false;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.replay_10),
              onPressed: () {
                setState(() {
                  _controller.seekTo(
                      _controller.value.position - Duration(seconds: 10));
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.forward_10),
              onPressed: () {
                setState(() {
                  _controller.seekTo(
                      _controller.value.position + Duration(seconds: 10));
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
