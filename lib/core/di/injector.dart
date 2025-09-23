import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:ayana_tmdb/core/network/dio_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Register Dio
  sl.registerLazySingleton<Dio>(() => DioClient.create());

  // TODO: Register other dependencies (repositories, data sources, blocs, etc)
}
