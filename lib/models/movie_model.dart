class MovieResponse {
  final bool success;
  final MovieData data;
  final String? message; // For potential error messages

  MovieResponse({
    required this.success,
    required this.data,
    this.message,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    return MovieResponse(
      success: json['success'] as bool? ?? false,
      data: MovieData.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );
  }
}

class MovieData {
  final List<MovieCategory> hot;
  final List<MovieCategory> recommended;
  final List<MovieCategory> newAndTrending;
  final List<MovieCategory> youMayAlsoLike;

  MovieData({
    required this.hot,
    required this.recommended,
    required this.newAndTrending,
    required this.youMayAlsoLike,
  });

  factory MovieData.fromJson(Map<String, dynamic> json) {
    return MovieData(
      hot: _parseMovieList(json['hot']),
      recommended: _parseMovieList(json['recommended']),
      newAndTrending: _parseMovieList(json['new_and_trending']),
      youMayAlsoLike: _parseMovieList(json['you_may_also_like']),
    );
  }

  static List<MovieCategory> _parseMovieList(dynamic jsonList) {
    if (jsonList is! List) return [];
    return jsonList
        .map<MovieCategory>((e) => MovieCategory.fromJson(e as Map<String, dynamic>))
        .where((movie) => movie.id != null) // Filter out invalid movies
        .toList();
  }
}

class MovieCategory {
  final int? id;
  final String? title;
  final String? description;
  final List<String> genres;
  final String? posterPortrait;
  final String? posterLandscape;
  final String? videoUrl;
  final bool hasSubSeries;
  final List<Episode> episodes;

  MovieCategory({
    this.id,
    this.title,
    this.description,
    this.genres = const [],
    this.posterPortrait,
    this.posterLandscape,
    this.videoUrl,
    this.hasSubSeries = false,
    this.episodes = const [],
  });

  factory MovieCategory.fromJson(Map<String, dynamic> json) {
    return MovieCategory(
      id: json['id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      genres: (json['genres'] as List<dynamic>?)?.cast<String>() ?? [],
      posterPortrait: json['poster_portrait'] as String?,
      posterLandscape: json['poster_landscape'] as String?,
      videoUrl: json['video_url'] as String?,
      hasSubSeries: json['has_sub_series'] as bool? ?? false,
      episodes: _parseEpisodes(json['episodes']),
    );
  }

  static List<Episode> _parseEpisodes(dynamic jsonList) {
    if (jsonList is! List) return [];
    return jsonList
        .map<Episode>((e) => Episode.fromJson(e as Map<String, dynamic>))
        .where((episode) => episode.videoUrl != null) // Filter out invalid episodes
        .toList();
  }

  bool get hasVideo => episodes.isNotEmpty && episodes.first.videoUrl != null;
}

class Episode {
  final String? title;
  final String? videoUrl;

  Episode({
    this.title,
    this.videoUrl,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      title: json['title'] as String?,
      videoUrl: json['video_url'] as String?,
    );
  }
}