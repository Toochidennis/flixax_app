import 'package:flixax_app/rewards.dart';
import 'package:flixax_app/rewards2.dart';
import 'package:flutter/material.dart';
import 'dart:ui'; // Import for BackdropFilter
import 'dart:math'; // Import for Random
import 'package:video_player/video_player.dart';

Widget gradientOutlineButton({required String text, required VoidCallback onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: 100,
      height: 45,
      padding: EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(255, 190, 0, 1),
            Color.fromRGBO(255, 85, 253, 1),
            Color.fromRGBO(127, 187, 255, 1),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black, // Button background
          borderRadius: BorderRadius.circular(30),
        ),
        child: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              Color.fromRGBO(255, 190, 0, 1),
              Color.fromRGBO(255, 85, 253, 1),
              Color.fromRGBO(127, 187, 255, 1),
            ],
          ).createShader(bounds),
          child: Center(
            child: Text(
              'Skip',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Nunito',
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class SpinningAnimation extends StatefulWidget {
  @override
  _SpinningAnimationState createState() => _SpinningAnimationState();
}

class _SpinningAnimationState extends State<SpinningAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _spinController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();

    _spinController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _controller,
          child: Image.asset('assets/images/back.png'), // Renamed to back.png
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value * 6.28319, // 2 * π
              child: Transform.scale(
                scale: 2.5, // Adjust scale as needed
                child: child,
              ),
            );
          },
        ),
        Transform.scale(
          scale: 2.2, // Adjust the scale as needed
          child: Image.asset('assets/images/Coins.png'), // Renamed to Coins.png
        ),
        AnimatedBuilder(
          animation: _spinController,
          builder: (context, child) {
            double speed = 3.5;
            double opacity1 = 0.05 + 0.4 * (1 + (0.8 * sin(speed * _spinController.value * 2 * pi)));
            double opacity2 = 0.05 + 0.4 * (1 + (0.8 * sin(speed * _spinController.value * 2 * pi + 1.5)));
            double opacity3 = 0.05 + 0.4 * (1 + (0.8 * sin(speed * _spinController.value * 2 * pi + 3.0)));
            return Stack(
              children: [
                // Glitter 1 - Top left
                Positioned(
                  top: 80,  // Higher up
                  left: 20, // Further left
                  child: Opacity(
                    opacity: opacity1.clamp(0.2, 1.0),
                    child: Image.asset(
                      'assets/images/glitter.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
                // Glitter 2 - Middle left
                Positioned(
                  top: 120,
                  left: 40,
                  child: Opacity(
                    opacity: opacity2.clamp(0.2, 1.0),
                    child: Image.asset(
                      'assets/images/glitter.png',
                      width: 35,
                      height: 35,
                    ),
                  ),
                ),
                // Glitter 3 - Bottom left
                Positioned(
                  bottom: 60,
                  left: 30,
                  child: Opacity(
                    opacity: opacity3.clamp(0.2, 1.0),
                    child: Image.asset(
                      'assets/images/glitter.png',
                      width: 45,
                      height: 45,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}



class _BonusPopupContent extends StatefulWidget {
  final VoidCallback onPopupClosed;

  const _BonusPopupContent({Key? key, required this.onPopupClosed}) : super(key: key);

  @override
  _BonusPopupContentState createState() => _BonusPopupContentState();
}

class _BonusPopupContentState extends State<_BonusPopupContent> {
  //late VideoPlayerController _controller; // Remove video controller

  @override
  void initState() {
    super.initState();
    // _controller = VideoPlayerController.asset(
    //     'assets/video/treasure.webm') // Replace with your video path
    //   ..initialize().then((_) {
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {
    //       _controller.play(); // Autoplay the video
    //       _controller.setLooping(true); // Loop the video
    //     });
    //   });
  }

  @override
  void dispose() {
    super.dispose();
    //_controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color.fromRGBO(255, 190, 0, 1),
                Color.fromRGBO(255, 85, 253, 1),
                Color.fromRGBO(127, 187, 255, 1),
              ],
            ).createShader(bounds),
            child: const Text(
              'Follow us on social media',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontFamily: 'Nunito',
              ),
            ),
          ),
          const SizedBox(height: 35), // Reduced spacing above the animation
          Container(
            height: 90, // Increased height for better spacing adjustment
            width: 70, // Reduced size of the coin animation
            child: SpinningAnimation(),
          ),
          const SizedBox(height: 10), // More space between animation and bonus text
          const Text(
            '+200 Bonus',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              fontFamily: 'Nunito',
              color: Color(0xFFFFC700),
            ),
          ),
          const SizedBox(height: 5), // Add spacing below the bonus text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              gradientOutlineButton(
                text: "Skip",
                onTap: () {
                  Navigator.pop(context);
                  widget.onPopupClosed();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  widget.onPopupClosed();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Rewards(),
                    ),
                  );
                },
                child: Ink(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(255, 190, 0, 1),
                        Color.fromRGBO(255, 85, 253, 1),
                        Color.fromRGBO(127, 187, 255, 1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Container(
                    width: 100,
                    height: 45,
                    alignment: Alignment.center,
                    child: const Text(
                      'Get Reward',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void showBonusPopup(BuildContext context, {required VoidCallback onPopupClosed}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent, // Transparent dialog background
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            // BackdropFilter for blur effect
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: Colors.black.withOpacity(0),
                ),
              ),
            ),
            // Dialog content
            _BonusPopupContent(onPopupClosed: onPopupClosed),
          ],
        ),
      );
    },
  );
}