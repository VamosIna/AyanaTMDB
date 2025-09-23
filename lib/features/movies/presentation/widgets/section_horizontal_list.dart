import 'package:flutter/material.dart';
import '../../domain/entities/movie.dart';
import 'movie_card.dart';

class SectionHorizontalList extends StatelessWidget {
  final String title;
  final List<Movie> movies;
  final Widget Function(BuildContext, Movie)? itemBuilder;

  const SectionHorizontalList({
    Key? key,
    required this.title,
    required this.movies,
    this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: movies.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final movie = movies[index];
              if (itemBuilder != null) {
                return itemBuilder!(context, movie);
              }
              return MovieCard(
                movie: movie,
              );
            },
          ),
        ),
      ],
    );
  }
}
