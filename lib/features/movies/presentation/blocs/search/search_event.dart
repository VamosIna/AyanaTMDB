import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String query;
  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchClearRecent extends SearchEvent {}

class SearchAddRecent extends SearchEvent {
  final String query;
  const SearchAddRecent(this.query);

  @override
  List<Object?> get props => [query];
}
