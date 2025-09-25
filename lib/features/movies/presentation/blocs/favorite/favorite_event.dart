import 'package:ayana_tmdb/features/movies/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoriteEvent {}

class ToggleFavoriteStatus extends FavoriteEvent {
  final MovieDetail movie;
  const ToggleFavoriteStatus(this.movie);

  @override
  List<Object?> get props => [movie];
}
