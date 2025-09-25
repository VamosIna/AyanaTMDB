import 'package:ayana_tmdb/core/constants/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const MovieCard({
    Key? key,
    required this.movie,
    this.isFavorite = false,
    this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(4),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          context.push('/movie/${movie.id}');
        },
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 100,
                height: 150,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: movie.posterPath != null
                          ? Image.network(
                              '${ApiConstants.imageBaseUrl}${movie.posterPath}',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(child: Icon(Icons.broken_image)),
                            )
                          : Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.broken_image),
                              ),
                            ),
                    ),
                    if (onFavoriteToggle != null)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: onFavoriteToggle,
                          child: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavorite ? Colors.redAccent : Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            color: Colors.amber, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          movie.voteAverage?.toStringAsFixed(1) ?? '-',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
