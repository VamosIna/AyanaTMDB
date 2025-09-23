import 'package:json_annotation/json_annotation.dart';
import 'package:ayana_tmdb/features/movies/domain/entities/movie.dart';

part 'movie_model.g.dart';

@JsonSerializable()
class MovieModel {
  final int id;
  final String title;
  @JsonKey(name: 'original_title')
  final String? originalTitle;
  @JsonKey(name: 'original_language')
  final String? originalLanguage;
  @JsonKey(name: 'overview')
  final String? overview;
  @JsonKey(name: 'release_date')
  final String? releaseDate;
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  @JsonKey(name: 'vote_average')
  final double? voteAverage;
  @JsonKey(name: 'vote_count')
  final int? voteCount;
  @JsonKey(name: 'popularity')
  final double? popularity;
  @JsonKey(name: 'genre_ids')
  final List<int>? genreIds;
  final bool? adult;
  final bool? video;

  MovieModel({
    required this.id,
    required this.title,
    this.originalTitle,
    this.originalLanguage,
    this.overview,
    this.releaseDate,
    this.posterPath,
    this.backdropPath,
    this.voteAverage,
    this.voteCount,
    this.popularity,
    this.genreIds,
    this.adult,
    this.video,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);

  Movie toEntity() => Movie(
        id: id,
        title: title,
        posterPath: posterPath,
        voteAverage: voteAverage,
        overview: overview,
        releaseDate: releaseDate,
        backdropPath: backdropPath,
        genreIds: genreIds,
        originalTitle: originalTitle,
        originalLanguage: originalLanguage,
        voteCount: voteCount,
        popularity: popularity,
        adult: adult,
        video: video,
      );
}
