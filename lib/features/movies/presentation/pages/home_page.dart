import 'package:ayana_tmdb/features/movies/presentation/widgets/movie_card_horizontal.dart';
import 'package:ayana_tmdb/features/movies/presentation/widgets/section_horizontal_list.dart';
import 'package:ayana_tmdb/features/movies/presentation/widgets/hero_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/movie.dart';
import '../blocs/popular/popular_bloc.dart';
import '../blocs/popular/popular_event.dart';
import '../blocs/popular/popular_state.dart';
import '../blocs/now_playing/now_playing_bloc.dart';
import '../blocs/now_playing/now_playing_event.dart';
import '../blocs/now_playing/now_playing_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PopularBloc(getPopularMovies: RepositoryProvider.of(context))..add(const FetchPopularMovies()),
        ),
        BlocProvider(
          create: (context) => NowPlayingBloc(getNowPlayingMovies: RepositoryProvider.of(context))..add(const FetchNowPlayingMovies()),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('AYANA MOVIE', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 24, letterSpacing: 2)),
          centerTitle: true,
        ),
        body: BlocBuilder<PopularBloc, PopularState>(
          builder: (context, state) {
            List<Widget> children = [];
            if (state is PopularLoading) {
              children.add(const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: CircularProgressIndicator()),
              ));
            } else if (state is PopularLoaded && state.movies.isNotEmpty) {
              // HeroCarousel di atas
              children.add(
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: HeroCarousel(movies: state.movies),
                ),
              );
              // Section: Popular
              children.add(
                SectionHorizontalList(
                  title: 'Popular on Netflix',
                  movies: state.movies,
                  itemBuilder: (context, movie) => GestureDetector(
                    onTap: () {
                      context.go('/movie/${movie.id}');
                    },
                    child: MovieCardHorizontal(movie: movie),
                  ),
                ),
              );
            } else if (state is PopularError) {
              children.add(Center(child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.white))));
            } else if (state is PopularEmpty || (state is PopularLoaded && state.movies.isEmpty)) {
              children.add(const Center(child: Text('No movies found.', style: TextStyle(color: Colors.white))));
            }
            // Section: Continue Watching (placeholder)
            children.insert(0, SectionHorizontalList(
              title: 'YOUR WATCHLIST',
              movies: const [],
              itemBuilder: (context, movie) => MovieCardHorizontal(movie: movie),
            ));
            // Section: Trending Now (API)
            children.add(
              BlocBuilder<NowPlayingBloc, NowPlayingState>(
                builder: (context, state) {
                  if (state is NowPlayingLoading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (state is NowPlayingLoaded) {
                    return SectionHorizontalList(
                      title: 'Trending Now',
                      movies: state.movies,
                      itemBuilder: (context, movie) => GestureDetector(
                        onTap: () {
                          context.go('/movie/${movie.id}');
                        },
                        child: MovieCardHorizontal(movie: movie),
                      ),
                    );
                  } else if (state is NowPlayingError) {
                    return Center(child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.white)));
                  } else if (state is NowPlayingEmpty) {
                    return const Center(child: Text('No trending movies found.', style: TextStyle(color: Colors.white)));
                  }
                  return const SizedBox.shrink();
                },
              ),
            );
            return ListView(children: children);
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          // selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          enableFeedback: false,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.download), label: 'Downloads'),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'More'),
          ],
          currentIndex: 0,
          onTap: (index) {
            // TODO: Implement navigation for other tabs
          },
        ),
      ),
    );
  }
}
