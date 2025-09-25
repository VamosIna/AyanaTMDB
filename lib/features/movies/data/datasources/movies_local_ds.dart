import 'package:hive/hive.dart';
import 'package:ayana_tmdb/features/movies/data/models/movie_model.dart';
import 'package:ayana_tmdb/features/movies/data/models/movie_detail_model.dart';

class MoviesLocalDataSource {
  static const String boxPopularMovies = 'popular_movies';
  static const String boxNowPlayingMovies = 'now_playing_movies';
  static const String boxMovieDetailPrefix = 'movie_detail_';
  static const String boxFavorites = 'favorites';
  static const String boxSearchMovies = 'search_movies';

  Future<void> cachePopularMovies(List<MovieModel> movies) async {
    final box = await Hive.openBox(boxPopularMovies);
    await box.put('data', movies.map((e) => e.toJson()).toList());
    await box.put('timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> toggleFavorite(MovieDetailModel movieDetail) async {
    try {
      print('[HIVE] toggleFavorite called for movieId ${movieDetail.id}');
      final favoriteIds = await getFavoriteIds();
      final movieId = movieDetail.id;
      final box = await Hive.openBox(boxFavorites);
      print('[HIVE] Current favoriteIds before: $favoriteIds');
      if (favoriteIds.contains(movieId)) {
        favoriteIds.remove(movieId);
        await box.delete(movieId);
        print('[HIVE] Removed movieId $movieId from favorites');
      } else {
        favoriteIds.add(movieId);
        // Konversi MovieDetailModel ke MovieModel (hanya field yang diperlukan)
        final movieModel = MovieModel(
          id: movieDetail.id,
          title: movieDetail.title,
          originalTitle: null,
          originalLanguage: null,
          overview: movieDetail.overview,
          releaseDate: movieDetail.releaseDate,
          posterPath: movieDetail.posterPath,
          backdropPath: movieDetail.backdropPath,
          voteAverage: movieDetail.voteAverage,
          voteCount: null,
          popularity: null,
          genreIds: movieDetail.genres.map((g) => g.id).toList(),
          adult: null,
          video: null,
        );
        await box.put(movieId, movieModel.toJson());
        print('[HIVE] Added movieId $movieId to favorites: ${movieModel.title}');
      }
      await saveFavoriteIds(favoriteIds);
      print('[HIVE] Updated favoriteIds after: $favoriteIds');
      print('[HIVE] toggleFavorite completed for movieId $movieId');
    } catch (e, st) {
      print('[HIVE][ERROR] toggleFavorite failed for movieId ${movieDetail.id}: $e\n$st');
      rethrow;
    }
  }

  Future<List<MovieModel>> getFavorites() async {
    final favoriteIds = await getFavoriteIds();
    final box = await Hive.openBox(boxFavorites);
    final List<MovieModel> favorites = [];
    for (final id in favoriteIds) {
      final data = box.get(id);
      if (data != null && data is Map) {
        try {
          favorites.add(MovieModel.fromJson(Map<String, dynamic>.from(data)));
        } catch (e, st) {
          print('[HIVE][ERROR] Failed to parse favorite movie for id $id: $e\n$st');
        }
      }
    }
    return favorites;
  }

  Future<void> cacheNowPlayingMovies(List<MovieModel> movies) async {
    final box = await Hive.openBox(boxNowPlayingMovies);
    await box.put('data', movies.map((e) => e.toJson()).toList());
    await box.put('timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  Future<List<MovieModel>?> getCachedNowPlayingMovies({int ttlMs = 3600000}) async {
    final box = await Hive.openBox(boxNowPlayingMovies);
    final data = box.get('data');
    final ts = box.get('timestamp');
    if (data is List && ts is int) {
      final age = DateTime.now().millisecondsSinceEpoch - ts;
      if (age <= ttlMs) {
        try {
          return data.map((e) => MovieModel.fromJson(Map<String, dynamic>.from(e))).toList();
        } catch (e, st) {
          print('[HIVE][ERROR] Failed to parse now playing movie: $e\n$st');
          return null;
        }
      } else {
        print('[HIVE] Cached now playing movies expired (age=$age ms)');
      }
    }
    return null;
  }

  Future<int?> getNowPlayingMoviesTimestamp() async {
    final box = await Hive.openBox(boxNowPlayingMovies);
    final ts = box.get('timestamp');
    if (ts is int) return ts;
    return null;
  }

  Future<void> cacheMovieDetail(int id, MovieDetailModel detail) async {
    final box = await Hive.openBox('$boxMovieDetailPrefix$id');
    await box.put('data', detail.toJson());
    await box.put('timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  Future<MovieDetailModel?> getCachedMovieDetail(int id) async {
    final box = await Hive.openBox('$boxMovieDetailPrefix$id');
    final data = box.get('data');
    if (data is Map) {
      return MovieDetailModel.fromHive(data);
    }
    return null;
  }

  Future<void> cacheRecommendations(int movieId, List<MovieModel> movies) async {
    final box = await Hive.openBox('recommendations_$movieId');
    await box.put('data', movies.map((e) => e.toJson()).toList());
    await box.put('timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  Future<List<MovieModel>?> getCachedRecommendations(int movieId) async {
    final box = await Hive.openBox('recommendations_$movieId');
    final data = box.get('data');
    if (data is List) {
      return data.map((e) => MovieModel.fromJson(Map<String, dynamic>.from(e))).toList();
    }
    return null;
  }

  Future<int?> getRecommendationsTimestamp(int movieId) async {
    final box = await Hive.openBox('recommendations_$movieId');
    final ts = box.get('timestamp');
    if (ts is int) return ts;
    return null;
  }

  Future<void> cacheSearchMovies(String query, List<MovieModel> movies) async {
    final box = await Hive.openBox(boxSearchMovies);
    await box.put(query, movies.map((e) => e.toJson()).toList());
    await box.put('timestamp_$query', DateTime.now().millisecondsSinceEpoch);
  }

  Future<List<MovieModel>?> getCachedSearchMovies(String query) async {
    final box = await Hive.openBox(boxSearchMovies);
    final data = box.get(query);
    if (data is List) {
      return data.map((e) => MovieModel.fromJson(Map<String, dynamic>.from(e))).toList();
    }
    return null;
  }

  Future<int?> getSearchMoviesTimestamp(String query) async {
    final box = await Hive.openBox(boxSearchMovies);
    final ts = box.get('timestamp_$query');
    if (ts is int) return ts;
    return null;
  }

  Future<void> saveFavoriteIds(Set<int> ids) async {
    final box = await Hive.openBox(boxFavorites);
    await box.put('ids', ids.toList());
  }

  Future<Set<int>> getFavoriteIds() async {
    final box = await Hive.openBox(boxFavorites);
    final ids = box.get('ids');
    if (ids is List) {
      return ids.cast<int>().toSet();
    }
    return {};
  }
}
