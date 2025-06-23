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
  bool _isLandscape = false;
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
    });
    _controller.setLooping(true);
    _startHideTimer();
  }

  void _startHideTimer() {
    _hideControlsTimer?.cancel();
    if (_isLandscape) {
      _hideControlsTimer = Timer(const Duration(seconds: 7), () {
        if (mounted && _isLandscape) {
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  void _toggleOrientation() {
    setState(() {
      _isLandscape = !_isLandscape;
      _showControls = true;
      if (_isLandscape) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        _startHideTimer();
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _currentIcon = Icons.play_arrow;
      } else {
        _controller.play();
        _currentIcon = Icons.pause;
      }
      _showIcon = true;
      if (_isLandscape) {
        _showControls = true;
        _startHideTimer();
      }
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
    final progressBarHeight = 20.0; // Approximate height of the progress bar

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          if (_isLandscape) {
            _toggleControlsVisibility();
          } else {
            _togglePlayPause();
          }
        },
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

            // Portrait Mode Controls
            if (!_isLandscape) ...[
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

              // Fullscreen Icon at bottom right in portrait
              Positioned(
                bottom: 20,
                right: 20,
                child: IconButton(
                  icon: const Icon(
                    Icons.fullscreen,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: _toggleOrientation,
                ),
              ),

              // Right Side Icons above fullscreen icon
              // (flame, episodes, share)
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

            // Landscape Mode Controls
            if (_isLandscape && _showControls) ...[
              // Back Button top left
              Positioned(
                top: 20,
                left: 20,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),

              // Action Icons arranged horizontally at top right in landscape
              Positioned(
                top: 20,
                right: 20,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset('assets/Icons/flame.svg'),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: _showEpisodePopup,
                      child: SvgPicture.asset('assets/Icons/episodes.svg'),
                    ),
                    const SizedBox(width: 15),
                    SvgPicture.asset('assets/Icons/share.svg'),
                  ],
                ),
              ),

              // Fullscreen exit icon bottom right
              Positioned(
                bottom: 10,
                right: 20,
                child: IconButton(
                  icon: const Icon(
                    Icons.fullscreen_exit,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: _toggleOrientation,
                ),
              ),

              // Smaller play/pause button above left side of progress bar
              Positioned(
                bottom: progressBarHeight + 30,
                left: 20,
                child: IconButton(
                  icon: Icon(
                    _currentIcon,
                    color: Colors.white,
                    size: 40,
                  ),
                  onPressed: _togglePlayPause,
                ),
              ),
            ],

            // Progress Bar (always visible in portrait, conditionally in landscape)
            Positioned(
              bottom: _isLandscape ? 10 : 50,
              left: 0,
              right: 0,
              child: _controller.value.isInitialized
                  ? AnimatedOpacity(
                      opacity: (!_isLandscape || _showControls) ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                          playedColor: Colors.white,
                          backgroundColor: Colors.white24,
                          bufferedColor: Colors.grey,
                        ),
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