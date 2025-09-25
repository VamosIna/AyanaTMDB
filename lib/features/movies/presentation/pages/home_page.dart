import 'package:ayana_tmdb/app/app.dart';
import 'package:ayana_tmdb/features/movies/presentation/pages/favorites_page.dart';
import 'package:ayana_tmdb/features/movies/presentation/pages/search_page.dart';
import 'package:ayana_tmdb/features/movies/presentation/widgets/movie_card_horizontal.dart';
import 'package:ayana_tmdb/features/movies/presentation/widgets/section_horizontal_list.dart';
import 'package:ayana_tmdb/features/movies/presentation/widgets/hero_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/popular/popular_bloc.dart';
import '../blocs/popular/popular_event.dart';
import '../blocs/popular/popular_state.dart';
import '../blocs/now_playing/now_playing_bloc.dart';
import '../blocs/now_playing/now_playing_event.dart';
import '../blocs/now_playing/now_playing_state.dart';
import '../blocs/favorite/favorite_bloc.dart';
import '../blocs/favorite/favorite_event.dart';
import '../blocs/favorite/favorite_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ayana_tmdb/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:ayana_tmdb/features/movies/domain/usecases/get_now_playing_movies.dart';
import 'package:ayana_tmdb/features/movies/domain/usecases/get_favorites.dart';
import 'package:ayana_tmdb/features/movies/domain/usecases/toggle_favorite.dart';
import 'package:ayana_tmdb/core/widgets/offline_banner.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PopularBloc(getPopularMovies: RepositoryProvider.of<GetPopularMovies>(context))..add(const FetchPopularMovies()),
        ),
        BlocProvider(
          create: (context) => NowPlayingBloc(getNowPlayingMovies: RepositoryProvider.of<GetNowPlayingMovies>(context))..add(const FetchNowPlayingMovies()),
        ),
        BlocProvider(
          create: (context) => FavoriteBloc(
            getFavorites: RepositoryProvider.of<GetFavorites>(context),
            toggleFavorite: RepositoryProvider.of<ToggleFavorite>(context),
          )..add(LoadFavorites()),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.appTitle,
                  style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      letterSpacing: 2)),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.language, color: Colors.white),
                onPressed: () {
                  final locale = Localizations.localeOf(context).languageCode;
                  if (locale == 'en') {
                    context.findAncestorStateOfType<_HomePageState>()?.setState(() {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        MyApp.setLocale(context, const Locale('id'));
                      });
                    });
                  } else {
                    context.findAncestorStateOfType<_HomePageState>()?.setState(() {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        MyApp.setLocale(context, const Locale('en'));
                      });
                    });
                  }
                },
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<PopularBloc, PopularState>(
          builder: (context, state) {
            List<Widget> children = [];
            if (state is PopularLoading) {
              children.add(const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: CircularProgressIndicator()),
              ));
            } else if (state is PopularLoaded && state.movies.isNotEmpty) {
              // HeroCarousel di atas
              children.add(
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: HeroCarousel(movies: state.movies),
                ),
              );
              // Section: Popular
              children.add(
                SectionHorizontalList(
                  title: AppLocalizations.of(context)!.popularSection,
                  movies: state.movies,
                  itemBuilder: (context, movie) => GestureDetector(
                    onTap: () {
                      context.go('/movie/${movie.id}');
                    },
                    child: MovieCardHorizontal(movie: movie),
                  ),
                ),
              );
            } else if (state is PopularError) {
              children.add(Center(child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.white))));
            } else if (state is PopularEmpty || (state is PopularLoaded && state.movies.isEmpty)) {
              children.add(Center(child: Text(AppLocalizations.of(context)!.noMoviesFound, style: const TextStyle(color: Colors.white))));
            }
            // Section: Continue Watching (My List)
            children.insert(0, BlocBuilder<FavoriteBloc, FavoriteState>(
              builder: (context, favState) {
                if (favState is FavoriteLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (favState is FavoriteLoaded) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: SectionHorizontalList(
                      title: AppLocalizations.of(context)!.watchlistSection,
                      movies: favState.movies,
                      itemBuilder: (context, movie) => MovieCardHorizontal(movie: movie),
                    ),
                  );
                } else if (favState is FavoriteError) {
                  return Center(child: Text('Error: ${favState.message}', style: const TextStyle(color: Colors.white)));
                } else if (favState is FavoriteEmpty) {
                  return Center(child: Text(AppLocalizations.of(context)!.emptyWatchlist, style: const TextStyle(color: Colors.white)));
                }
                return const SizedBox.shrink();
              },
            ));
            // Section: Trending Now (API)
            children.add(
              BlocBuilder<NowPlayingBloc, NowPlayingState>(
                builder: (context, state) {
                  if (state is NowPlayingLoading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (state is NowPlayingLoaded) {
                    return SectionHorizontalList(
                      title: AppLocalizations.of(context)!.trendingSection,
                      movies: state.movies,
                      itemBuilder: (context, movie) => GestureDetector(
                        onTap: () {
                          context.go('/movie/${movie.id}');
                        },
                        child: MovieCardHorizontal(movie: movie),
                      ),
                    );
                  } else if (state is NowPlayingError) {
                    return Center(child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.white)));
                  } else if (state is NowPlayingEmpty) {
                    return Center(child: Text(AppLocalizations.of(context)!.noTrendingFound, style: const TextStyle(color: Colors.white)));
                  }
                  return const SizedBox.shrink();
                },
              ),
            );
            return ListView(children: children);
          },
        ),
      ),
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              children: [
                const DashboardPage(),
                const SearchPage(),
                const FavoritesPage(),
                Center(child: Text(AppLocalizations.of(context)!.profileLabel, style: const TextStyle(color: Colors.white))),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: _onItemTapped,
        indicatorColor: Colors.transparent,
        backgroundColor: Colors.black,
        destinations: [
          NavigationDestination(
              icon: const Icon(Icons.home_outlined, color: Colors.grey),
              selectedIcon: const Icon(Icons.home, color: Colors.white),
              label: AppLocalizations.of(context)!.homeLabel),
          NavigationDestination(
              icon: const Icon(Icons.search, color: Colors.grey),
              selectedIcon: const Icon(Icons.search, color: Colors.white),
              label: AppLocalizations.of(context)!.searchLabel),
          NavigationDestination(
              icon: const Icon(Icons.list, color: Colors.grey),
              selectedIcon: const Icon(Icons.list, color: Colors.white),
              label: AppLocalizations.of(context)!.favoritesLabel),
          NavigationDestination(
              icon: const Icon(Icons.person_outline, color: Colors.grey),
              selectedIcon: const Icon(Icons.person, color: Colors.white),
              label: AppLocalizations.of(context)!.profileLabel),
        ],
      ),
    );
  }
}
