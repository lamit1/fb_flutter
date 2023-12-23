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
  late VideoPlayerController videoController;
  late FlickManager flickManager;
  double aspectRatio = 16 / 9; // Default aspect ratio

  @override
  void initState() {
    super.initState();
    videoController = VideoPlayerController.network(widget.videoUrl);

    videoController.initialize().then((_) {
      if (mounted) {
        setState(() {
          aspectRatio = videoController.value.aspectRatio;
        });
      }
    });

    setUpVideoController();
  }

  void setUpVideoController() {
    flickManager = FlickManager(
      videoPlayerController: videoController,
      autoPlay: false,
      autoInitialize: true,
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    videoController.dispose(); // Dispose of the video controller as well
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: FlickVideoPlayer(flickManager: flickManager),
    );
  }
}
