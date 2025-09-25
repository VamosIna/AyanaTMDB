import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_movie_detail.dart';
import 'detail_event.dart';
import 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final GetMovieDetail getMovieDetail;

  DetailBloc({required this.getMovieDetail}) : super(DetailInitial()) {
    on<FetchMovieDetail>((event, emit) async {
      emit(DetailLoading());
      final result = await getMovieDetail.call(event.movieId);
      result.fold(
        (failure) => emit(DetailError(failure.toString())),
        (movie) => emit(DetailLoaded(movie)),
      );
    });
  }
}
