import 'package:ayana_tmdb/features/movies/data/models/genre_model.dart';
import 'package:ayana_tmdb/features/movies/domain/repositories/movies_repository.dart';
import 'package:hive/hive.dart';
import 'package:ayana_tmdb/features/movies/data/datasources/movies_remote_ds.dart';
import 'package:ayana_tmdb/features/movies/data/datasources/movies_local_ds.dart';
import 'package:ayana_tmdb/features/movies/data/models/movie_detail_model.dart';
import 'package:ayana_tmdb/features/movies/domain/entities/movie.dart';
import 'package:ayana_tmdb/features/movies/domain/entities/movie_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:ayana_tmdb/core/error/failures.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  final MoviesRemoteDataSource remote;
  final MoviesLocalDataSource local;

  MoviesRepositoryImpl({required this.remote, required this.local});

  static const int cacheTTL = 60 * 60 * 1000; // 1 hour in ms

  // Helper: formatted failure message
  String _formatError(Object e, StackTrace st) {
    final stString = st.toString();
    final firstLine = stString
        .split('\n')
        .take(5)
        .join('\n'); // ringkas stacktrace
    return '${e.runtimeType}: ${e.toString()}\n$firstLine';

}

  Future<bool> _isPopularCacheValid() async {
    try {
      final boxName = MoviesLocalDataSource.boxPopularMovies;
      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openBox(boxName);
      }
      final box = Hive.box(boxName);
      final timestamp = box.get('timestamp');
      if (timestamp is int) {
        final now = DateTime.now().millisecondsSinceEpoch;
        return now - timestamp < cacheTTL;
      }
      return false;
    } catch (e, st) {
      // general guard
      // ignore: avoid_print
      print('[Error][_isPopularCacheValid] ${_formatError(e, st)}');
      return false;
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies() async {
    try {
      final isValid = await _isPopularCacheValid();
      if (isValid) {
        try {
          final cached = await local.getCachedNowPlayingMovies();
          if (cached != null && cached.isNotEmpty) {
            return Right(cached.map((e) => e.toEntity()).toList());
          }
        } catch (e, st) {
          // Jika baca cache gagal, log detail dan lanjut ke remote
          final msg = '[CacheReadError] ${_formatError(e, st)}';
          // ignore: avoid_print
          print(msg);
          // optionally return Left(CacheFailure(msg)); // jika ingin stop saat cache error
        }
      }

      // Ambil dari remote
      final response = await remote.getPopularMovies();
      try {
        await local.cachePopularMovies(response.results);
      } catch (e, st) {
        // Jika cache write gagal, log, tapi tetap kembalikan data dari remote
        final msg = '[CacheWriteError] ${_formatError(e, st)}';
        // ignore: avoid_print
        print(msg);
      }
      return Right(response.results.map((model) => model.toEntity()).toList());
    } catch (e, st) {
      final msg = '[ServerError][getPopularMovies] ${_formatError(e, st)}';
      return Left(ServerFailure(msg));
    }
  }

  Future<bool> _isNowPlayingCacheValid() async {
    try {
      final ts = await local.getNowPlayingMoviesTimestamp();
      if (ts != null) {
        final now = DateTime.now().millisecondsSinceEpoch;
        return now - ts < cacheTTL;
      }
      return false;
    } catch (e, st) {
      // log and treat as invalid cache
      // ignore: avoid_print
      print('[Error][_isNowPlayingCacheValid] ${_formatError(e, st)}');
      return false;
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies() async {
    try {
      final isValid = await _isNowPlayingCacheValid();
      if (isValid) {
        try {
          final cached = await local.getCachedNowPlayingMovies();
          if (cached != null && cached.isNotEmpty) {
            return Right(cached.map((e) => e.toEntity()).toList());
          }
        } catch (e, st) {
          // log and continue to remote
          final msg = '[CacheReadError] ${_formatError(e, st)}';
          // ignore: avoid_print
          print(msg);
        }
      }

      // Ambil dari remote
      final response = await remote.getNowPlayingMovies();
      try {
        await local.cacheNowPlayingMovies(response.results);
      } catch (e, st) {
        final msg = '[CacheWriteError] ${_formatError(e, st)}';
        // ignore: avoid_print
        print(msg);
      }
      return Right(response.results.map((model) => model.toEntity()).toList());
    } on HiveError catch (e, st) {
      final msg = '[HiveError][getNowPlayingMovies] ${_formatError(e, st)}';
      return Left(CacheFailure(msg));
    } catch (e, st) {
      final msg = '[ServerError][getNowPlayingMovies] ${_formatError(e, st)}';
      return Left(ServerFailure(msg));
    }
  }

  Future<bool> _isSearchCacheValid(String query) async {
    try {
      final ts = await local.getSearchMoviesTimestamp(query);
      if (ts != null) {
        final now = DateTime.now().millisecondsSinceEpoch;
        return now - ts < cacheTTL;
      }
      return false;
    } catch (e, st) {
      // ignore: avoid_print
      print('[Error][_isSearchCacheValid] ${_formatError(e, st)}');
      return false;
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async {
    try {
      final isValid = await _isSearchCacheValid(query);
      if (isValid) {
        try {
          final cached = await local.getCachedSearchMovies(query);
          if (cached != null && cached.isNotEmpty) {
            return Right(cached.map((e) => e.toEntity()).toList());
          }
        } catch (e, st) {
          // log and continue to remote
          final msg = '[CacheReadError] ${_formatError(e, st)}';
          // ignore: avoid_print
          print(msg);
        }
      }

      // Ambil dari remote
      final response = await remote.searchMovies(query);
      try {
        await local.cacheSearchMovies(query, response.results);
      } catch (e, st) {
        final msg = '[CacheWriteError] ${_formatError(e, st)}';
        // ignore: avoid_print
        print(msg);
      }
      return Right(response.results.map((model) => model.toEntity()).toList());
    } on HiveError catch (e, st) {
      final msg = '[HiveError][searchMovies] ${_formatError(e, st)}';
      return Left(CacheFailure(msg));
    } catch (e, st) {
      final msg = '[ServerError][searchMovies] ${_formatError(e, st)}';
      return Left(ServerFailure(msg));
    }
  }

  Future<bool> _isMovieDetailCacheValid(int id) async {
    try {
      final boxName = '${MoviesLocalDataSource.boxMovieDetailPrefix}$id';
      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openBox(boxName);
      }
      final box = Hive.box(boxName);
      final timestamp = box.get('timestamp');
      if (timestamp is int) {
        final now = DateTime.now().millisecondsSinceEpoch;
        return now - timestamp < cacheTTL;
      }
      return false;
    } on HiveError catch (e, st) {
      // ignore: avoid_print
      print('[HiveError][_isMovieDetailCacheValid] ${_formatError(e, st)}');
      return false;
    } catch (e, st) {
      // ignore: avoid_print
      print('[Error][_isMovieDetailCacheValid] ${_formatError(e, st)}');
      return false;
    }
  }

  @override
  Future<Either<Failure, MovieDetail>> getMovieDetail(int id) async {
    try {
      final isValid = await _isMovieDetailCacheValid(id);
      if (isValid) {
        try {
          final cached = await local.getCachedMovieDetail(id);
          if (cached != null) {
            return Right(cached.toEntity());
          }
        } catch (e, st) {
          final msg = '[CacheReadError] ${_formatError(e, st)}';
          // ignore: avoid_print
          print(msg);
        }
      }

      final response = await remote.getMovieDetail(id);
      try {
        await local.cacheMovieDetail(id, response);
      } catch (e, st) {
        final msg = '[CacheWriteError] ${_formatError(e, st)}';
        // ignore: avoid_print
        print(msg);
      }
      return Right(response.toEntity());
    } on HiveError catch (e, st) {
      final msg = '[HiveError][getMovieDetail] ${_formatError(e, st)}';
      return Left(CacheFailure(msg));
    } catch (e, st) {
      final msg = '[ServerError][getMovieDetail] ${_formatError(e, st)}';
      return Left(ServerFailure(msg));
    }
  }

  Future<bool> _isRecommendationsCacheValid(int movieId) async {
    try {
      final ts = await local.getRecommendationsTimestamp(movieId);
      if (ts != null) {
        final now = DateTime.now().millisecondsSinceEpoch;
        return now - ts < cacheTTL;
      }
      return false;
    } catch (e, st) {
      // ignore: avoid_print
      print('[Error][_isRecommendationsCacheValid] ${_formatError(e, st)}');
      return false;
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getRecommendations(int movieId) async {
    try {
      final isValid = await _isRecommendationsCacheValid(movieId);
      if (isValid) {
        try {
          final cached = await local.getCachedRecommendations(movieId);
          if (cached != null && cached.isNotEmpty) {
            return Right(cached.map((e) => e.toEntity()).toList());
          }
        } catch (e, st) {
          final msg = '[CacheReadError] ${_formatError(e, st)}';
          // ignore: avoid_print
          print(msg);
        }
      }

      // Ambil dari remote
      final response = await remote.getRecommendations(movieId);
      try {
        await local.cacheRecommendations(movieId, response);
      } catch (e, st) {
        final msg = '[CacheWriteError] ${_formatError(e, st)}';
        // ignore: avoid_print
        print(msg);
      }
      return Right(response.map((model) => model.toEntity()).toList());
    } on HiveError catch (e, st) {
      final msg = '[HiveError][getRecommendations] ${_formatError(e, st)}';
      return Left(CacheFailure(msg));
    } catch (e, st) {
      final msg = '[ServerError][getRecommendations] ${_formatError(e, st)}';
      return Left(ServerFailure(msg));
    }
  }
  

  @override
  Future<Either<Failure, void>> toggleFavorite(MovieDetail movie) async {
    try {
      final movieModel = MovieDetailModel(
        id: movie.id,
        title: movie.title,
        overview: movie.overview,
        posterPath: movie.posterPath,
        backdropPath: movie.backdropPath,
        voteAverage: movie.voteAverage,
        releaseDate: movie.releaseDate, genres: [
          for (var g in movie.genres) GenreModel(id: g.id, name: g.name)
        ], isFavorite:  !movie.isFavorite,
        // genreIds: movie.genres?.map((g) => g.id).toList() ?? [],
      );
      await local.toggleFavorite(movieModel);
      return const Right(null);
    } catch (e, st) {
      final msg = '[LocalError][toggleFavorite] ${_formatError(e, st)}';
      return Left(CacheFailure(msg));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getFavorites() async {
    try {
      final favorites = await local.getFavorites();
      return Right(favorites.map((e) => e.toEntity()).toList());
    } catch (e, st) {
      final msg = '[LocalError][getFavorites] ${_formatError(e, st)}';
      return Left(CacheFailure(msg));
    }
  }
}
