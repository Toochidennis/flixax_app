import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';
import 'fullscreen.dart';

class MainVideoFeed extends StatefulWidget {
  const MainVideoFeed({super.key});

  @override
  _MainVideoFeedState createState() => _MainVideoFeedState();
}

class _MainVideoFeedState extends State<MainVideoFeed> {
  final List<String> videoPaths = [
    'assets/video/vid1.mp4',
    'assets/video/vid2.mp4',
    'assets/video/vid3.mp4',
    'https://encrypted-vtbn0.gstatic.com/video?q=tbn:ANd9GcQ5SoLkERO1k1HYab-cjqB8vlXPig3N17Ei0Q'
  ];

  void _showEpisodesOverlay(BuildContext context, String videoPath) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black.withOpacity(0.9),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child:
                 Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Text(
                "Professor Adrian and Saraphina",
                style: TextStyle(
                  color: Colors.white,
                   fontSize: 20, 
                   fontWeight: FontWeight.w500,
                   fontFamily: 'Nunito'
                   ),
              ),
              SizedBox(height: 5),
              Container(
                color: Color.fromRGBO(55,255,255,0.13),
                width: 123,
                height: 16,
                child: Text(
                  'No. 1 Most Watched',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    fontWeight: FontWeight.w400
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color.fromRGBO(255,190,0,1),
                        Color.fromRGBO(255,85,253,1), 
                        Color.fromRGBO(127,187,255,1), 
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    blendMode: BlendMode.srcIn,
                    child: const Text(
                      '1-24',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontFamily: 'Nunito'
                      ),
                    ),
                  ),
                 const SizedBox(width: 6),
                  const Text(
                    '|',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white54,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    '24-48',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontFamily: 'Nunito'
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              GridView.builder(
                physics:NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.01,
                ),
                
                itemCount: 24,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenVideoPage(videoPath: videoPath),
                        ),
                      );
                    },
                    child: Container(
                      
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(250,82,140,1),
                        borderRadius: BorderRadius.circular(4),
                        
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(
                          color: Colors.white,
                           fontSize: 20, 
                           fontWeight: FontWeight.w500,
                           fontFamily: 'Nunito'
                           ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: videoPaths.length,
        itemBuilder: (context, index) {
          return VideoItem(
            videoPath: videoPaths[index],
            onEpisodeTap: () => _showEpisodesOverlay(context, videoPaths[index]),
          );
        },
      ),
    );
  }
}

class VideoItem extends StatefulWidget {
  final String videoPath;
  final VoidCallback onEpisodeTap;

  const VideoItem({super.key, required this.videoPath, required this.onEpisodeTap});

  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late VideoPlayerController _controller;


bool _showIcon = false;
IconData _currentIcon = Icons.play_arrow;

 @override
void initState() {
  super.initState();

  if (widget.videoPath.startsWith('http')) {
    _controller = VideoPlayerController.network(widget.videoPath);
  } else {
    _controller = VideoPlayerController.asset(widget.videoPath);
  }

  _controller
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
    return Stack(
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
            duration: const Duration(milliseconds: 200),
            child: Icon(
              _currentIcon,
              size: 80,
              color: Colors.white,
            ),
          ),
        ),

        
        Positioned(
          bottom: 120,
          right: 20,
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/Icons/flame.svg',
                width: 40,
                height:54
                ),
              SizedBox(height: 13),
              SvgPicture.asset(
                'assets/Icons/episodes.svg',
                width: 58,
                height:54
                ),
            ],
          ),
        ),
         Positioned(
           bottom: 70,
            child:Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text("Professor Adrian and Sar...", style:
                     TextStyle(color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w700
                      )),
            ), 
         ),
        Positioned(
          bottom: 20,
          child:
            GestureDetector(
              onTap: widget.onEpisodeTap,
              child: 
           Container(
            color: const Color.fromRGBO(91,91,91,0.3),
            width:600 ,
            height: 40,
            child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: SvgPicture.asset(
                      'assets/Icons/episodes2.svg',
                      width: 24,
                      height: 24,
                    )
                  ),
                  SizedBox(width: 8),
                  Text("EP.2/EP.40", style:
                   TextStyle(color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w500
                    )),
                  SizedBox(width:255),
                  Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,)
                ],
              ),
          ),)
        ),
        Positioned(
          bottom: 0,
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
    );
  }
}
