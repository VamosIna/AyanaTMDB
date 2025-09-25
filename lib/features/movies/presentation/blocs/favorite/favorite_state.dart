import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<Movie> movies;
  const FavoriteLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

class FavoriteError extends FavoriteState {
  final String message;
  const FavoriteError(this.message);

  @override
  List<Object?> get props => [message];
}

class FavoriteEmpty extends FavoriteState {}
