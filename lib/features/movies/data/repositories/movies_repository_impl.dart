import 'package:ayana_tmdb/features/movies/domain/repositories/movies_repository.dart';
import 'package:hive/hive.dart';
import 'package:ayana_tmdb/features/movies/data/datasources/movies_remote_ds.dart';
import 'package:ayana_tmdb/features/movies/data/datasources/movies_local_ds.dart';
import 'package:ayana_tmdb/features/movies/data/models/movie_model.dart';
import 'package:ayana_tmdb/features/movies/data/models/movie_detail_model.dart';
import 'package:ayana_tmdb/features/movies/domain/entities/movie.dart';
import 'package:ayana_tmdb/features/movies/domain/entities/movie_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:ayana_tmdb/core/error/failures.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  final MoviesRemoteDataSource remote;
  final MoviesLocalDataSource local;

  MoviesRepositoryImpl({
    required this.remote,
    required this.local,
  });

  static const int cacheTTL = 60 * 60 * 1000; // 1 hour in ms

  Future<bool> _isPopularCacheValid() async {
    final box = await Hive.openBox(MoviesLocalDataSource.boxPopularMovies);
    final timestamp = box.get('timestamp');
    if (timestamp is int) {
      final now = DateTime.now().millisecondsSinceEpoch;
      return now - timestamp < cacheTTL;
    }
    return false;
  }

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies() async {
    try {
      final isValid = await _isPopularCacheValid();
      if (isValid) {
        final cached = await local.getCachedNowPlayingMovies();
        if (cached != null && cached.isNotEmpty) {
          return Right(cached.map((e) => e.toEntity()).toList());
        }
      }
      final response = await remote.getPopularMovies();
      await local.cachePopularMovies(response.results);
      return Right(response.results.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<bool> _isNowPlayingCacheValid() async {
    final ts = await local.getNowPlayingMoviesTimestamp();
    if (ts != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      return now - ts < cacheTTL;
    }
    return false;
  }

  @override
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies() async {
    try {
      final isValid = await _isNowPlayingCacheValid();
      if (isValid) {
        final cached = await local.getCachedNowPlayingMovies();
        if (cached != null && cached.isNotEmpty) {
          return Right(cached.map((e) => e.toEntity()).toList());
        }
      }
      final response = await remote.getNowPlayingMovies();
      await local.cacheNowPlayingMovies(response.results);
      return Right(response.results.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<bool> _isSearchCacheValid(String query) async {
    final ts = await local.getSearchMoviesTimestamp(query);
    if (ts != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      return now - ts < cacheTTL;
    }
    return false;
  }

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async {
    try {
      final isValid = await _isSearchCacheValid(query);
      if (isValid) {
        final cached = await local.getCachedSearchMovies(query);
        if (cached != null && cached.isNotEmpty) {
          return Right(cached.map((e) => e.toEntity()).toList());
        }
      }
      final response = await remote.searchMovies(query);
      await local.cacheSearchMovies(query, response);
      return Right(response.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<bool> _isMovieDetailCacheValid(int id) async {
    final box = await Hive.openBox('${MoviesLocalDataSource.boxMovieDetailPrefix}$id');
    final timestamp = box.get('timestamp');
    if (timestamp is int) {
      final now = DateTime.now().millisecondsSinceEpoch;
      return now - timestamp < cacheTTL;
    }
    return false;
  }

  @override
  Future<Either<Failure, MovieDetail>> getMovieDetail(int id) async {
    try {
      final isValid = await _isMovieDetailCacheValid(id);
      if (isValid) {
        final cached = await local.getCachedMovieDetail(id);
        if (cached != null) {
          return Right(cached.toEntity());
        }
      }
      final response = await remote.getMovieDetail(id);
      await local.cacheMovieDetail(id, response);
      return Right(response.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<bool> _isRecommendationsCacheValid(int movieId) async {
    final ts = await local.getRecommendationsTimestamp(movieId);
    if (ts != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      return now - ts < cacheTTL;
    }
    return false;
  }

  @override
  Future<Either<Failure, List<Movie>>> getRecommendations(int movieId) async {
    try {
      final isValid = await _isRecommendationsCacheValid(movieId);
      if (isValid) {
        final cached = await local.getCachedRecommendations(movieId);
        if (cached != null && cached.isNotEmpty) {
          return Right(cached.map((e) => e.toEntity()).toList());
        }
      }
      final response = await remote.getRecommendations(movieId);
      await local.cacheRecommendations(movieId, response);
      return Right(response.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(MovieDetail movie) async {
    try {
      final ids = await local.getFavoriteIds();
      if (ids.contains(movie.id)) {
        ids.remove(movie.id);
      } else {
        ids.add(movie.id);
      }
      await local.saveFavoriteIds(ids);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getFavorites() async {
    try {
      final ids = await local.getFavoriteIds();
      List<Movie> movies = [];
      for (final id in ids) {
        MovieDetailModel? detailModel = await local.getCachedMovieDetail(id);
        if (detailModel == null) {
          detailModel = await remote.getMovieDetail(id);
          await local.cacheMovieDetail(id, detailModel);
        }
        final detail = detailModel.toEntity();
        movies.add(Movie(
          id: detail.id,
          title: detail.title,
          overview: detail.overview,
          posterPath: detail.posterPath,
          voteAverage: detail.voteAverage,
          genreIds: detail.genres.map((g) => g.id).toList(),
        ));
      }
      return Right(movies);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
