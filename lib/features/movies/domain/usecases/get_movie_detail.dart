import 'package:ayana_tmdb/features/movies/domain/entities/movie_detail.dart';
import 'package:ayana_tmdb/features/movies/domain/repositories/movies_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:ayana_tmdb/core/error/failures.dart';

class GetMovieDetail {
  final MoviesRepository repository;

  GetMovieDetail(this.repository);

  Future<Either<Failure, MovieDetail>> call(int id) {
    return repository.getMovieDetail(id);
  }
}
