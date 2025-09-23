import 'package:hive/hive.dart';
import 'package:ayana_tmdb/features/movies/data/models/movie_model.dart';
import 'package:ayana_tmdb/features/movies/data/models/movie_detail_model.dart';

class MoviesLocalDataSource {
  static const String boxPopularMovies = 'popular_movies';
  static const String boxMovieDetailPrefix = 'movie_detail_';
  static const String boxFavorites = 'favorites';

  Future<void> cachePopularMovies(List<MovieModel> movies) async {
    final box = await Hive.openBox(boxPopularMovies);
    await box.put('data', movies.map((e) => e.toJson()).toList());
    await box.put('timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  Future<List<MovieModel>?> getCachedPopularMovies() async {
    final box = await Hive.openBox(boxPopularMovies);
    final data = box.get('data');
    if (data is List) {
      return data.map((e) => MovieModel.fromJson(Map<String, dynamic>.from(e))).toList();
    }
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
      return MovieDetailModel.fromJson(Map<String, dynamic>.from(data));
    }
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
