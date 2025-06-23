import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class MovieService {
  static const String _baseUrl = 'https://linkskool.net/api/v3/public/movies/all';
  final http.Client _client;

  MovieService({http.Client? client}) : _client = client ?? http.Client();

  Future<MovieResponse> getMovies() async {
    try {
      final response = await _client.get(
        Uri.parse(_baseUrl),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 50));

      if (response.statusCode == 200) {
        return MovieResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
        throw MovieException(
          'Failed to load movies (Status ${response.statusCode})',
          response.statusCode,
        );
      }
    } on FormatException {
      throw const MovieException('Invalid API response format');
    } catch (e) {
      throw MovieException('Failed to load movies: ${e.toString()}');
    }
  }

  void dispose() {
    _client.close();
  }
}

class MovieException implements Exception {
  final String message;
  final int? statusCode;

  const MovieException(this.message, [this.statusCode]);

  @override
  String toString() => 'MovieException: $message${statusCode != null ? ' ($statusCode)' : ''}';
}