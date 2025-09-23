import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/get_popular_movies.dart';
import 'popular_event.dart';
import 'popular_state.dart';

const int _pageSize = 20;
const Duration _throttleDuration = Duration(milliseconds: 300);

EventTransformer<E> throttleDroppable<E>() {
  return (events, mapper) =>
      events.throttle(_throttleDuration).switchMap(mapper);
}

class PopularBloc extends Bloc<PopularEvent, PopularState> {
  final GetPopularMovies getPopularMovies;

  int _currentPage = 1;
  bool _hasReachedMax = false;
  List<Movie> _movies = [];

  PopularBloc({required this.getPopularMovies}) : super(PopularInitial()) {
    on<FetchPopularMovies>(_onFetchPopularMovies, transformer: throttleDroppable());
    on<FetchMorePopularMovies>(_onFetchMorePopularMovies, transformer: throttleDroppable());
  }

  Future<void> _onFetchPopularMovies(
    FetchPopularMovies event,
    Emitter<PopularState> emit,
  ) async {
    emit(PopularLoading(isRefresh: event.isRefresh));
    _currentPage = 1;
    _hasReachedMax = false;
    _movies = [];
    final result = await getPopularMovies.call();
    result.fold(
      (failure) => emit(PopularError('${failure.message}')),
      (movies) {
        if (movies.isEmpty) {
          emit(PopularEmpty());
        } else {
          _movies = movies;
          _hasReachedMax = movies.length < _pageSize;
          emit(PopularLoaded(movies: _movies, hasReachedMax: _hasReachedMax));
        }
      },
    );
  }

  Future<void> _onFetchMorePopularMovies(
    FetchMorePopularMovies event,
    Emitter<PopularState> emit,
  ) async {
    if (_hasReachedMax || state is PopularLoading) return;
    emit(PopularLoading(isRefresh: false));
    final nextPage = _currentPage + 1;
    final result = await getPopularMovies.call();
    result.fold(
      (failure) => emit(PopularError('${failure.message}')),
      (movies) {
        if (movies.isEmpty) {
          _hasReachedMax = true;
        } else {
          _currentPage = nextPage;
          _movies.addAll(movies);
          _hasReachedMax = movies.length < _pageSize;
        }
        emit(PopularLoaded(movies: _movies, hasReachedMax: _hasReachedMax));
      },
    );
  }
}
