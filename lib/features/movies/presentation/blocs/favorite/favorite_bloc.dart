import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_favorites.dart';
import '../../../domain/usecases/toggle_favorite.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final GetFavorites getFavorites;
  final ToggleFavorite toggleFavorite;

  FavoriteBloc({required this.getFavorites, required this.toggleFavorite}) : super(FavoriteInitial()) {
    on<LoadFavorites>((event, emit) async {
      emit(FavoriteLoading());
      final result = await getFavorites.call();
      result.fold(
        (failure) => emit(FavoriteError(failure.toString())),
        (movies) {
          if (movies.isEmpty) {
            emit(FavoriteEmpty());
          } else {
            emit(FavoriteLoaded(movies));
          }
        },
      );
    });

    on<ToggleFavoriteStatus>((event, emit) async {
      final result = await toggleFavorite.call(event.movie);
      result.fold(
        (failure) => emit(FavoriteError(failure.toString())),
        (_) async {
          final reloadResult = await getFavorites();
          reloadResult.fold(
            (failure) => emit(FavoriteError(failure.toString())),
            (movies) {
              if (movies.isEmpty) {
                emit(FavoriteEmpty());
              } else {
                emit(FavoriteLoaded(movies));
              }
            },
          );
        },
      );
    });
  }
}
