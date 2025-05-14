import 'package:carousel_slider/carousel_slider.dart';
import 'package:flixax_app/rewards.dart';
import 'package:flixax_app/rewards2.dart';
import 'package:flixax_app/searchpage.dart';
import 'package:flixax_app/widgets.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flixax_app/popup.dart';


// ignore: use_key_in_widget_constructors
class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool _hasShownPopup = false; // ✅ put this OUTSIDE the override

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasShownPopup) {
        showBonusPopup(context, onPopupClosed: () {
          setState(() {
            _hasShownPopup = true;
          });
        });
      }
    });
  }


  final List<String> categories = [
    "Recommended",
    "Popular",
    "New",
    "Asabawood",
    "Filipino",
    "Anime",
    "Hindi",
  ];

  final trending = [
    _imageItem(
      image: "assets/images/img1.png",
      title: "Escaping\nthe ceo's wife",
    ),
    _imageItem(
      image: "assets/images/img2.png",
      title: "Fated to     \nthe alpha         ",
    ),
    _imageItem(image: "assets/images/img3.png", title: "Love by contract"),
  ];

  int selectedIndex = 0;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Expanded(
              child: SizedBox(
                width: 340,
                height: 36,
                child: TextField(
                  onTap: (){
                    Navigator.push(context,
                     MaterialPageRoute(builder:
                      (context)=>Searchpage()));
                  },
                  decoration: InputDecoration(
                    hintText: 'Browse by Minister',
                    hintStyle: const TextStyle(fontSize: 12,fontWeight: FontWeight.w500),
                    prefixIcon: const Icon(Icons.search, color: Colors.white,size:15.01,),
                    filled: true,
                    // ignore: deprecated_member_use
                    fillColor: Colors.grey.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
            SizedBox(width: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context)=>Rewards2()
                    ));
              },
              child: Image.asset(
                "assets/Icons/giftbox.png",
                width: 30,
                height: 30,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10),
          //  child:
          //  Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              margin: EdgeInsets.only(top: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  bool isSelected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            categories[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          height: 3,
                          width: isSelected ? 60 : 0,
                          decoration: BoxDecoration(
                            color: Colors.purpleAccent,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          margin: EdgeInsets.only(top: 5),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            //Carousel
            SizedBox(height: 20),
            CarouselSlider.builder(
              itemCount: trending.length,
              options: CarouselOptions(
                height: 400.52,
                autoPlay: true,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                viewportFraction: 0.70,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
              itemBuilder: (BuildContext context, int index, int realIndex) {
                return trending[index];
              },
            ),
            SizedBox(height: 30),
            SectionHeader(name: "New and HOT!"),
            Expanded(
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return MovieItem(
                    image: movies[index]['image']!,
                    title: movies[index]['title']!,
                  );
                },
              ),
            ),

            SizedBox(height: 30),
            SectionHeader(name: "Premium Drama"),
            Expanded(
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return MovieItem(
                    image: movies[index]['image']!,
                    title: movies[index]['title']!,
                  );
                },
              ),
            ),

            SizedBox(height: 30),
            SectionHeader(name: "Most Trending"),
            Expanded(
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return MovieItem2(
                    image: trend[index]['image']!,
                    title: trend[index]['title']!,
                    crank: trend[index]['crank']!,
                    rank: trend[index]['rank']!,
                  );
                },
              ),
            ),

            SizedBox(height: 30),
           SectionHeader(name: "You will love this!"),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(16,16,16,0.2),
                       Color.fromRGBO(252, 125, 135, 0.2),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        "assets/images/img3.png",
                        width: 80,
                        height: 120,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Love by contract",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 5),
                          Text(
                            "lorem iydiieieriuiuerytyitiytiitiut",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 29),
                          ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(251,116,155,1),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            icon: Icon(Icons.play_arrow, color: Colors.white),
                            label: Text("Watch now"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            SectionHeader(name: "You might also like"),
            Expanded(
              child: Container(
                child: SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: scrolltrend.length,
                    itemBuilder: (context, index) {
                      return MovieItem3(
                        image: scrolltrend[index]['image']!,
                        title2: scrolltrend[index]['title2'],
                        genre: scrolltrend[index]['genre'],
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 7),
            Expanded(
              child: SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: scrolltrend.length,
                  itemBuilder: (context, index) {
                    return MovieItem3(
                      image: scrolltrend[index]['image']!,
                      title2: scrolltrend[index]['title2']!,
                      genre: scrolltrend[index]['genre']!,
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            SectionHeader(name: "Most Trending"),
               Expanded(
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return MovieItem2(
                    image: trend[index]['image']!,
                    title: trend[index]['title']!,
                    crank: trend[index]['crank']!,
                    rank: trend[index]['rank']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _imageItem({required String image, required String title}) {
  return SizedBox(
    height: 400.52,
    width: 300,
    child: Stack(
      alignment: Alignment.bottomLeft,
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(image, fit: BoxFit.cover),
        ),

        Positioned(
          left: 10,
          bottom: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0,
                  fontFamily: 'Nunito'
                ),
              ),
              SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(left: 100),
                child:GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(250,82,140,1), // Solid pink circle
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white, // White play icon
                              size: 28,
                            ),
                          ),
                        ),
                      )
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

final List<Map<String, String>> movies = [
  {"image": "assets/images/img1.png", "title": "one one"},
  {"image": "assets/images/img2.png", "title": "one one"},
  {"image": "assets/images/img3.png", "title": "one one"},
  {"image": "assets/images/img2.png", "title": "one one"},
  {"image": "assets/images/img1.png", "title": "one one"},
  {"image": "assets/images/img3.png", "title": "one one"},
  // {"image": "assets/images/img1.png", "title": "one one"},
  // {"image": "assets/images/img1.png", "title": "one one"},
  // {"image": "assets/images/img1.png", "title": "one one"},
];

final List<Map<String, dynamic>> trend = [
  {
    "image": "assets/images/img5.png",
    "title": "one one",
    "crank": Colors.amber,
    "rank": "2nd in Nigeria",
  },
  {
    "image": "assets/images/img4.png",
    "title": "one one",
    "crank": Colors.blue,
    "rank": "1st in the world",
  },
  {
    "image": "assets/images/img5.png",
    "title": "one one",
    "crank": Colors.green,
    "rank": "3rd in the world",
  },
  {
    "image": "assets/images/img5.png",
    "title": "one one",
    "crank": Colors.red,
    "rank": "3rd in the world",
  },
  {
    "image": "assets/images/img4.png",
    "title": "one one",
    "crank": Colors.blue,
    "rank": "3rd in the world",
  },
  {
    "image": "assets/images/img4.png",
    "title": "one one",
    "crank": Colors.red,
    "rank": "3rd in the world",
  },
  // {"image": "assets/images/img1.png", "title": "one one"},
  // {"image": "assets/images/img1.png", "title": "one one"},
  // {"image": "assets/images/img1.png", "title": "one one"},
];

final List<Map<String, dynamic>> scrolltrend = [
  {
    "image": "assets/images/img1.png",
    "title2":"Escaping the crazy CEO....",
    "genre": "Romance,CEO",
  },
  {
    "image": "assets/images/img1.png",
    "title2": "Escaping the crazy CEO and....",
    "genre": "Romance,CEO",
  },
  {
    "image": "assets/images/img1.png",
    "title2": "Escaping the crazy CEO and....",
    "genre": "Romance,CEO",
  },
  {
    "image": "assets/images/img1.png",
    "title2":"Escaping the crazy CEO and....",
    "genre": "Romance,CEO",
  },
  {
    "image": "assets/images/img1.png",
    "title2":"Escaping the crazy CEO and....",
    "genre": "Romance,CEO",
  },
  {
    "image": "assets/images/img1.png",
    "title2": "Escaping the crazy CEO and....",
    "genre": "Romance,CEO",
  },
];

