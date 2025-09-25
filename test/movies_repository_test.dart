import 'package:flutter_test/flutter_test.dart';
import 'package:ayana_tmdb/features/movies/domain/repositories/movies_repository.dart';
import 'package:ayana_tmdb/features/movies/domain/entities/movie.dart';
import 'package:ayana_tmdb/features/movies/domain/entities/movie_detail.dart';
import 'package:ayana_tmdb/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:ayana_tmdb/core/error/failures.dart';
import 'package:dartz/dartz.dart';

class FakeMoviesRepository implements MoviesRepository {
  List<Movie> movies = [
    Movie(
      id: 1,
      title: 'Test Movie',
      overview: 'Overview',
      posterPath: '/test.jpg',
      voteAverage: 8.5,
      releaseDate: '2025-01-01',
    ),
  ];

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies() async {
    return Right(movies);
  }

  @override
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies() async => Right([]);

  @override
  Future<Either<Failure, List<Movie>>> getFavorites() async => Right([]);

  @override
  Future<Either<Failure, MovieDetail>> getMovieDetail(int id) async =>
      Right(MovieDetail(
        id: 1,
        title: 'Test Movie',
        overview: 'Overview',
        posterPath: '/test.jpg',
        voteAverage: 8.5,
        releaseDate: '2025-01-01',
        isFavorite: false,
        genres: [],
      ));

  @override
  Future<Either<Failure, List<Movie>>> getRecommendations(int id) async => Right([]);

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async => Right([]);

  @override
  Future<Either<Failure, void>> toggleFavorite(MovieDetail movie) async => const Right(null);
}

void main() {
  late GetPopularMovies usecase;
  late FakeMoviesRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeMoviesRepository();
    usecase = GetPopularMovies(fakeRepository);
  });

  test('should return list of movies from FakeMoviesRepository', () async {
    // act
    final result = await usecase();

    // assert
    expect(result.isRight(), true);
    result.fold(
      (failure) => fail('Expected Right but got Failure'),
      (movies) {
        expect(movies, isA<List<Movie>>());
        expect(movies.first.title, 'Test Movie');
      },
    );
  });
}
