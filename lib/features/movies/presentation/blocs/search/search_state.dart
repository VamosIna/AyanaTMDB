import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Movie> results;
  final List<String> recentQueries;
  const SearchLoaded({required this.results, required this.recentQueries});

  @override
  List<Object?> get props => [results, recentQueries];
}

class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}

class SearchEmpty extends SearchState {}
