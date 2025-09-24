import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:ayana_tmdb/features/movies/data/models/movie_model.dart';
import 'package:ayana_tmdb/features/movies/data/models/movie_detail_model.dart';
import 'package:ayana_tmdb/features/movies/data/models/movie_list_response.dart';

part 'movies_remote_ds.g.dart';

@RestApi()
abstract class MoviesRemoteDataSource {
  factory MoviesRemoteDataSource(Dio dio, {String baseUrl}) = _MoviesRemoteDataSource;

  @GET('/movie/popular')
  Future<MovieListResponse> getPopularMovies();

  @GET('/movie/now_playing')
  Future<MovieListResponse> getNowPlayingMovies();

  @GET('/search/movie')
  Future<List<MovieModel>> searchMovies(@Query('query') String query);

  @GET('/movie/{movie_id}')
  Future<MovieDetailModel> getMovieDetail(@Path('movie_id') int id);

  @GET('/movie/{movie_id}/recommendations')
  Future<List<MovieModel>> getRecommendations(@Path('movie_id') int id);
}
