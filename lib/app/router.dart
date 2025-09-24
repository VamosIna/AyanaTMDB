import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ayana_tmdb/features/movies/presentation/pages/home_page.dart';
import 'package:ayana_tmdb/features/movies/presentation/pages/detail_page.dart';

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
            return DetailPage(movieId: id);
          },
        ),
      ],
    ),
  ],
);
