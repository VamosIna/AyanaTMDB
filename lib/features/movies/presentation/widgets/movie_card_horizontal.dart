import 'package:ayana_tmdb/core/constants/api_constants.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/movie.dart';

import 'package:go_router/go_router.dart';

class MovieCardHorizontal extends StatelessWidget {
  final Movie movie;

  const MovieCardHorizontal({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/movie/${movie.id}'),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: movie.posterPath != null
                  ? Image.network(
                      '${ApiConstants.imageBaseUrl}${movie.posterPath}',
                      fit: BoxFit.cover,
                      width: 110,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                    )
                  : Container(
                      width: 110,
                      color: Colors.grey[300],
                      child: const Center(child: Icon(Icons.broken_image)),
                    ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
                  onPressed: () => context.go('/movie/${movie.id}'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
