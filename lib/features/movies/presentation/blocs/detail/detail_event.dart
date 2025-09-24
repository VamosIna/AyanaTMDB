import 'package:equatable/equatable.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchMovieDetail extends DetailEvent {
  final int movieId;
  const FetchMovieDetail(this.movieId);

  @override
  List<Object?> get props => [movieId];
}
