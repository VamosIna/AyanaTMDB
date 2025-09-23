import 'package:ayana_tmdb/features/movies/domain/entities/movie_detail.dart';
import 'package:ayana_tmdb/features/movies/domain/repositories/movies_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:ayana_tmdb/core/error/failures.dart';

class ToggleFavorite {
  final MoviesRepository repository;

  ToggleFavorite(this.repository);

  Future<Either<Failure, void>> call(MovieDetail movie) {
    return repository.toggleFavorite(movie);
  }
}
