import 'package:ayana_tmdb/core/constants/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // context.go('/movie/${movie.id}');
        },
        child: Column(
          mainAxisSize: MainAxisSize.min, // ⬅️ penting untuk hindari overflow
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // batasi tinggi poster agar gak memaksa keseluruhan kartu
            SizedBox(
              height: 160,
              width: double.infinity,
              child:
                  movie.posterPath != null
                      ? Image.network(
                        '${ApiConstants.posterOriginalBaseUrl}${movie.posterPath}',
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                const Center(child: Icon(Icons.broken_image)),
                      )
                      : Container(
                        color: Colors.grey[300],
                        child: const Center(child: Icon(Icons.broken_image)),
                      ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: Text(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            //   child: Text(
            //     movie.overview ?? '',
            //     maxLines: 3,
            //     overflow: TextOverflow.ellipsis,
            //     style: Theme.of(context).textTheme.bodyMedium,
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    movie.voteAverage?.toStringAsFixed(1) ?? '-',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
