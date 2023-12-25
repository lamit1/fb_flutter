import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController videoController = VideoPlayerController.network(widget.videoUrl);
  late FlickManager flickManager = FlickManager(
  videoPlayerController: videoController,
  autoPlay: false,
  autoInitialize: true,
  );
  double aspectRatio = 16 / 9; // Default aspect ratio

  @override
  void initState() {
    super.initState();
    videoController.initialize().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    flickManager.dispose();
    videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: videoController.value.aspectRatio,
      child: FlickVideoPlayer(flickManager: flickManager),
    );
  }
}
