import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flixax_app/widgets.dart';

class Rewards2 extends StatelessWidget {
  const Rewards2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        final double blackContainerHeight = constraints.maxHeight * 0.72;

        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(237,190,0,1), 
                    Color.fromRGBO(248,101,116,1),
                    Color.fromRGBO(250,82,140,1)],
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
                onPressed: () {
                  Navigator.pop(context);
                },
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
                  fontFamily: 'Nunito'
                ),
              ),
            ),
            Positioned(
              top: 145,
              left: 20,
              child: Text(
                "250",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Nunito'
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 0.1,
              left: 100,
              child: Image.asset(
                "assets/images/coin.png",
                width: 400,
                height: 350,
              ),
            ),
            // Second Layer - Black Overlay with Rounded Corners (raised from bottom)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: blackContainerHeight,
                decoration: const BoxDecoration(
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
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Earn Rewards For Checking in",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w400
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(7, (index) {
                            bool isCurrentDay = index == 2; // Highlight day 3
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(1),
                                  child: Container(
                                    width: 50,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      gradient: isCurrentDay
                                          ? LinearGradient(
                                              colors: [
                                                Color.fromRGBO(255,190,0,1),
                                                Color.fromRGBO(255,85,253,1),
                                                Color.fromRGBO(127,187,255,1)
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight)
                                          : LinearGradient(
                                              colors: [
                                                Colors.transparent,
                                                Color.fromRGBO(34,34,34,1)
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight),
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
                                            fontFamily: 'Nunito'
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Image.asset(
                                          'assets/Icons/coins2.png',
                                          width: 40,
                                          height: 40,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Day ${index + 1}",
                                  style: TextStyle(
                                      color: Color.fromRGBO(255,255,255,0.5),
                                       fontSize: 12,
                                       fontWeight: FontWeight.w400,
                                       fontFamily: 'Nunito'
                                       ),
                                )
                              ],
                            );
                          }),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            // Handle button tap
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                  colors: [
                                    Color.fromRGBO(255,190,0,1),
                                    Color.fromRGBO(255,85,253,1),
                                    Color.fromRGBO(127,187,255,1),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight),
                            ),
                            child: Center(
                              child: Text(
                                "Watch Ad to Double Rewards",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Nunito'
                                    ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Beginner Tasks",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "Do simple tasks and win bonuses",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Nunito'
                          ),
                        ),
                        SizedBox(height:5),
                        SocialTask(
                          svgAsset: 'assets/Icons/facebook.svg',
                          taskTitle: "Follow us on Facebook",
                          bonusTextColor: Colors.grey,
                          url: 'https://www.facebook.com',
                          onTaskCompleted: () {},
                          onCoinAnimation: (Offset offset) {},
                        ),
                        SizedBox(height: 5),
                        SocialTask(
                          svgAsset: 'assets/Icons/youtube.svg',
                          taskTitle: "Follow us on Youtube",
                          bonusTextColor: Colors.grey,
                          url: 'https://www.youtube.com',
                          onTaskCompleted: () {},
                          onCoinAnimation: (Offset offset) {},
                        ),
                        SizedBox(height: 5),
                        SocialTask(
                          svgAsset: 'assets/Icons/tiktok.svg',
                          taskTitle: "Follow us on TikTok",
                          bonusTextColor: Colors.grey,
                          url: 'https://www.tiktok.com',
                          onTaskCompleted: () {},
                          onCoinAnimation: (Offset offset) {},
                        ),
                        SizedBox(height: 5),
                        SocialTask(
                          svgAsset: 'assets/Icons/facebook.svg',
                          taskTitle: "Follow us on Facebook",
                          bonusTextColor: Colors.grey,
                          url: 'https://www.facebook.com',
                          onTaskCompleted: () {},
                          onCoinAnimation: (Offset offset) {},
                        ),
                        SizedBox(height: 5),
                        SocialTask2(
                          svgAsset: 'assets/Icons/coins2.svg',
                          taskTitle: "Turn on Notification",
                          bonusTextColor: Colors.amber,
                        ),
                        SizedBox(height: 15),
                         Text(
                          "Watch Ads, Win big",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w700),
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

                        SizedBox(height: 5,),
                        SocialTask2(
                          svgAsset: 'assets/Icons/coins2.svg',
                          taskTitle: "Turn on notifications",
                          bonusTextColor: Colors.amber,
                        ),
                        SizedBox(height: 5),
                        SocialTask2(
                          svgAsset: 'assets/Icons/coins2.svg',
                          taskTitle: "Turn on notifications",
                          bonusTextColor: Colors.amber,
                        ),
                        SizedBox(height: 5),
                        SocialTask2(
                          svgAsset: 'assets/Icons/coins2.svg',
                          taskTitle: "Turn on notifications",
                          bonusTextColor: Colors.amber,
                        ),
                        SizedBox(height: 5),
                        SocialTask2(
                          svgAsset: 'assets/Icons/coins2.svg',
                          taskTitle: "Turn on notifications",
                          bonusTextColor: Colors.amber,
                        ),
                      
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
