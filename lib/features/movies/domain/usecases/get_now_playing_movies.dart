import 'package:dartz/dartz.dart';
import '../entities/movie.dart';
import '../repositories/movies_repository.dart';
import '../../../../core/error/failures.dart';

class GetNowPlayingMovies {
  final MoviesRepository repository;

  GetNowPlayingMovies(this.repository);

  Future<Either<Failure, List<Movie>>> call() {
    return repository.getNowPlayingMovies();
  }
}
