import 'package:equatable/equatable.dart';
import 'genre.dart';

class MovieDetail extends Equatable {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String? backdropPath;
  final double voteAverage;
  final List<Genre> genres;
  final bool isFavorite;
  final String? releaseDate;
  final int? runtime;

  const MovieDetail({
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

  @override
  List<Object?> get props =>
      [id, title, overview, posterPath, backdropPath, voteAverage, genres, isFavorite, releaseDate, runtime];
}
