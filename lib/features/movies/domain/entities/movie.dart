import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final int id;
  final String title;
  final String? originalTitle;
  final String? originalLanguage;
  final String? overview;
  final String? releaseDate;
  final String? posterPath;
  final String? backdropPath;
  final double? voteAverage;
  final int? voteCount;
  final double? popularity;
  final List<int>? genreIds;
  final bool? adult;
  final bool? video;

  const Movie({
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

  @override
  List<Object?> get props => [
        id,
        title,
        originalTitle,
        originalLanguage,
        overview,
        releaseDate,
        posterPath,
        backdropPath,
        voteAverage,
        voteCount,
        popularity,
        genreIds,
        adult,
        video,
      ];
}
