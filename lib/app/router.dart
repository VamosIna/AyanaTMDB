import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ayana_tmdb/features/movies/presentation/pages/home_page.dart';
import 'package:ayana_tmdb/features/movies/presentation/pages/detail_page.dart';
import 'package:ayana_tmdb/features/movies/domain/entities/movie.dart';

import 'package:ayana_tmdb/features/movies/presentation/pages/favorites_page.dart';
import 'package:ayana_tmdb/features/movies/presentation/pages/search_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'movie/:id',
          builder: (context, state) {
            final id = int.tryParse(state.pathParameters['id'] ?? '');
            if (id == null) {
              return const Scaffold(
                body: Center(child: Text('Invalid movie id')),
              );
            }
            final favoriteMovie = state.extra is Movie ? state.extra as Movie : null;
            return DetailPage(movieId: id, favoriteMovie: favoriteMovie);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/my-list',
      builder: (context, state) => const FavoritesPage(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchPage(),
    ),
  ],
);
