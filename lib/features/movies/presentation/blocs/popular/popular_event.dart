import 'package:equatable/equatable.dart';

abstract class PopularEvent extends Equatable {
  const PopularEvent();

  @override
  List<Object?> get props => [];
}

class FetchPopularMovies extends PopularEvent {
  final bool isRefresh;

  const FetchPopularMovies({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class FetchMorePopularMovies extends PopularEvent {}
