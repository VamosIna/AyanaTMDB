import 'package:dio/dio.dart';
import 'package:ayana_tmdb/core/constants/api_constants.dart';
import 'package:ayana_tmdb/core/network/interceptors/auth_interceptor.dart';
import 'package:ayana_tmdb/core/network/interceptors/logging_interceptor.dart';
import 'package:ayana_tmdb/app/env.dart';

class DioClient {
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        responseType: ResponseType.json,
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(
        apiKey: Env.tmdbApiKey,
        bearerToken: Env.bearerToken,
      ),
      LoggingInterceptor(),
    ]);

    return dio;
  }
}
