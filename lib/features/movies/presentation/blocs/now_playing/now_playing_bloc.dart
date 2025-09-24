import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_now_playing_movies.dart';
import 'now_playing_event.dart';
import 'now_playing_state.dart';

class NowPlayingBloc extends Bloc<NowPlayingEvent, NowPlayingState> {
  final GetNowPlayingMovies getNowPlayingMovies;

  NowPlayingBloc({required this.getNowPlayingMovies}) : super(NowPlayingInitial()) {
    on<FetchNowPlayingMovies>((event, emit) async {
      emit(NowPlayingLoading());
      final result = await getNowPlayingMovies();
      result.fold(
        (failure) => emit(NowPlayingError(failure.toString())),
        (movies) {
          if (movies.isEmpty) {
            emit(NowPlayingEmpty());
          } else {
            emit(NowPlayingLoaded(movies));
          }
        },
      );
    });
  }
}
