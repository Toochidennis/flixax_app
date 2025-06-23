import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';



class MovieItem extends StatelessWidget {
  final String image;
  final String title;
  final String placeholderImage; // Add a placeholder image parameter

  const MovieItem({
    super.key,
    required this.image,
    required this.title,
    required this.placeholderImage, // Initialize the placeholder image
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 150,
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child; // Image has loaded
              } else {
                return Image.asset(
                  placeholderImage, // Show custom placeholder image while loading
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 150,
                );
              }
            },
            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
              return Image.asset(
                placeholderImage, // Show placeholder image on error as well
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150,
              );
            },
          ),
        ),
        const SizedBox(height: 5),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: 'Nunito',
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
class MovieItem2 extends StatelessWidget {
  final String image;
  final String title;
  final Color crank;
  final String rank;
  final String placeholderImage; // Add a placeholder image parameter

  const MovieItem2({
    super.key,
    required this.image,
    required this.title,
    required this.crank,
    required this.rank,
    required this.placeholderImage, // Initialize the placeholder image
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      decoration: BoxDecoration(color: const Color.fromARGB(137, 46, 44, 44)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              child: Image.network(
                image,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child; // Image has loaded
                  } else {
                    return Image.asset(
                      placeholderImage, // Show custom placeholder image while loading
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    );
                  }
                },
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return Image.asset(
                    placeholderImage, // Show placeholder image on error as well
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Expanded(
              child: Text(
                title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  fontFamily: 'Nunito',
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            margin: EdgeInsets.only(left: 8, bottom: 8),
            decoration: BoxDecoration(
              color: crank.withOpacity(0.5),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              rank,
              style: TextStyle(
                color: crank, // Text color inside highlight
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontFamily: 'Nunito',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Section extends StatelessWidget {
  final String name;
 const Section({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            margin: EdgeInsets.only(left: 8, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.5),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              "Rewards from daily takes",
              style: TextStyle(
                color: Colors.amber, // Text color inside highlight
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}

class SocialTask extends StatefulWidget {
  const SocialTask({
    super.key,
    required this.svgAsset,
    required this.taskTitle,
    required this.bonusTextColor,
    required this.url,
    required this.onTaskCompleted, // Add callback
    this.isCompleted = false,
    required this.onCoinAnimation, // New callback for coin animation with position
  });

  final String svgAsset;
  final String taskTitle;
  final Color bonusTextColor;
  final String url;
  final VoidCallback onTaskCompleted; // Callback type
  final bool isCompleted;
  final Function(Offset) onCoinAnimation; // New callback for coin animation with position

  @override
  _SocialTaskState createState() => _SocialTaskState();
}

class _SocialTaskState extends State<SocialTask> with SingleTickerProviderStateMixin {
  bool isCompleted = false;
  bool isLoading = false;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  void _triggerCoinAnimation(BuildContext context) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset position = box.localToGlobal(Offset.zero);
    widget.onCoinAnimation(position);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-1.5, 0), // Slide left off screen
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url, BuildContext context) async {
    if (isLoading || isCompleted) return;
    setState(() {
      isLoading = true;
    });

    try {
      final uri = Uri.parse(url);
      if (await launchUrl(uri)) {
        await Future.delayed(Duration(seconds: 10));
        
        // Start the slide animation
        await _controller.forward();
        
        setState(() {
          isCompleted = true;
          isLoading = false;
        });

        widget.onTaskCompleted();
        _triggerCoinAnimation(context);
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonText = isCompleted ? 'Done' : (isLoading ? 'Wait...' : 'Go');
    final buttonGradient = isCompleted || isLoading
        ? LinearGradient(colors: [Colors.grey, Colors.grey])
        : LinearGradient(
            colors: [
              Color.fromRGBO(255, 190, 0, 1),
              Color.fromRGBO(255, 85, 253, 1),
              Color.fromRGBO(127, 187, 255, 1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color.fromRGBO(31, 33, 43, 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: SvgPicture.asset(
                  widget.svgAsset,
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.taskTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "+200 Bonus",
                    style: TextStyle(
                      color: widget.bonusTextColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Builder(
              builder: (buttonContext) => GestureDetector(
                onTap: isCompleted || isLoading
                    ? null
                    : () {
                        _launchURL(widget.url, context);
                        if (!isCompleted && !isLoading) {
                          _triggerCoinAnimation(buttonContext);
                        }
                      },
                child: Container(
                  width: 80,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: buttonGradient,
                  ),
                  child: Center(
                    child: Text(
                      buttonText,
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
            ),
          ],
        ),
      ),
    );
  }
}
class SocialTask2 extends StatelessWidget {
  final String svgAsset;
  final String taskTitle;
  final Color bonusTextColor;
  final bool isCompleted;
  final VoidCallback? onTap;
  final Function(Offset)? onCoinAnimation;
  final Function? onTaskCompleted; // Add this line

  const SocialTask2({
    Key? key,
    required this.svgAsset,
    required this.taskTitle,
    required this.bonusTextColor,
    this.isCompleted = false,
    this.onTap,
    this.onCoinAnimation,
    this.onTaskCompleted, // Add this line
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isCompleted
          ? null
          : () {
              if (onCoinAnimation != null) {
                onCoinAnimation!(Offset(100, 200));
              }
              if (onTaskCompleted != null) {
                onTaskCompleted!(); // Call the completion function
              }
              if (onTap != null) {
                onTap!();
              }
            },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isCompleted ? Colors.grey : Color.fromRGBO(31, 33, 43, 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: SvgPicture.asset(
                  svgAsset,
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    taskTitle,
                    style: TextStyle(
                      color: isCompleted ? Colors.white70 : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "+200 Bonus",
                    style: TextStyle(
                      color: bonusTextColor,
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: 80,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: isCompleted
                    ? LinearGradient(colors: [Colors.grey, Colors.grey])
                    : LinearGradient(
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
                  isCompleted ? "Done" : "Go",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Nunito',
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MovieItem3 extends StatelessWidget {
  final String image;
  final String title2;
  final String genre;
  final String placeholderImage; // Add a placeholder image parameter

  const MovieItem3({
    super.key,
    required this.image,
    required this.title2,
    required this.genre,
    required this.placeholderImage, // Initialize the placeholder image
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8), // Optional: Add border radius
            child: Image.network(
              image,
              width: 50,
              height: 90,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child; // Image has loaded
                } else {
                  return Image.asset(
                    placeholderImage, // Show custom placeholder image while loading
                    width: 50,
                    height: 90,
                    fit: BoxFit.cover,
                  );
                }
              },
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                return Image.asset(
                  placeholderImage, // Show placeholder image on error as well
                  width: 50,
                  height: 90,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title2,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  genre,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Nunito',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String name;
 const SectionHeader({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              fontFamily: 'Nunito'
            ),
          ),
          
          Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}

class Searchlist extends StatelessWidget {
  final String image;
  final String title;
  final String genre;
  final String popularity;
  final String placeholderImage; // Add a placeholder image parameter

  const Searchlist({
    super.key,
    required this.image,
    required this.title,
    required this.genre,
    required this.popularity,
    required this.placeholderImage, // Initialize the placeholder image
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Color.fromRGBO(34, 34, 34, 1),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        children: [
          /// Movie Poster
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              image,
              width: 60,
              height: 90,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child; // Image has loaded
                } else {
                  return Image.asset(
                    placeholderImage, // Show custom placeholder image while loading
                    width: 60,
                    height: 90,
                    fit: BoxFit.cover,
                  );
                }
              },
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                return Image.asset(
                  placeholderImage, // Show placeholder image on error as well
                  width: 60,
                  height: 90,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          SizedBox(width: 10),

          /// Title and Genre
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                   Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Nunito',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                
                SizedBox(height: 5),
                Text(
                    genre,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                      fontFamily: 'Nunito',
                    ),
                  ),
              ],
            ),
          ),

          /// Fire Icon & Popularity - Aligned to Right
          Row(
            mainAxisSize: MainAxisSize.min, // Keeps it compact
            children: [
              SvgPicture.asset(
                'assets/icons/fire.svg', // path to your SVG file
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 5),
             
                Text(
                  popularity,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Nunito',
                  ),
                ),
              
            ],
          ),
        ],
      ),
    );
  }
}

class SimpleGradientTabIndicator extends Decoration {
  final Gradient gradient;
  final double strokeWidth;

  const SimpleGradientTabIndicator({
    required this.gradient,
    this.strokeWidth = 3.0,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _SimpleGradientPainter(gradient, strokeWidth);
  }
}

class DailyCheckIn extends StatefulWidget {
  final Function(int) onRewardClaimed;

  const DailyCheckIn({Key? key, required this.onRewardClaimed}) : super(key: key);

  @override
  _DailyCheckInState createState() => _DailyCheckInState();
}

class _DailyCheckInState extends State<DailyCheckIn> {
  static const int totalDays = 7;

  List<bool> checkedInDays = List<bool>.filled(totalDays, false);
  int currentDay = 0;
  DateTime? lastCheckIn;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadCheckInData();
  }

  Future<void> _loadCheckInData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedCheckedDays = prefs.getStringList('checkedInDays');
    if (savedCheckedDays != null && savedCheckedDays.length == totalDays) {
      checkedInDays = savedCheckedDays.map((e) => e == 'true').toList();
    }
    currentDay = prefs.getInt('currentDay') ?? 0;
    final lastCheckInMillis = prefs.getInt('lastCheckIn');
    if (lastCheckInMillis != null) {
      lastCheckIn = DateTime.fromMillisecondsSinceEpoch(lastCheckInMillis);
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> _saveCheckInData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('checkedInDays', checkedInDays.map((e) => e.toString()).toList());
    prefs.setInt('currentDay', currentDay);
    if (lastCheckIn != null) {
      prefs.setInt('lastCheckIn', lastCheckIn!.millisecondsSinceEpoch);
    }
  }

  void _onDayTap(int dayIndex) {
    final now = DateTime.now();
    if (loading) return;

    if (dayIndex != currentDay || checkedInDays[dayIndex]) return;

    if (lastCheckIn != null) {
      final diff = now.difference(lastCheckIn!);
      if (diff.inHours < 24) {
        final remaining = 24 - diff.inHours;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please wait $remaining hour(s) before checking in again.'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
    }

    setState(() {
      checkedInDays[dayIndex] = true;
      lastCheckIn = now;
      widget.onRewardClaimed(25); // Reward +25 coins

      if (currentDay < totalDays - 1) {
        currentDay++;
      }
    });

    _saveCheckInData();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(child: CircularProgressIndicator());
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(totalDays, (index) {
        bool isCurrentDay = index == currentDay;
        bool isChecked = checkedInDays[index];

        Gradient gradient;
        if (isChecked) {
          gradient = LinearGradient(
            colors: [
              Colors.grey.shade700,
              Colors.grey.shade600,
              Colors.grey.shade500,
            ],
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
            colors: [
              Colors.transparent,
              Color.fromRGBO(34, 34, 34, 1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(1),
              child: GestureDetector(
                onTap: () => _onDayTap(index),
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
        );
      }),
    );
  }
}
class _SimpleGradientPainter extends BoxPainter {
  final Gradient gradient;
  final double strokeWidth;

  _SimpleGradientPainter(this.gradient, this.strokeWidth);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Rect rect = Offset(offset.dx, cfg.size!.height - strokeWidth) &
        Size(cfg.size!.width, strokeWidth);
    final Paint paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;
    canvas.drawRect(rect, paint);
  }
}


class WebmAssetVideo extends StatefulWidget {
  final String assetPath;
  final bool loop;
  final bool autoPlay;

  const WebmAssetVideo({
    super.key,
    required this.assetPath,
    this.loop = true,
    this.autoPlay = true,
  });

  @override
  State<WebmAssetVideo> createState() => _WebmAssetVideoState();
}

class _WebmAssetVideoState extends State<WebmAssetVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.assetPath)
      ..setLooping(widget.loop)
      ..initialize().then((_) {
        if (widget.autoPlay) {
          _controller.play();
        }
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const SizedBox(); // or CircularProgressIndicator()
    }
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }
}
