// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieDetailModel _$MovieDetailModelFromJson(Map<String, dynamic> json) =>
    MovieDetailModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      overview: json['overview'] as String,
      posterPath: json['poster_path'] as String,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: (json['vote_average'] as num).toDouble(),
      genres: (json['genres'] as List<dynamic>)
          .map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isFavorite: json['isFavorite'] as bool? ?? false,
      releaseDate: json['release_date'] as String?,
      runtime: (json['runtime'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MovieDetailModelToJson(MovieDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'overview': instance.overview,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'vote_average': instance.voteAverage,
      'genres': instance.genres.map((e) => e.toJson()).toList(),
      'isFavorite': instance.isFavorite,
      'release_date': instance.releaseDate,
      'runtime': instance.runtime,
    };
