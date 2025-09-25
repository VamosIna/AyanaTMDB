import 'package:json_annotation/json_annotation.dart';
import 'package:ayana_tmdb/features/movies/domain/entities/movie_detail.dart';
import 'package:ayana_tmdb/features/movies/data/models/genre_model.dart';

part 'movie_detail_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MovieDetailModel {
  final int id;
  final String title;
  final String overview;
  @JsonKey(name: 'poster_path')
  final String posterPath;
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  @JsonKey(name: 'vote_average')
  final double voteAverage;
  final List<GenreModel> genres;
  @JsonKey(defaultValue: false)
  final bool isFavorite;
  @JsonKey(name: 'release_date')
  final String? releaseDate;
  final int? runtime;

  MovieDetailModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.genres,
    required this.isFavorite,
    this.releaseDate,
    this.runtime,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailModelFromJson(json);

  /// Use this when reading from Hive or any source that may have Map<dynamic, dynamic>
  static MovieDetailModel fromHive(dynamic data) {
    if (data is Map && data.isNotEmpty) {
      final json = Map<String, dynamic>.from(data);
      // Perbaiki field genres agar selalu List<Map<String, dynamic>>
      if (json['genres'] is List) {
        json['genres'] = (json['genres'] as List)
            .map((e) => e is Map ? Map<String, dynamic>.from(e) : e)
            .toList();
      }
      return MovieDetailModel.fromJson(json);
    }
    throw ArgumentError('Invalid data for MovieDetailModel.fromHive: $data');
  }

  Map<String, dynamic> toJson() => _$MovieDetailModelToJson(this);

  MovieDetail toEntity() => MovieDetail(
        id: id,
        title: title,
        overview: overview,
        posterPath: posterPath,
        backdropPath: backdropPath,
        voteAverage: voteAverage,
        genres: genres.map((g) => g.toEntity()).toList(),
        isFavorite: isFavorite,
        releaseDate: releaseDate,
        runtime: runtime,
      );
}
