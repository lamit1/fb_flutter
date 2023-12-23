import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  ChewieController? _chewieController;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );
    await _controller.initialize(
    );
    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _controller,
        autoPlay: false,
        looping: true,
        showControls: false,
        allowFullScreen: true,
        materialProgressColors: ChewieProgressColors(backgroundColor: Colors.red,bufferedColor: Colors.red,
            handleColor: Colors.blue,playedColor: Colors.orange),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: Column(
        children: [
          Expanded(
            child: Chewie(
              controller: _chewieController!,
            ),
          ),
          Container(
            color: Colors.black54,
            padding: const EdgeInsets.all(8),
            child: Row(
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
                Text(
                  '${formatDuration(_controller.value.position)} / ${formatDuration(_chewieController!.videoPlayerController.value.duration)}',
                  style: const TextStyle(color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(Icons.replay_5),
                  onPressed: () {
                    setState(() {

                      _controller.seekTo(
                          _controller.value.position - const Duration(seconds: 5));
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.forward_5),
                  onPressed: () {
                    setState(() {
                      _controller.seekTo(
                          _controller.value.position + const Duration(seconds: 5));
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formatDuration(Duration duration) {
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}
