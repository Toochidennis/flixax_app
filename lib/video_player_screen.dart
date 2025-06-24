import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoPage extends StatefulWidget {
  final String videoUrl;
  final String title;
  final bool isAsset;

  const FullScreenVideoPage({
    super.key,
    required this.videoUrl,
    required this.title,
    this.isAsset = false,
  });

  @override
  _FullScreenVideoPageState createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<FullScreenVideoPage> {
  late VideoPlayerController _controller;
  bool _showIcon = false;
  IconData _currentIcon = Icons.play_arrow;
  bool _showControls = true;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _controller = widget.isAsset
        ? VideoPlayerController.asset(widget.videoUrl)
        : VideoPlayerController.network(widget.videoUrl);

    _controller.initialize().then((_) {
      setState(() {});
      _controller.play();
      _startHideTimer(); // Start the timer only after the video has started playing
    });
    _controller.setLooping(true);
  }

  void _startHideTimer() {
    _hideControlsTimer?.cancel();
    if (_controller.value.isPlaying) {
      _hideControlsTimer = Timer(const Duration(seconds: 7), () {
        if (mounted) {
          setState(() => _showControls = false);
        }
      });
    }
  }

  void _toggleControlsVisibility() {
    setState(() {
      _showControls = !_showControls;
      if (_showControls) {
        _startHideTimer();
      }
    });
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _currentIcon = Icons.play_arrow;
      } else {
        _controller.play();
        _currentIcon = Icons.pause;
        _startHideTimer(); // Restart the timer when the video is playing
      }
      _showIcon = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _showIcon = false);
      }
    });
  }

  void _showEpisodePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Episodes"),
          content: const Text("List of episodes will go here."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControlsVisibility,
        child: Stack(
          children: [
            // Video Player
            Positioned.fill(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),

            // Play/Pause Icon Overlay (center screen)
            if (_showIcon)
              Center(
                child: AnimatedOpacity(
                  opacity: _showIcon ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    _currentIcon,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),

            // Controls
            if (_showControls) ...[
              // Top Bar (left: back, center: title, right: three-dot)
              Positioned(
                top: 40,
                left: 20,
                right: 20,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.only(left: 8),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Nuhnito',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Add your action for the three-dot icon here
                      },
                      child: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              // Fullscreen Icon at bottom right
              Positioned(
                bottom: 20,
                right: 20,
                child: IconButton(
                  icon: const Icon(
                    Icons.fullscreen,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    // Toggle orientation logic can be added here if needed
                  },
                ),
              ),

              // Right Side Icons above fullscreen icon
              Positioned(
                bottom: 150,
                right: 20,
                child: Column(
                  children: [
                    SvgPicture.asset('assets/Icons/flame.svg'),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _showEpisodePopup,
                      child: SvgPicture.asset('assets/Icons/episodes.svg'),
                    ),
                    const SizedBox(height: 10),
                    SvgPicture.asset('assets/Icons/share.svg'),
                  ],
                ),
              ),
            ],

            // Progress Bar (always visible)
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: _controller.value.isInitialized
                  ? VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                        playedColor: Colors.white,
                        backgroundColor: Colors.white24,
                        bufferedColor: Colors.grey,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}