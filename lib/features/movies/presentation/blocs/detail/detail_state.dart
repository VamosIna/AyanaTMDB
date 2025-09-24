import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie_detail.dart';

abstract class DetailState extends Equatable {
  const DetailState();

  @override
  List<Object?> get props => [];
}

class DetailInitial extends DetailState {}

class DetailLoading extends DetailState {}

class DetailLoaded extends DetailState {
  final MovieDetail movie;
  const DetailLoaded(this.movie);

  @override
  List<Object?> get props => [movie];
}

class DetailError extends DetailState {
  final String message;
  const DetailError(this.message);

  @override
  List<Object?> get props => [message];
}

class DetailEmpty extends DetailState {}
