import 'dart:developer';

import 'package:ayana_tmdb/core/di/injector.dart';
import 'package:ayana_tmdb/features/movies/domain/entities/movie.dart';
import 'package:ayana_tmdb/features/movies/domain/entities/movie_detail.dart';
import 'package:ayana_tmdb/features/movies/presentation/blocs/favorite/favorite_bloc.dart';
import 'package:ayana_tmdb/features/movies/presentation/blocs/favorite/favorite_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_movie_detail.dart';
import '../blocs/detail/detail_bloc.dart';
import '../blocs/detail/detail_event.dart';
import '../blocs/detail/detail_state.dart';
import '../widgets/rating_badge.dart';

class DetailPage extends StatefulWidget {
  final int movieId;
  final Movie? favoriteMovie;
  const DetailPage({Key? key, required this.movieId, this.favoriteMovie}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final FavoriteBloc favoriteBloc = sl.get<FavoriteBloc>();
  @override
  Widget build(BuildContext context) {
    if (widget.favoriteMovie != null) {
      // Tampilkan detail dari local storage (favorite)
      final movie = widget.favoriteMovie!;
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Movie Detail', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster/backdrop + gradient overlay
              Stack(
                children: [
                  if (movie.posterPath != null && movie.posterPath!.isNotEmpty)
                    Image.network(
                      'https://image.tmdb.org/t/p/w780${movie.posterPath}',
                      width: double.infinity,
                      height: 320,
                      fit: BoxFit.cover,
                    )
                  else
                    Container(
                      width: double.infinity,
                      height: 320,
                      color: Colors.grey[900],
                    ),
                  Container(
                    width: double.infinity,
                    height: 320,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black87],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.5, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            shadows: [Shadow(blurRadius: 8, color: Colors.black)],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            RatingBadge(rating: movie.voteAverage ?? 0.0),
                            // Genre dan info lain bisa ditambahkan jika ada
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Action buttons
                    Row(
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Play'),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: const Icon(Icons.add),
                          label: const Text('My List'),
                          onPressed: () {
                            log("message");
                            // // Konversi Movie ke MovieDetail minimal
                            // final detail = MovieDetail(
                            //   id: movie.id,
                            //   title: movie.title,
                            //   overview: movie.overview ?? '',
                            //   posterPath: movie.posterPath ?? '',
                            //   backdropPath: movie.backdropPath ?? '',
                            //   voteAverage: movie.voteAverage ?? 0.0,
                            //   releaseDate: movie.releaseDate ?? '',
                            //   genres: [],
                            //   isFavorite: true,
                            // );
                            // favoriteBloc.add(ToggleFavoriteStatus(detail));
                            // print('[DEBUG] ToggleFavoriteStatus dispatched from local detail');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Overview
                    Text(
                      movie.overview ?? '',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Default: fetch detail dari API/cache
    return BlocProvider(
      create: (context) => DetailBloc(getMovieDetail: RepositoryProvider.of<GetMovieDetail>(context))
        ..add(FetchMovieDetail(widget.movieId)),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Movie Detail', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: BlocBuilder<DetailBloc, DetailState>(
          builder: (context, state) {
            if (state is DetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DetailLoaded) {
              final movie = state.movie;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Poster/backdrop + gradient overlay
                    Stack(
                      children: [
                        if (movie.posterPath.isNotEmpty)
                          Image.network(
                            'https://image.tmdb.org/t/p/w780${movie.posterPath}',
                            width: double.infinity,
                            height: 320,
                            fit: BoxFit.cover,
                          )
                        else
                          Container(
                            width: double.infinity,
                            height: 320,
                            color: Colors.grey[900],
                          ),
                        Container(
                          width: double.infinity,
                          height: 320,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.transparent, Colors.black87],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.5, 1.0],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          bottom: 24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  shadows: [Shadow(blurRadius: 8, color: Colors.black)],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  RatingBadge(rating: movie.voteAverage),
                                  const SizedBox(width: 12),
                                  ...movie.genres.map((g) => Padding(
                                        padding: const EdgeInsets.only(right: 8),
                                        child: Chip(
                                          label: Text(g.toString(), style: const TextStyle(color: Colors.white)),
                                          backgroundColor: Colors.white12,
                                        ),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Action buttons
                          Row(
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                icon: const Icon(Icons.play_arrow),
                                label: const Text('Play'),
                                onPressed: () {
                                  // TODO: Play trailer modal
                                  log("message");
                                  favoriteBloc.add(
                                    ToggleFavoriteStatus(
                                      MovieDetail(
                                        id: movie.id,
                                        title: movie.title,
                                        overview: movie.overview,
                                        posterPath: movie.posterPath,
                                        voteAverage: movie.voteAverage,
                                        genres: [for (var g in movie.genres) g],
                                        isFavorite: movie.isFavorite,
                                      ),
                                    ),
                                  );
                                  
                                },
                              ),
                              const SizedBox(width: 12),
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                icon: const Icon(Icons.add),
                              label: const Text('My List'),
                              onPressed: () {
                                // final favoriteBloc = context.read<FavoriteBloc>();
                                favoriteBloc.add(ToggleFavoriteStatus(
                                  MovieDetail(
                                    id: movie.id,
                                    title: movie.title,
                                    overview: movie.overview,
                                    posterPath: movie.posterPath,
                                    voteAverage: movie.voteAverage, genres: [
                                      for (var g in movie.genres) g
                                    ], isFavorite: movie.isFavorite,
                                  ),
                                ));
                              },
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              icon: const Icon(Icons.share),
                              label: const Text('Share'),
                              onPressed: () {
                                // TODO: Share action
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Overview
                        Text(
                          movie.overview,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        // Cast row (placeholder)
                        const Text(
                          'Cast',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 0, 
                            itemBuilder: (context, index) {
                              return Container(
                                width: 80,
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                color: Colors.grey[800],
                                child: const Center(child: Text('Cast Member')),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Recommendations carousel (placeholder)
                        const Text(
                          'Recommendations',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 0, 
                            itemBuilder: (context, index) {
                              return Container(
                                width: 120,
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                color: Colors.grey[800],
                                child: const Center(child: Text('Recommendation')),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                )],
                ),
              );
            } else if (state is DetailError) {
              return Center(child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.white)));
            } else if (state is DetailEmpty) {
              return const Center(child: Text('No detail found.', style: TextStyle(color: Colors.white)));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
