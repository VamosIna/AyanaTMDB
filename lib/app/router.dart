import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:ayana_tmdb/features/movies/presentation/pages/home_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const Placeholder(), // TODO: SearchPage
    ),
    GoRoute(
      path: '/movie/:id',
      builder: (context, state) => const Placeholder(), // TODO: DetailPage
    ),
    GoRoute(
      path: '/favorites',
      builder: (context, state) => const Placeholder(), // TODO: FavoritesPage
    ),
  ],
);
