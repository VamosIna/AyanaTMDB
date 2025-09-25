import 'package:ayana_tmdb/features/movies/domain/usecases/get_now_playing_movies.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:ayana_tmdb/core/network/dio_client.dart';

import 'package:ayana_tmdb/features/movies/data/datasources/movies_remote_ds.dart';
import 'package:ayana_tmdb/features/movies/data/datasources/movies_local_ds.dart';
import 'package:ayana_tmdb/features/movies/data/repositories/movies_repository_impl.dart';
import 'package:ayana_tmdb/features/movies/domain/repositories/movies_repository.dart';
import 'package:ayana_tmdb/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:ayana_tmdb/features/movies/domain/usecases/search_movies.dart';
import 'package:ayana_tmdb/features/movies/domain/usecases/get_movie_detail.dart';
import 'package:ayana_tmdb/features/movies/domain/usecases/get_recommendations.dart';
import 'package:ayana_tmdb/features/movies/domain/usecases/toggle_favorite.dart';
import 'package:ayana_tmdb/features/movies/domain/usecases/get_favorites.dart';
import 'package:ayana_tmdb/features/movies/presentation/blocs/favorite/favorite_bloc.dart';
import 'package:ayana_tmdb/features/movies/presentation/blocs/search/search_bloc.dart' show SearchMoviesBloc;

final sl = GetIt.instance;

Future<void> init() async {
  // Register Dio
  sl.registerLazySingleton<Dio>(() => DioClient.create());

  // Data sources
  sl.registerLazySingleton<MoviesRemoteDataSource>(
    () => MoviesRemoteDataSource(sl<Dio>()),
  );
  sl.registerLazySingleton<MoviesLocalDataSource>(
    () => MoviesLocalDataSource(),
  );

  // Repository
  sl.registerLazySingleton<MoviesRepository>(
    () => MoviesRepositoryImpl(
      remote: sl<MoviesRemoteDataSource>(),
      local: sl<MoviesLocalDataSource>(),
    ),
  );

  // Usecases
  sl.registerLazySingleton(() => GetPopularMovies(sl()));
  sl.registerLazySingleton(() => GetNowPlayingMovies(sl()));
  sl.registerLazySingleton(() => SearchMovies(sl()));
  sl.registerLazySingleton(() => GetMovieDetail(sl()));
  sl.registerLazySingleton(() => GetRecommendations(sl()));
  sl.registerLazySingleton(() => ToggleFavorite(sl()));
  sl.registerLazySingleton(() => GetFavorites(sl()));

  // Blocs
  sl.registerFactory(() => FavoriteBloc(getFavorites: sl(), toggleFavorite: sl()));
  sl.registerFactory(() => SearchMoviesBloc(searchMovies: sl()));
}
