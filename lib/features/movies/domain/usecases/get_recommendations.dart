import 'package:ayana_tmdb/features/movies/domain/entities/movie.dart';
import 'package:ayana_tmdb/features/movies/domain/repositories/movies_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:ayana_tmdb/core/error/failures.dart';

class GetRecommendations {
  final MoviesRepository repository;

  GetRecommendations(this.repository);

  Future<Either<Failure, List<Movie>>> call(int movieId) {
    return repository.getRecommendations(movieId);
  }
}
