import 'package:ayana_tmdb/features/movies/presentation/widgets/movie_card_horizontal.dart';
import 'package:ayana_tmdb/features/movies/presentation/widgets/section_horizontal_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/movie.dart';
import '../blocs/popular/popular_bloc.dart';
import '../blocs/popular/popular_event.dart';
import '../blocs/popular/popular_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PopularBloc(getPopularMovies: RepositoryProvider.of(context))..add(const FetchPopularMovies()),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('AYANA MOVIE', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 24, letterSpacing: 2)),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            // Section: Continue Watching (placeholder)
            SectionHorizontalList(
              title: 'YOUR WATCHLIST',
              movies: const [],
              itemBuilder: (context, movie) {
                // Placeholder: bisa diisi MovieCardHorizontal dengan overlay progress
                return MovieCardHorizontal(movie: movie);
              },
            ),
            // Section: Popular
            BlocBuilder<PopularBloc, PopularState>(
              builder: (context, state) {
                if (state is PopularLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is PopularLoaded) {
                  if (state.movies.isEmpty) {
                    return const Center(child: Text('No movies found.', style: TextStyle(color: Colors.white)));
                  }
                  return SectionHorizontalList(
                    title: 'Popular on Netflix',
                    movies: state.movies,
                    itemBuilder: (context, movie) => MovieCardHorizontal(movie: movie),
                  );
                } else if (state is PopularError) {
                  return Center(child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.white)));
                } else if (state is PopularEmpty) {
                  return const Center(child: Text('No movies found.', style: TextStyle(color: Colors.white)));
                }
                return const SizedBox.shrink();
              },
            ),
            // Section: Trending (placeholder)
            SectionHorizontalList(
              title: 'Trending Now',
              movies: const [],
              itemBuilder: (context, movie) => MovieCardHorizontal(movie: movie),
            ),
          ],
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
