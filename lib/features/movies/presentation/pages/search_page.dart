import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/search/search_bloc.dart';
import 'package:ayana_tmdb/features/movies/domain/usecases/search_movies.dart';
import '../blocs/search/search_event.dart';
import '../blocs/search/search_state.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchMoviesBloc(
        searchMovies: RepositoryProvider.of<SearchMovies>(context),
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Search', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search input
              BlocBuilder<SearchMoviesBloc, SearchState>(
                builder: (context, state) {
                  return TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search movies...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.white12,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search, color: Colors.white54),
                    ),
                    onChanged: (query) {
                      context.read<SearchMoviesBloc>().add(SearchQueryChanged(query));
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              // TODO: Show filter chips (genre, year)
              // Recent search
              BlocBuilder<SearchMoviesBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoaded && state.recentQueries.isNotEmpty) {
                    return Wrap(
                      spacing: 8,
                      children: state.recentQueries
                          .map((q) => ActionChip(
                                label: Text(q, style: const TextStyle(color: Colors.white)),
                                backgroundColor: Colors.white12,
                                onPressed: () {
                                  context.read<SearchMoviesBloc>().add(SearchQueryChanged(q));
                                },
                              ))
                          .toList(),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 16),
              // Search results
              Expanded(
                child: BlocBuilder<SearchMoviesBloc, SearchState>(
                  builder: (context, state) {
                    if (state is SearchLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SearchLoaded) {
                      if (state.results.isEmpty) {
                        return const Center(child: Text('No results found.', style: TextStyle(color: Colors.white54)));
                      }
return ListView.builder(
  itemCount: state.results.length,
  itemBuilder: (context, index) {
    final movie = state.results[index];
    return ListTile(
      key: ValueKey(movie.id),
      leading: movie.posterPath != null
          ? Image.network('https://image.tmdb.org/t/p/w92${movie.posterPath}', width: 48)
          : const Icon(Icons.movie, color: Colors.white54),
      title: Text(movie.title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(movie.overview ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white54)),
      onTap: () {
        context.go('/movie/${movie.id}');
      },
    );
  },
);
                    } else if (state is SearchError) {
                      return Center(child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.white)));
                    } else if (state is SearchEmpty) {
                      return const Center(child: Text('No results found.', style: TextStyle(color: Colors.white54)));
                    }
                    return const Center(
                      child: Text(
                        'Type to search movies...',
                        style: TextStyle(color: Colors.white54, fontSize: 18),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
