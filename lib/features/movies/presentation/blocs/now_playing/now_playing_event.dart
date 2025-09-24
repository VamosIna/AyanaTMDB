import 'package:equatable/equatable.dart';

abstract class NowPlayingEvent extends Equatable {
  const NowPlayingEvent();

  @override
  List<Object?> get props => [];
}

class FetchNowPlayingMovies extends NowPlayingEvent {
  const FetchNowPlayingMovies();
}
