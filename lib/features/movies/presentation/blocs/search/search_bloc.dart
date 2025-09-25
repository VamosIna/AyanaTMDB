import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../domain/usecases/search_movies.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchMoviesBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMovies searchMovies;
  final List<String> _recentQueries = [];

  SearchMoviesBloc({required this.searchMovies}) : super(SearchInitial()) {
    on<SearchQueryChanged>(
      _onQueryChanged,
      transformer: (events, mapper) => events.debounceTime(const Duration(milliseconds: 400)).switchMap(mapper),
    );
    on<SearchClearRecent>((event, emit) {
      _recentQueries.clear();
      emit(SearchLoaded(results: const [], recentQueries: _recentQueries));
    });
    on<SearchAddRecent>((event, emit) {
      if (event.query.isNotEmpty && !_recentQueries.contains(event.query)) {
        _recentQueries.insert(0, event.query);
        if (_recentQueries.length > 10) _recentQueries.removeLast();
      }
      emit(SearchLoaded(results: state is SearchLoaded ? (state as SearchLoaded).results : [], recentQueries: _recentQueries));
    });
  }

  Future<void> _onQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }
    emit(SearchLoading());
    final result = await searchMovies.call(query);
    result.fold(
      (failure) => emit(SearchError(failure.toString())),
      (movies) {
        if (movies.isEmpty) {
          emit(SearchEmpty());
        } else {
          _recentQueries.remove(query);
          _recentQueries.insert(0, query);
          emit(SearchLoaded(results: movies, recentQueries: List.from(_recentQueries)));
        }
      },
    );
  }
}
