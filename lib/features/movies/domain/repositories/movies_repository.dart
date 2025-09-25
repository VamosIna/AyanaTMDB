import 'package:ayana_tmdb/features/movies/domain/entities/movie.dart';
import 'package:ayana_tmdb/features/movies/domain/entities/movie_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:ayana_tmdb/core/error/failures.dart';

abstract class MoviesRepository {
  Future<Either<Failure, List<Movie>>> getPopularMovies();
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies();
  Future<Either<Failure, List<Movie>>> searchMovies(String query);
  Future<Either<Failure, MovieDetail>> getMovieDetail(int id);
  Future<Either<Failure, List<Movie>>> getRecommendations(int movieId);
  Future<Either<Failure, void>> toggleFavorite(MovieDetail movie);
  Future<Either<Failure, List<Movie>>> getFavorites();
}
