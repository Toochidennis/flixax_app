import 'package:flixax_app/widgets.dart';
import 'package:flutter/material.dart';

class Mylist extends StatefulWidget {
  const Mylist({super.key});

  @override
  State<Mylist> createState() => _MylistState();
}

class _MylistState extends State<Mylist> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'My List',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontFamily: 'Nunito'
            ),
          ),
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 2.0,
                color: Colors.purpleAccent,
              ),
            ),
            indicatorWeight: 0,
            dividerColor: Colors.transparent,
            tabs: [
              Tab(text: 'Collection'),
              Tab(text: 'Recently Watched'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            
            SingleChildScrollView( 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "Start watching",
                      style: TextStyle(color: Colors.white,
                       fontSize: 14,
                       fontFamily: 'Nunito',
                       fontWeight: FontWeight.w500,
                       ),
                    ),
                  ),
                  GridView.builder(
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
                ],
              ),
            ),
                GridView.builder(
                    physics: NeverScrollableScrollPhysics(), 
                    shrinkWrap: true, 
                    padding: EdgeInsets.all(10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: movies2.length,
                    itemBuilder: (context, index) {
                      return MovieItem(
                        image: movies2[index]['image']!,
                        title: movies2[index]['title']!,
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

// Dummy Movie List
final List<Map<String, String>> movies = [
  {"image": "assets/images/img1.png", "title": "Movie 1"},
  {"image": "assets/images/img2.png", "title": "Movie 2"},
  {"image": "assets/images/img3.png", "title": "Movie 3"},
  {"image": "assets/images/img2.png", "title": "Movie 4"},
  {"image": "assets/images/img1.png", "title": "Movie 5"},
  {"image": "assets/images/img3.png", "title": "Movie 6"},
  {"image": "assets/images/img1.png", "title": "Movie 7"},
  {"image": "assets/images/img1.png", "title": "Movie 8"},
  {"image": "assets/images/img1.png", "title": "Movie 9"},
  {"image": "assets/images/img1.png", "title": "Movie 9"},
  {"image": "assets/images/img1.png", "title": "Movie 9"},
  {"image": "assets/images/img1.png", "title": "Movie 9"},
  {"image": "assets/images/img1.png", "title": "Movie 9"},
  {"image": "assets/images/img1.png", "title": "Movie 9"},
  {"image": "assets/images/img1.png", "title": "Movie 9"},
  {"image": "assets/images/img1.png", "title": "Movie 9"},
];
final List<Map<String, String>> movies2 = [
  {"image": "assets/images/img1.png", "title": "Movie 1"},
  {"image": "assets/images/img2.png", "title": "Movie 2"},
  {"image": "assets/images/img3.png", "title": "Movie 3"},
  {"image": "assets/images/img2.png", "title": "Movie 4"},];
