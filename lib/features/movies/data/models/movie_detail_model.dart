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
  @JsonKey(name: 'vote_average')
  final double voteAverage;
  final List<GenreModel> genres;
  final bool isFavorite;

  MovieDetailModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.genres,
    required this.isFavorite,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieDetailModelToJson(this);

  MovieDetail toEntity() => MovieDetail(
        id: id,
        title: title,
        overview: overview,
        posterPath: posterPath,
        voteAverage: voteAverage,
        genres: genres.map((g) => g.toEntity()).toList(),
        isFavorite: isFavorite,
      );
}
