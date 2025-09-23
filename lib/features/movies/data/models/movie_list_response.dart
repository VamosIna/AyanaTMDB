import 'package:json_annotation/json_annotation.dart';
import 'movie_model.dart';

part 'movie_list_response.g.dart';

@JsonSerializable()
class MovieListResponse {
  final int page;
  final List<MovieModel> results;
  final int total_pages;
  final int total_results;

  MovieListResponse({
    required this.page,
    required this.results,
    required this.total_pages,
    required this.total_results,
  });

  factory MovieListResponse.fromJson(Map<String, dynamic> json) => _$MovieListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MovieListResponseToJson(this);
}
