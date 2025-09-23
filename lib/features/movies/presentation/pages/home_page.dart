import 'package:ayana_tmdb/features/movies/presentation/widgets/movie_card_horizontal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/movie.dart';
import '../blocs/popular/popular_bloc.dart';
import '../blocs/popular/popular_event.dart';
import '../blocs/popular/popular_state.dart';
import '../widgets/movie_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  void _onInit(BuildContext context) {
    context.read<PopularBloc>().add(const FetchPopularMovies());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PopularBloc(getPopularMovies: RepositoryProvider.of(context))..add(const FetchPopularMovies()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Popular Movies'),
          actions: [
            // Placeholder filter button
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocBuilder<PopularBloc, PopularState>(
          builder: (context, state) {
            if (state is PopularLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PopularLoaded) {
              if (state.movies.isEmpty) {
                return const Center(child: Text('No movies found.'));
              }
              return GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: state.movies.length,
                itemBuilder: (context, index) {
                  final movie = state.movies[index];
                  return MovieCardHorizontal(movie: movie);
                },
              );
            } else if (state is PopularError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is PopularEmpty) {
              return const Center(child: Text('No movies found.'));
            }
            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/favorites');
          },
          child: const Icon(Icons.favorite),
          tooltip: 'Favorites',
        ),
      ),
    );
  }
}
