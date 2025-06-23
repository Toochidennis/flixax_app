import 'package:carousel_slider/carousel_slider.dart';
import 'package:flixax_app/provider/movie_provider.dart';
import 'package:flixax_app/rewards.dart';
import 'package:flixax_app/rewards2.dart';
import 'package:flixax_app/searchpage.dart';
import 'package:flixax_app/video_player_screen.dart';
import 'package:flixax_app/widgets.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flixax_app/popup.dart';
import 'package:provider/provider.dart';


// ignore: use_key_in_widget_constructors
class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with SingleTickerProviderStateMixin {
  bool _hasShownPopup = false;
  late TabController _tabController;

  final List<String> categories = [
    "All",
    "Recommended",
    "Popular",
    "New",
    "Asabawood",
    "Filipino",
    "Anime",
    "Hindi",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);

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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    if (movieProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (movieProvider.hasError) {
      return Center(child: Text('Error: ${movieProvider.error}'));
    }

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchPage()),
                      );
                    },
                    decoration: InputDecoration(
                      hintText: 'Browse by Minister',
                      hintStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      prefixIcon: const Icon(Icons.search, color: Colors.white, size: 15.01),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(35),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    readOnly: true,
                  ),
                ),
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => Rewards())
                  );
                },
                child: Image.asset(
                  "assets/Icons/giftbox.png",
                  width: 30,
                  height: 30,
                ),
              ),
            ],
          ),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 2.0, color: Colors.purpleAccent),
            ),
            indicatorWeight: 0,
            dividerColor: Colors.transparent,
            onTap: (index) {
              movieProvider.setCategory(categories[index]);
            },
            tabs: categories.map((category) => Tab(text: category)).toList(),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: categories.map((category) {
            return _buildContentForCategory(context, movieProvider, category);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildContentForCategory(BuildContext context, MovieProvider movieProvider, String category) {
    if (category == "All") {
      return _buildAllCategoryContent(context, movieProvider);
    } else if (category == "Asabawood") {
      return Center(child: Text('No movies available in Asabawood category.', style: TextStyle(color: Colors.white)));
    } else if (category == "Filipino") {
      return Center(child: Text('No movies available in Filipino category.', style: TextStyle(color: Colors.white)));
    } else if (category == "Anime") {
      return Center(child: Text('No movies available in Anime category.', style: TextStyle(color: Colors.white)));
    } else if (category == "Hindi") {
      return Center(child: Text('No movies available in Hindi category.', style: TextStyle(color: Colors.white)));
    } else {
      return _buildDefaultCategoryContent(context, movieProvider);
    }
  }

  Widget _buildAllCategoryContent(BuildContext context, MovieProvider movieProvider) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 10),
      children: [
        SizedBox(height: 20),
        CarouselSlider.builder(
          itemCount: movieProvider.youMayAlsoLikeMovies.length,
          options: CarouselOptions(
            height: 400.52,
            autoPlay: true,
            enlargeCenterPage: true,
            enableInfiniteScroll: true,
            viewportFraction: 0.70,
          ),
          itemBuilder: (BuildContext context, int index, int realIndex) {
            final movie = movieProvider.youMayAlsoLikeMovies[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullScreenVideoPage(
                      videoUrl: movie.episodes.first.videoUrl ?? '',
                      title: movie.title ?? '',
                    ),
                  ),
                );
              },
              child: _imageItem(
                image: movie.posterPortrait ?? '',
                title: movie.title ?? '',
                placeholderImage: 'assets/images/placeholder.png',
              ),
            );
          },
        ),
        SizedBox(height: 30),
        SectionHeader(name: "New and HOT!"),
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
          itemCount: movieProvider.newAndTrendingMovies.length,
          itemBuilder: (context, index) {
            final hotMovie = movieProvider.newAndTrendingMovies[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullScreenVideoPage(
                      videoUrl: hotMovie.episodes.first.videoUrl ?? '',
                      title: hotMovie.title ?? '',
                    ),
                  ),
                );
              },
              child: MovieItem(
                image: hotMovie.posterPortrait ?? '',
                title: hotMovie.title ?? '',
                placeholderImage: 'assets/images/placeholder.png',
              ),
            );
          },
        ),
        SizedBox(height: 30),
        SectionHeader(name: "Premium Drama"),
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
          itemCount: movieProvider.newAndTrendingMovies.length,
          itemBuilder: (context, index) {
            final premiumVideo = movieProvider.recommendedMovies[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullScreenVideoPage(
                      videoUrl: premiumVideo.episodes.first.videoUrl ?? '',
                      title: premiumVideo.title ?? '',
                    ),
                  ),
                );
              },
              child: MovieItem(
                image: premiumVideo.posterPortrait ?? '',
                title: premiumVideo.title ?? '',
                placeholderImage: 'assets/images/placeholder.png',
              ),
            );
          },
        ),
        SizedBox(height: 30),
        SectionHeader(name: "Most Trending"),
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: movieProvider.hotMovies.length,
          itemBuilder: (context, index) {
            final trendVideo = movieProvider.hotMovies[index];
            final trendItem = index < trend.length
                ? trend[index]
                : {"crank": Colors.grey, "rank": "Trending"};
            return GestureDetector(
              onTap: () {
                if (trendVideo.episodes.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenVideoPage(
                        videoUrl: trendVideo.episodes.first.videoUrl ?? '',
                        title: trendVideo.title ?? '',
                      ),
                    ),
                  );
                }
              },
              child: MovieItem2(
                image: trendVideo.posterPortrait ?? '',
                title: trendVideo.title ?? '',
                crank: trendItem['crank'],
                rank: trendItem['rank'],
                placeholderImage: 'assets/images/placeholder.png',
              ),
            );
          },
        ),
        SizedBox(height: 30),
        SectionHeader(name: "You will love this!"),
        Container(
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
        SizedBox(height: 30),
        SectionHeader(name: "You might also like"),
        Container(
          child: SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movieProvider.recommendedMovies.length,
              itemBuilder: (context, index) {
                final movie = movieProvider.recommendedMovies[index];
                final genre = index < scrolltrend.length 
                    ? scrolltrend[index]['genre']
                    : "Genre";
                return GestureDetector(
                  onTap: () {
                    if (movie.episodes.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenVideoPage(
                            videoUrl: movie.episodes.first.videoUrl ?? '',
                            title: movie.title ?? '',
                          ),
                        ),
                      );
                    }
                  },
                  child: MovieItem3(
                    image: movie.posterPortrait ?? '',
                    title2: movie.title ?? "",
                    genre: genre,
                    placeholderImage: 'assets/images/placeholder.png',
                  ),
                );
              },
            ),
          ),
        ),
        Container(
          child: SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movieProvider.newAndTrendingMovies.length,
              itemBuilder: (context, index) {
                final movie = movieProvider.newAndTrendingMovies[index];
                final genre = index < scrolltrend.length 
                    ? scrolltrend[index]['genre']
                    : "Genre";
                return GestureDetector(
                  onTap: () {
                    if (movie.episodes.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenVideoPage(
                            videoUrl: movie.episodes.first.videoUrl ?? '',
                            title: movie.title ?? '',
                          ),
                        ),
                      );
                    }
                  },
                  child: MovieItem3(
                    image: movie.posterPortrait ?? '',
                    title2: movie.title ?? "",
                    genre: genre,
                    placeholderImage: 'assets/images/placeholder.png',
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultCategoryContent(BuildContext context, MovieProvider movieProvider) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      children: [
        if (movieProvider.getMoviesByCategory().isNotEmpty)
          CarouselSlider.builder(
            itemCount: 
              movieProvider.getMoviesByCategory().length < 5
                ? movieProvider.getMoviesByCategory().length
                : 5,
            options: CarouselOptions(
              height: 400.52,
              autoPlay: true,
              enlargeCenterPage: true,
              enableInfiniteScroll: true,
              viewportFraction: 0.70,
            ),
            itemBuilder: (context, index, realIndex) {
              final movie = movieProvider.getMoviesByCategory()[index];
              return _imageItem(
                image: movie.posterPortrait ?? '',
                title: movie.title ?? '',
                placeholderImage: 'assets/images/placeholder.png',
              );
            },
          ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: movieProvider.getMoviesByCategory().length,
          itemBuilder: (context, index) {
            final movie = movieProvider.getMoviesByCategory()[index];
            return MovieItem(
              image: movie.posterPortrait ?? '',
              title: movie.title ?? '',
              placeholderImage: 'assets/images/placeholder.png',
            );
          },
        ),
      ],
    );
  }

  Widget _imageItem({
    required String image,
    required String title,
    required String placeholderImage,
  }) {
    return SizedBox(
      height: 400.52,
      width: 300,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.network(
              image,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Image.asset(
                    placeholderImage,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  );
                }
              },
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                return Image.asset(
                  placeholderImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                );
              },
            ),
          ),
          Positioned(
            left: 10,
            bottom: 10,
            child: Container(
              width: 280,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 230,
                    child: Text(
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
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromRGBO(250, 82, 140, 1),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
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