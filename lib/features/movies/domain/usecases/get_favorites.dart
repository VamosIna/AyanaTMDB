import 'package:ayana_tmdb/features/movies/domain/entities/movie.dart';
import 'package:ayana_tmdb/features/movies/domain/repositories/movies_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:ayana_tmdb/core/error/failures.dart';

class GetFavorites {
  final MoviesRepository repository;

  GetFavorites(this.repository);

  Future<Either<Failure, List<Movie>>> call() {
    return repository.getFavorites();
  }
}
