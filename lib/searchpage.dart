// import 'package:flixax_app/homepage.dart';
import 'package:flixax_app/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flixax_app/provider/movie_provider.dart';
import 'package:flixax_app/video_player_screen.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {}); // Rebuild when text changes
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);
    final hasSearchText = _searchController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search movies...',
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
            suffixIcon: hasSearchText
                ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.white),
                    onPressed: () {
                      _searchController.clear();
                      movieProvider.setSearchQuery('');
                    },
                  )
                : null,
          ),
          style: TextStyle(color: Colors.white),
          onChanged: (value) => movieProvider.setSearchQuery(value),
        ),
      ),
      body: movieProvider.searchQuery.isEmpty
          ? _buildWatchedMovies(movieProvider)
          : _buildSearchResults(movieProvider),
    );
  }

  Widget _buildWatchedMovies(MovieProvider movieProvider) {
    if (movieProvider.watchedMovies.isEmpty) {
      return Center(
        child: Text(
          'No watched movies yet. Play videos to add them here.',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    return ListView.builder(
      itemCount: movieProvider.watchedMovies.length,
      itemBuilder: (context, index) {
        final movie = movieProvider.watchedMovies[index];
        return Dismissible(
          key: Key((movie.id?.toString() ?? '${movie.title}_$index')),
          background: Container(
            color: Colors.red[900],
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            movieProvider.removeFromWatched(movie);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Removed from history'),
                duration: Duration(seconds: 1),
              ),
            );
          },
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                movie.posterPortrait ?? '',
                width: 50,
                height: 75,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(Icons.movie, color: Colors.white54),
              ),
            ),
            title: Text(
              movie.title ?? 'No title',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              movie.genres.join(', '),
              style: TextStyle(color: Colors.white54),
            ),
            trailing: IconButton(
              icon: Icon(Icons.close, color: Colors.white54),
              onPressed: () {
                movieProvider.removeFromWatched(movie);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Removed from history'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
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
          ),
        );
      },
    );
  }

  Widget _buildSearchResults(MovieProvider movieProvider) {
    if (movieProvider.searchQuery.isEmpty) {
      return Center(
        child: Text(
          'Search for movies by title, description or genre',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    if (movieProvider.searchResults.isEmpty) {
      return Center(
        child: Text(
          'No results found for "${movieProvider.searchQuery}"',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    return ListView.builder(
      itemCount: movieProvider.searchResults.length,
      itemBuilder: (context, index) {
        final movie = movieProvider.searchResults[index];
        final isWatched = movieProvider.watchedMovies.any((m) => m.id == movie.id);

        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              movie.posterPortrait ?? '',
              width: 50,
              height: 75,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(Icons.movie, color: Colors.white54),
            ),
          ),
          title: Text(
            movie.title ?? 'No title',
            style: TextStyle(
              color: Colors.white,
              fontWeight: isWatched ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          subtitle: Text(
            movie.genres.join(', '),
            style: TextStyle(color: Colors.white54),
          ),
          trailing: Icon(
            isWatched ? Icons.play_circle_outline : Icons.play_circle_outline,
            color: isWatched ? Colors.white : Colors.white,
          ),
          onTap: () {
            if (movie.episodes.isNotEmpty) {
              // Add to watched list when played
              movieProvider.addToWatched(movie);
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
        );
      },
    );
  }
}
final List<Map<String,String>> movieslist =[
  {"image":"assets/images/img1.png",
  "title": "Escaping the crazy CEO Wife and the farm girl (DUBBED)\nEscaping the crazy CEO Wife and the farm girl",
  "genre":"CEO, Romance, Revenge",
  "popularity":"2.5k"
  },
  {"image":"assets/images/img1.png",
  "title": "Escaping the crazy CEO Wife and the farm girl",
  "genre":"CEO, Romance, Revenge",
  "popularity":"2.5k"
  },
  {"image":"assets/images/img1.png",
  "title": "Escaping the crazy CEO Wife and the farm girl",
  "genre":"CEO, Romance, Revenge",
  "popularity":"2.5k"
  },
  {"image":"assets/images/img1.png",
  "title": "Escaping the crazy CEO Wife and the farm girl",
  "genre":"CEO, Romance, Revenge",
  "popularity":"2.5k"
  },
  {"image":"assets/images/img1.png",
  "title": "Escaping the crazy CEO Wife and the farm girl",
  "genre":"CEO, Romance, Revenge",
  "popularity":"2.5k"
  },
  {"image":"assets/images/img1.png",
  "title": "Escaping the crazy CEO Wife and the farm girl",
  "genre":"CEO, Romance, Revenge",
  "popularity":"2.5k"
  },
  {"image":"assets/images/img1.png",
  "title": "Escaping the crazy CEO Wife and the farm girl",
  "genre":"CEO, Romance, Revenge",
  "popularity":"2.5k"
  },
  {"image":"assets/images/img1.png",
  "title": "Escaping the crazy CEO Wife and the farm girl",
  "genre":"CEO, Romance, Revenge",
  "popularity":"2.5k"
  },
  {"image":"assets/images/img1.png",
  "title": "Escaping the crazy CEO Wife and the farm girl",
  "genre":"CEO, Romance, Revenge",
  "popularity":"2.5k"
  },
  {"image":"assets/images/img1.png",
  "title": "Escaping the crazy CEO Wife and the farm girl",
  "genre":"CEO, Romance, Revenge",
  "popularity":"2.5k"
  },
];