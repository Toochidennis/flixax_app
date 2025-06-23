import 'package:flixax_app/provider/movie_provider.dart';
import 'package:flixax_app/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flixax_app/video_player_screen.dart';
// Make sure the VideoPlayerScreen widget is defined in this file and the import path is correct.

class Mylist extends StatefulWidget {
  const Mylist({super.key});

  @override
  State<Mylist> createState() => _MylistState();
}

class _MylistState extends State<Mylist> {
  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    if (movieProvider.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (movieProvider.error != null) {
      return Center(
        child: Text('Error: ${movieProvider.error}'),
      );
    } else {
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
                fontFamily: 'Nunito',
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
              // Collection Tab
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Start watching",
                        style: TextStyle(
                          color: Colors.white,
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
                      itemCount: movieProvider.hotMovies.length,
                      itemBuilder: (context, index) {
                        final movie = movieProvider.newAndTrendingMovies[index];
                        return GestureDetector(
                          onTap: () async {
                            // Play the movie first, then add to recently watched and navigate to details
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenVideoPage(
                              videoUrl: movie.episodes.first.videoUrl!,
                              title: movie.title!,
                            ),
                              ),
                            );
                            movieProvider.addToRecentlyWatched(movie);
                            Navigator.pushNamed(context, '/details', arguments: movie);
                          },
                          child: MovieItem(
                            image: movie.posterPortrait!,
                            title: movie.title!,
                            placeholderImage: 'assets/images/placeholder.png',
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Recently Watched Tab
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Recently Watched",
                        style: TextStyle(
                          color: Colors.white,
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
                      itemCount: movieProvider.recentlyWatched.length,
                      itemBuilder: (context, index) {
                        final movie = movieProvider.recentlyWatched[index];
                        return GestureDetector(
                          onTap: () async {
                            // Play the movie first, then add to recently watched and navigate to details
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>FullScreenVideoPage(
                              videoUrl: movie.episodes.first.videoUrl!,
                              title: movie.title!,
                            ),
                              ),
                            );
                            movieProvider.addToRecentlyWatched(movie);
                            Navigator.pushNamed(context, '/details', arguments: movie);
                          },
                          child: MovieItem(
                            image: movie.posterPortrait!,
                            title: movie.title!,
                            placeholderImage: 'assets/images/placeholder.png',
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}