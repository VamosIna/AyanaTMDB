import 'package:flutter/foundation.dart';

class Env {
  static const String tmdbApiKey =
      String.fromEnvironment('TMDB_API_KEY', defaultValue: '');
  static const String baseUrl =
      String.fromEnvironment('BASE_URL', defaultValue: 'https://api.themoviedb.org/3');
  static const String bearerToken =
      String.fromEnvironment('TMDB_BEARER', defaultValue: '');
}
