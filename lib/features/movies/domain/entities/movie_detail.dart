import 'package:equatable/equatable.dart';
import 'genre.dart';

class MovieDetail extends Equatable {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double voteAverage;
  final List<Genre> genres;
  final bool isFavorite;

  const MovieDetail({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.genres,
    required this.isFavorite,
  });

  @override
  List<Object?> get props =>
      [id, title, overview, posterPath, voteAverage, genres, isFavorite];
}
