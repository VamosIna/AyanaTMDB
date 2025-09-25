import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ayana_tmdb/app/router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ayana_tmdb/features/movies/domain/repositories/movies_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:ayana_tmdb/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:ayana_tmdb/features/movies/domain/usecases/get_now_playing_movies.dart';
import 'package:ayana_tmdb/features/movies/domain/usecases/get_favorites.dart';
import 'package:ayana_tmdb/features/movies/domain/usecases/toggle_favorite.dart';
import 'package:ayana_tmdb/features/movies/domain/usecases/get_movie_detail.dart';
import 'package:ayana_tmdb/features/movies/domain/usecases/get_recommendations.dart';
import 'package:ayana_tmdb/features/movies/domain/usecases/search_movies.dart';

final sl = GetIt.instance;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MoviesRepository>(create: (_) => sl<MoviesRepository>()),
        RepositoryProvider<GetPopularMovies>(create: (_) => sl<GetPopularMovies>()),
        RepositoryProvider<GetNowPlayingMovies>(create: (_) => sl<GetNowPlayingMovies>()),
        RepositoryProvider<GetFavorites>(create: (_) => sl<GetFavorites>()),
        RepositoryProvider<ToggleFavorite>(create: (_) => sl<ToggleFavorite>()),
        RepositoryProvider<GetMovieDetail>(create: (_) => sl<GetMovieDetail>()),
        RepositoryProvider<GetRecommendations>(create: (_) => sl<GetRecommendations>()),
        RepositoryProvider<SearchMovies>(create: (_) => sl<SearchMovies>()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'AyanaTMDB',
        theme: ThemeData.dark(),
        routerConfig: router,
        locale: _locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('id', ''),
        ],
      ),
    );
  }
}
