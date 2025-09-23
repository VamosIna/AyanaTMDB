import 'package:ayana_tmdb/features/movies/domain/repositories/movies_repository.dart';
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

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies() async {
    try {
      final response = await remote.getPopularMovies();
      final movies = response.results.map((model) => model.toEntity()).toList();
      return Right(movies);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async {
    // TODO: Implement cache-first strategy
    return Left(ServerFailure('Not implemented'));
  }

  @override
  Future<Either<Failure, MovieDetail>> getMovieDetail(int id) async {
    // TODO: Implement cache-first strategy
    return Left(ServerFailure('Not implemented'));
  }

  @override
  Future<Either<Failure, List<Movie>>> getRecommendations(int movieId) async {
    // TODO: Implement cache-first strategy
    return Left(ServerFailure('Not implemented'));
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(MovieDetail movie) async {
    // TODO: Implement favorite toggle
    return Left(ServerFailure('Not implemented'));
  }

  @override
  Future<Either<Failure, List<Movie>>> getFavorites() async {
    // TODO: Implement get favorites
    return Left(ServerFailure('Not implemented'));
  }
}
