import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/movie_detail.dart';
import '../blocs/favorite/favorite_bloc.dart';
import '../blocs/favorite/favorite_event.dart';
import '../blocs/favorite/favorite_state.dart';
import '../widgets/movie_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteBloc(
        getFavorites: RepositoryProvider.of(context),
        toggleFavorite: RepositoryProvider.of(context),
      )..add(LoadFavorites()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My List'),
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        body: BlocBuilder<FavoriteBloc, FavoriteState>(
          builder: (context, state) {
            if (state is FavoriteLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FavoriteLoaded) {
              if (state.movies.isEmpty) {
                return const Center(
                  child: Text('Your watchlist is empty.', style: TextStyle(color: Colors.white)),
                );
              }
              return GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: state.movies.length,
                itemBuilder: (context, index) {
                  final movie = state.movies[index];
                  return GestureDetector(
                    onTap: () {
                      context.go('/movie/${movie.id}', extra: movie);
                    },
                    child: MovieCard(
                      movie: movie,
                      isFavorite: true,
                      onFavoriteToggle: () {
                        // Konversi Movie ke MovieDetail minimal
                        final detail = MovieDetail(
                          id: movie.id,
                          title: movie.title,
                          overview: movie.overview ?? '',
                          posterPath: movie.posterPath ?? '',
                          backdropPath: movie.backdropPath ?? '',
                          voteAverage: movie.voteAverage ?? 0.0,
                          releaseDate: movie.releaseDate ?? '',
                          genres: [],
                          isFavorite: true,
                        );
                        context.read<FavoriteBloc>().add(ToggleFavoriteStatus(detail));
                      },
                    ),
                  );
                },
              );
            } else if (state is FavoriteError) {
              return Center(child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.white)));
            } else if (state is FavoriteEmpty) {
              return const Center(child: Text('Your watchlist is empty.', style: TextStyle(color: Colors.white)));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
