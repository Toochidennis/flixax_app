import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoPage extends StatefulWidget {
  final String videoPath;

  const FullScreenVideoPage({super.key, required this.videoPath});

  @override
  _FullScreenVideoPageState createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<FullScreenVideoPage> {
  late VideoPlayerController _controller;

bool _showIcon = false;
IconData _currentIcon = Icons.play_arrow;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      })
      ..setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: _controller.value.isInitialized
                ? GestureDetector(
                  onTap: () {
  setState(() {
    if (_controller.value.isPlaying) {
      _controller.pause();
      _currentIcon = Icons.pause;
    } else {
      _controller.play();
      _currentIcon = Icons.play_arrow;
    }
    _showIcon = true;
  });

  Future.delayed(Duration(milliseconds: 500), () {
    if (mounted) {
      setState(() {
        _showIcon = false;
      });
    }
  });
},
 child: VideoPlayer(_controller),
                  )
                : Center(child: CircularProgressIndicator()),
          ),
if (_showIcon)
  Center(
    child: AnimatedOpacity(
      opacity: _showIcon ? 1.0 : 0.0,
      duration: Duration(milliseconds: 200),
      child: Icon(
        _currentIcon,
        size: 80,
        color: Colors.white,
      ),
    ),
  ),

          Positioned(
            top: 40,
            left: 20,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(Icons.arrow_back_ios,
                     color: Colors.white, 
                     size:24),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'Professor Adrian and Saraphina',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Nuhnito',
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(width: 90),
                Icon(
                  Icons.more_vert,
                  color: Colors.white,
                )
              ],
            ),
          ),
          Positioned(
            bottom: 150,
            right: 20,
            child: Column(
              children: [
               SvgPicture.asset(
                'assets/Icons/flame.svg'
               ),
                SizedBox(height: 10),
                 SvgPicture.asset(
                'assets/Icons/episodes.svg'
               ),
                SizedBox(height: 10),
                SvgPicture.asset(
                'assets/Icons/share.svg'
               ),
              ],
            ),
          ),
        Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: _controller.value.isInitialized
              ? VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                  colors: VideoProgressColors(
                    playedColor: Colors.white,
                    backgroundColor: Colors.white24,
                    bufferedColor: Colors.grey,
                  ),
                )
              : SizedBox.shrink(),
        ),
        ],
      ),
    );
  }
}
