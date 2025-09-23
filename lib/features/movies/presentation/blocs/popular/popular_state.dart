import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';

abstract class PopularState extends Equatable {
  const PopularState();

  @override
  List<Object?> get props => [];
}

class PopularInitial extends PopularState {}

class PopularLoading extends PopularState {
  final bool isRefresh;
  const PopularLoading({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class PopularLoaded extends PopularState {
  final List<Movie> movies;
  final bool hasReachedMax;

  const PopularLoaded({
    required this.movies,
    required this.hasReachedMax,
  });

  PopularLoaded copyWith({
    List<Movie>? movies,
    bool? hasReachedMax,
  }) {
    return PopularLoaded(
      movies: movies ?? this.movies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [movies, hasReachedMax];
}

class PopularError extends PopularState {
  final String message;

  const PopularError(this.message);

  @override
  List<Object?> get props => [message];
}

class PopularEmpty extends PopularState {}
