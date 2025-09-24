import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ayana_tmdb/app/router.dart';
import 'package:ayana_tmdb/app/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ayana_tmdb/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:ayana_tmdb/features/movies/domain/usecases/get_now_playing_movies.dart';
import 'package:ayana_tmdb/core/di/injector.dart';
import 'package:ayana_tmdb/features/movies/domain/repositories/movies_repository.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MoviesRepository>(
          create: (_) => sl<MoviesRepository>(),
        ),
        RepositoryProvider<GetPopularMovies>(
          create: (_) => sl<GetPopularMovies>(),
        ),
        RepositoryProvider<GetNowPlayingMovies>(
          create: (_) => sl<GetNowPlayingMovies>(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Ayana TMDB',
        theme: lightTheme,
        darkTheme: darkTheme,
        routerConfig: router,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('id'),
        ],
      ),
    );
  }
}
