import 'dart:async';
import 'dart:math';
import 'package:flixax_app/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class Rewards extends StatefulWidget {
  const Rewards({super.key});

  @override
  _RewardsState createState() => _RewardsState();
}

class _RewardsState extends State<Rewards> with TickerProviderStateMixin {
  int bonusScore = 0;
  List<Offset> coinStartPositions = []; // List to track coin start positions
  List<Offset> coinEndPositions = []; // List to track coin end positions
  late AnimationController _controller;
  late AnimationController _spinController; // Animation controller for spinning
  late Animation<double> _spinAnimation; // Spin animation

  final GlobalKey _coinImageKey = GlobalKey(); // GlobalKey for the large coin image

   // New state variables for text style
  double _textSize = 24.0; // Original text size
  Color _textColor = Colors.white; // Original text color

  // Add this key
  final GlobalKey<_DailyCheckInState> _dailyCheckInKey = GlobalKey();

  int _completedBeginnerTasks = 0;
  final int _totalBeginnerTasks = 4; // Set this to your actual number of beginner tasks
  List<bool> _taskCompleted = [false, false, false, false]; // Track completion of each task

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(); // Infinite spinning

    _spinAnimation = Tween<double>(begin: 0, end: 1).animate(_spinController);
  }

  void _incrementBonus(int amount) {
    int targetScore = bonusScore + amount;

    // Change text size and color during increment
    setState(() {
      _textSize = 30.0; // Increase text size
      _textColor = Colors.yellow; // Change text color to yellow
    });

    Timer.periodic(Duration(milliseconds: 1), (timer) {
      if (bonusScore < targetScore) {
        setState(() {
          bonusScore++;
        });
      } else {
        timer.cancel();
        // Reset text size and color after increment
        setState(() {
          _textSize = 24.0; // Reset to original text size
          _textColor = Colors.white; // Reset to original text color
        });
      }
    });

    // Optionally, you can trigger a coin animation from the bonus score area
    // _animateCoins(Offset(20, 145));
  }

  // Animate coins from a provided position
  void _animateCoins([Offset? startPosition]) {
    Offset start = startPosition ??
        Offset(MediaQuery.of(context).size.width / 2, MediaQuery.of(context).size.height / 2 + 50);

    setState(() {
      coinStartPositions.add(start);
      coinEndPositions.add(const Offset(20, 145)); // Target position of the bonus score
    });

    _controller.forward(from: 0).then((_) {
      setState(() {
        if (coinStartPositions.isNotEmpty && coinEndPositions.isNotEmpty) {
          coinStartPositions.removeAt(0);
          coinEndPositions.removeAt(0);
        }
      });
    });
  }

  // New: Animate coins from the large coin image position
  void _animateCoinsFromLargeCoin() {
    if (_coinImageKey.currentContext != null) {
      RenderBox renderBox = _coinImageKey.currentContext!.findRenderObject() as RenderBox;
      Offset startPosition = renderBox.localToGlobal(Offset.zero);
      setState(() {
        coinStartPositions.add(startPosition);
        coinEndPositions.add(const Offset(20, 145)); // Target position of the bonus score
      });

      _controller.forward(from: 0).then((_) {
        setState(() {
          if (coinStartPositions.isNotEmpty && coinEndPositions.isNotEmpty) {
            coinStartPositions.removeAt(0);
            coinEndPositions.removeAt(0);
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _spinController.dispose(); // Dispose the spinning controller too
    super.dispose();
  }

  void _handleBeginnerTaskCompletion() {
    setState(() {
      _completedBeginnerTasks++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double blackContainerHeight = constraints.maxHeight * 0.72;

          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(237, 190, 0, 1),
                      Color.fromRGBO(248, 101, 116, 1),
                      Color.fromRGBO(250, 82, 140, 1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              // Back Button on Orange Background
              Positioned(
                top: 25,  
                left: 20,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {},
                ),
              ),
              // "Your Coins" and Coin Count Text
              Positioned(
                top: 115,
                left: 20,
                child: Text(
                  "Your Bonus:",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Nunito',
                  ),
                ),
              ),
              // Bonus Score Display (updated)
              Positioned(
                top: 145,
                left: 20,
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyle(
                    fontSize: _textSize,
                    color: _textColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                  ),
                  child: Text('$bonusScore'),
                ),
              ),              // Animated Coin and Spinning Background
              Positioned(
                top: 50, // Lower the coin (was 20)
                left: 120, // Center more if needed
                right: 0.2,
                child: SizedBox(
                  width: 320, // Increase background size
                  height: 320,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      RotationTransition(
                        turns: _spinAnimation,
                        child: Image.asset(
                          'assets/images/back.png',
                          width: 320,
                          height: 320,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Image.asset(
                        'assets/images/Coins.png',
                        width: 240, // Increase coin size
                        height: 220,
                        key: _coinImageKey, // Keep this key for the coin animation start point
                        ),
                        // Add glitter image with positioned widget for custom placement
                        // Animated glitter images that gently fade in and out
                        AnimatedBuilder(
                          animation: _spinController,
                          builder: (context, child) {
                            // Use a sine wave for smooth fade in/out, phase-shift for each glitter
                            double speed = 3.5; // Increase speed (was 1.0)
                            double opacity1 = 0.05 + 0.4 * (1 + 
                              (0.8 * (
                                sin(speed * _spinController.value * 2 * 3.1415926535)
                              ))
                            );
                            double opacity2 = 0.05 + 0.4 * (1 + 
                              (0.8 * (
                                sin(speed * _spinController.value * 2 * 3.1415926535 + 1.5)
                              ))
                            );
                            double opacity3 = 0.05 + 0.4 * (1 + 
                              (0.8 * (
                                sin(speed * _spinController.value * 2 * 3.1415926535 + 3.0)
                              ))
                            );
                            return Stack(
                              children: [
                                Positioned(
                                  top: 100,
                                  right: 40,
                                  left: 20,
                                  child: Opacity(
                                    opacity: opacity1.clamp(0.2, 1.0),
                                    child: Image.asset(
                                      'assets/images/glitter.png',
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 100,
                                  right: 40,
                                  child: Opacity(
                                    opacity: opacity2.clamp(0.2, 1.0),
                                    child: Image.asset(
                                      'assets/images/glitter.png',
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 140,
                                  right: 40,
                                  left: 90,
                                  child: Opacity(
                                    opacity: opacity3.clamp(0.2, 1.0),
                                    child: Image.asset(
                                      'assets/images/glitter.png',
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
              // Second Layer - Black Overlay with Rounded Corners (raised from bottom)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: blackContainerHeight,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  // Wrap the content of the black container in a SingleChildScrollView
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Daily Check-in",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Earn Rewards For Checking in",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 10),
                          // Use the key for DailyCheckIn
                          DailyCheckIn(
                            key: _dailyCheckInKey, // Add this
                            onRewardClaimed: _incrementBonus,
                            onCoinAnimation: _animateCoins,
                            initialDay: 0,
                            initialCheckedDays: List<bool>.filled(7, false),
                          ),
                          SizedBox(height: 20),
                          // Update the button to directly use DailyCheckIn's logic:
                          GestureDetector(
                            onTap: () {
                              if (_dailyCheckInKey.currentState != null) {
                                // Get the position of the button for animation
                                final renderBox = context.findRenderObject() as RenderBox;
                                final position = renderBox.localToGlobal(Offset.zero);

                                _dailyCheckInKey.currentState!._onDayTap(
                                  _dailyCheckInKey.currentState!.currentDay,
                                  context,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Please wait...'),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromRGBO(255, 190, 0, 1),
                                    Color.fromRGBO(255, 85, 253, 1),
                                    Color.fromRGBO(127, 187, 255, 1),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Complete Today's Check-in",
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
                          // Trigger daily check-in process on tap
                          SizedBox(height: 20),
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 500),
                            child: _taskCompleted.contains(false)
                                ? Column(
                                    key: ValueKey('beginner-tasks'),
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Beginner Tasks",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontFamily: 'Nunito',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        "Do simple tasks and win bonuses",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Nunito',
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Column(
                                        children: [
                                          if (!_taskCompleted[0])
                                            SocialTask(
                                              key: ValueKey('task0'),
                                              svgAsset: 'assets/Icons/facebook.svg',
                                              taskTitle: "Follow us on Facebook",
                                              bonusTextColor: Colors.grey,
                                              url: 'https://www.facebook.com/digitaldreamsng',
                                              onTaskCompleted: () {
                                                setState(() => _taskCompleted[0] = true);
                                                _incrementBonus(200);
                                                _animateCoins(Offset(100, 300));
                                              },
                                              onCoinAnimation: _animateCoins,
                                            ),
                                          if (!_taskCompleted[1])
                                            SizedBox(height: 5),
                                          if (!_taskCompleted[1])
                                            SocialTask(
                                              key: ValueKey('task1'),
                                              svgAsset: 'assets/Icons/youtube.svg',
                                              taskTitle: "Follow us on Youtube",
                                              bonusTextColor: Colors.grey,
                                              url: 'https://youtube.com/@digitaldreamsictacademy1353?si=LMfIRwcFcG57R82B',
                                              onTaskCompleted: () {
                                                setState(() => _taskCompleted[1] = true);
                                                _incrementBonus(200);
                                              },
                                              onCoinAnimation: _animateCoins,
                                            ),
                                          if (!_taskCompleted[2])
                                            SizedBox(height: 5),
                                          if (!_taskCompleted[2])
                                            SocialTask(
                                              key: ValueKey('task2'),
                                              svgAsset: 'assets/Icons/tiktok.svg',
                                              taskTitle: "Follow us on TikTok",
                                              bonusTextColor: Colors.grey,
                                              url: 'https://www.tiktok.com/en/',
                                              onTaskCompleted: () {
                                                setState(() => _taskCompleted[2] = true);
                                                _incrementBonus(200);
                                              },
                                              onCoinAnimation: _animateCoins,
                                            ),
                                          if (!_taskCompleted[3])
                                            SizedBox(height: 5),
                                          if (!_taskCompleted[3])
                                            SocialTask(
                                              key: ValueKey('task3'),
                                              svgAsset: 'assets/Icons/facebook.svg',
                                              taskTitle: "Follow us on Facebook",
                                              bonusTextColor: Colors.grey,
                                              url: 'https://www.facebook.com/digitaldreamsng',
                                              onTaskCompleted: () {
                                                setState(() => _taskCompleted[3] = true);
                                                _incrementBonus(200);
                                              },
                                              onCoinAnimation: _animateCoins,
                                            ),
                                        ],
                                      ),
                                    ],
                                  )
                                : SizedBox.shrink(),
                          ),
                          // Watch Ads, Win big section
                          SizedBox(height: 15),
                          Text(
                            "Watch Ads, Win big",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "Do simple tasks and win bonuses",
                            style: TextStyle(
                              color: Colors.white70,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 5),
                          SocialTask2(
                            svgAsset: 'assets/Icons/coins2.svg',
                            taskTitle: "Turn on notifications",
                            bonusTextColor: Colors.amber,
                            onTaskCompleted: () {
                              _incrementBonus(200);
                            },
                            onCoinAnimation: _animateCoins,
                          ),
                          SizedBox(height: 5),
                          SocialTask2(
                            svgAsset: 'assets/Icons/coins2.svg',
                            taskTitle: "Turn on notifications",
                            bonusTextColor: Colors.amber,
                            onTaskCompleted: () {
                              _incrementBonus(200);
                            },
                            onCoinAnimation: _animateCoins,
                          ),
                          SizedBox(height: 5),
                          SocialTask2(
                            svgAsset: 'assets/Icons/coins2.svg',
                            taskTitle: "Turn on notifications",
                            bonusTextColor: Colors.amber,
                            onTaskCompleted: () {
                              _incrementBonus(200);
                            },
                            onCoinAnimation: _animateCoins,
                          ),
                          SizedBox(height: 5),
                          SocialTask2(
                            svgAsset: 'assets/Icons/coins2.svg',
                            taskTitle: "Turn on notifications",
                            bonusTextColor: Colors.amber,
                            onTaskCompleted: () {
                              _incrementBonus(200);
                            },
                            onCoinAnimation: _animateCoins,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Coin Animation
              ...List.generate(coinStartPositions.length, (index) {
                return TweenAnimationBuilder<Offset>(
                  tween: Tween<Offset>(
                    begin: coinStartPositions[index],
                    end: coinEndPositions[index],
                  ),
                  duration: _controller.duration!,
                  builder: (context, value, child) {
                    return Positioned(
                      left: value.dx,
                      top: value.dy,
                      child: Image.asset(
                        'assets/images/anime.png',
                        width: 30,
                        height: 30,
                      ),
                    );
                  },
                  onEnd: () {
                    if (mounted && coinStartPositions.length > index && coinEndPositions.length > index) {
                      setState(() {
                        coinStartPositions.removeAt(index);
                        coinEndPositions.removeAt(index);
                      });
                    }
                  },
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class DailyCheckIn extends StatefulWidget {
  final Function(int) onRewardClaimed;
  final Function(Offset) onCoinAnimation;
  final int initialDay; // Add this
  final List<bool> initialCheckedDays; // Add this

  const DailyCheckIn({
    Key? key,
    required this.onRewardClaimed,
    required this.onCoinAnimation,
    required this.initialDay,
    required this.initialCheckedDays,
  }) : super(key: key);

  @override
  _DailyCheckInState createState() => _DailyCheckInState();
}

class _DailyCheckInState extends State<DailyCheckIn> {
  static const int totalDays = 7;
  late List<bool> checkedInDays;
  late int currentDay;
  late List<double> taskPositions; // Track positions of tasks

  @override
  void initState() {
    super.initState();
    checkedInDays = List<bool>.from(widget.initialCheckedDays);
    currentDay = widget.initialDay;
    taskPositions = List<double>.filled(totalDays, 0.0); // Initialize positions
  }

  void _onDayTap(int dayIndex, BuildContext context) {
    if (dayIndex != currentDay) return;
    if (checkedInDays[dayIndex]) return;

    setState(() {
      checkedInDays[dayIndex] = true;
      widget.onRewardClaimed(25);
      _triggerCoinAnimation(context);

      // Slide the task to the left
      taskPositions[dayIndex] = -100; // Move left by 100 pixels

      if (currentDay < totalDays - 1) {
        currentDay++;
      } else {
        currentDay = 0;
        checkedInDays = List<bool>.filled(totalDays, false);
        taskPositions = List<double>.filled(totalDays, 0.0); // Reset positions
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Day ${dayIndex + 1} checked in! +25 points'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _triggerCoinAnimation(BuildContext context) {
    // Get the position of the tapped day container
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset position = renderBox.localToGlobal(Offset.zero);

    // Adjust the position to be at the center of the tapped day
    position = Offset(
      position.dx + renderBox.size.width / 2,
      position.dy + renderBox.size.height / 2,
    );

    // Trigger the animation to the bonus score position (20, 145)
    widget.onCoinAnimation(position);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(totalDays, (index) {
        bool isCurrentDay = index == currentDay;
        bool isChecked = checkedInDays[index];

        Gradient gradient;
        if (isChecked) {
          gradient = LinearGradient(
            colors: [Colors.grey, Colors.grey, Colors.grey],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
        } else if (isCurrentDay) {
          gradient = LinearGradient(
            colors: [
              Color.fromRGBO(255, 190, 0, 1),
              Color.fromRGBO(255, 85, 253, 1),
              Color.fromRGBO(127, 187, 255, 1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
        } else {
          gradient = LinearGradient(
            colors: [Colors.transparent, Color.fromRGBO(34, 34, 34, 1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
        }

        return AnimatedPositioned(
          duration: const Duration(milliseconds: 300), // Animation duration
          left: taskPositions[index], // Use the tracked position
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(1),
                child: GestureDetector(
                  onTap: () => _onDayTap(index, context),
                  child: Container(
                    width: 50,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: gradient,
                      border: isChecked || isCurrentDay
                          ? Border.all(color: Colors.white, width: 2)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "+25",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            fontFamily: 'Nunito',
                          ),
                        ),
                        SizedBox(height: 5),
                        Image.asset(
                          'assets/Icons/coins2.png',
                          width: 40,
                          height: 40,
                          color: isChecked ? Colors.white : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Day ${index + 1}",
                style: TextStyle(
                  color: isChecked || isCurrentDay
                      ? Colors.white
                      : Color.fromRGBO(255, 255, 255, 0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Nunito',
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}