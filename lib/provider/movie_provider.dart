import 'package:flutter/foundation.dart';
import '../models/movie_model.dart';
import '../services/movie_service.dart';

class MovieProvider with ChangeNotifier {
  final MovieService _movieService;
  List<MovieCategory> _hotMovies = []; // Popular
  List<MovieCategory> _recommendedMovies = []; // Recommended
  List<MovieCategory> _newAndTrendingMovies = []; // New
  List<MovieCategory> _youMayAlsoLikeMovies = []; // Asabawood
  List<MovieCategory> _asabawoodMovies = []; // Asabawood
  List<MovieCategory> _filipinoMovies = []; // Filipino
  List<MovieCategory> _animeMovies = []; // Anime
  List<MovieCategory> _hindiMovies = []; // Hindi
  List<MovieCategory> _recentlyWatched = [];
  List<MovieCategory> _watchedMovies = [];
  bool _isLoading = false;
  MovieException? _error;
  DateTime? _lastFetchTime;
  String _searchQuery = '';

  // Initialize with empty lists for specific categories
  MovieProvider({MovieService? movieService})
      : _movieService = movieService ?? MovieService() {
    _youMayAlsoLikeMovies = [];
    _hotMovies = [];
    _recommendedMovies = [];
    _newAndTrendingMovies = [];
    _asabawoodMovies = [];
    _filipinoMovies = [];
    _animeMovies = [];
    _hindiMovies = [];
  }

  // Getters
  List<MovieCategory> get hotMovies => _hotMovies;
  List<MovieCategory> get recommendedMovies => _recommendedMovies;
  List<MovieCategory> get newAndTrendingMovies => _newAndTrendingMovies;
  List<MovieCategory> get youMayAlsoLikeMovies => _youMayAlsoLikeMovies;
  List<MovieCategory> get recentlyWatched => _recentlyWatched;
  List<MovieCategory> get watchedMovies => _watchedMovies;
  bool get isLoading => _isLoading;
  MovieException? get error => _error;
  bool get hasError => _error != null;
  bool get shouldRefresh {
    return _lastFetchTime == null || 
        DateTime.now().difference(_lastFetchTime!) > const Duration(minutes: 30);
  }
  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<MovieCategory> get searchResults {
    if (_searchQuery.isEmpty) return [];
    final query = _searchQuery.toLowerCase();
    return [
      ...hotMovies,
      ...recommendedMovies,
      ...newAndTrendingMovies,
      ...youMayAlsoLikeMovies,
    ].where((movie) =>
      (movie.title?.toLowerCase().contains(query) ?? false) ||
      (movie.description?.toLowerCase().contains(query) ?? false) ||
      (movie.genres.any((genre) => genre.toLowerCase().contains(query)))
    ).toList();
  }

  Future<void> fetchMovies({bool forceRefresh = false}) async {
    if (!forceRefresh && !shouldRefresh && _hotMovies.isNotEmpty) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _movieService.getMovies();
      
      if (response.success) {
        _hotMovies = response.data.hot;
        _recommendedMovies = response.data.recommended;
        _newAndTrendingMovies = response.data.newAndTrending;
        _youMayAlsoLikeMovies = response.data.youMayAlsoLike;
        _lastFetchTime = DateTime.now();
      } else {
        _error = MovieException(response.message ?? 'Failed to load movies');
      }
    } on MovieException catch (e) {
      _error = e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addToRecentlyWatched(MovieCategory movie) {
    if (movie.id == null) return;
    
    // Remove if already exists to avoid duplicates
    _recentlyWatched.removeWhere((m) => m.id == movie.id);
    _recentlyWatched.insert(0, movie);
    
    // Keep only the last 10 watched items
    if (_recentlyWatched.length > 10) {
      _recentlyWatched = _recentlyWatched.sublist(0, 10);
    }
    
    notifyListeners();
  }

  // Add this for search history support (append, do not remove other functions)
  void addToWatchHistory(MovieCategory movie) {
    _recentlyWatched.removeWhere((m) => m.id == movie.id);
    _recentlyWatched.insert(0, movie);
    if (_recentlyWatched.length > 20) {
      _recentlyWatched = _recentlyWatched.sublist(0, 20);
    }
    notifyListeners();
  }

  // Initialize the provider - call this when your app starts
  void loadWatchedMovies() {
    // If you want persistence, implement shared_preferences:
    /*
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('watchedMovies');
    if (data != null) {
      _watchedMovies = (json.decode(data) as List)
          .map((e) => MovieCategory.fromJson(e))
          .toList();
      notifyListeners();
    }
    */
    // For now, do nothing (in-memory only)
  }

  // Add a movie to watched list when it's played
  void addToWatched(MovieCategory movie) {
    if (!_watchedMovies.any((m) => m.id == movie.id)) {
      _watchedMovies.add(movie);
      notifyListeners();
    }
  }

  // New method to remove from watch history
  void removeFromWatched(MovieCategory movie) {
    _watchedMovies.removeWhere((m) => m.id == movie.id);
    notifyListeners();
  }

  // Save watched movies to storage
  Future<void> _saveWatchedMovies() async {
    // If you want persistence, implement shared_preferences:
    /*
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'watchedMovies',
      json.encode(_watchedMovies.map((m) => m.toJson()).toList()),
    );
    */
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  String _selectedCategory = "Recommended";

  String get selectedCategory => _selectedCategory;

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  List<MovieCategory> getMoviesByCategory() {
    switch (_selectedCategory) {
      case "Recommended":
        return recommendedMovies;
      case "Popular":
        return hotMovies;
      case "New":
        return newAndTrendingMovies;
      case "Asabawood":
        return youMayAlsoLikeMovies.where((movie) =>
          movie.genres.contains("Drama") ||
          movie.genres.contains("Romance")
        ).toList();
      case "Filipino":
        return youMayAlsoLikeMovies.where((movie) =>
          movie.title?.toLowerCase().contains("filipino") ?? false
        ).toList();
      case "Anime":
        return youMayAlsoLikeMovies.where((movie) =>
          movie.genres.contains("Animation")
        ).toList();
      case "Hindi":
        return youMayAlsoLikeMovies.where((movie) =>
          movie.title?.toLowerCase().contains("hindi") ?? false
        ).toList();
      default:
        return recommendedMovies;
    }
  }

  @override
  void dispose() {
    _movieService.dispose();
    super.dispose();
  }
}