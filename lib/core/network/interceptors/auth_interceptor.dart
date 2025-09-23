import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final String apiKey;
  final String? bearerToken;

  AuthInterceptor({required this.apiKey, this.bearerToken});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Tambahkan api_key sebagai query param
    options.queryParameters['api_key'] = apiKey;

    // Jika ada bearer token, tambahkan ke header Authorization
    if (bearerToken != null && bearerToken!.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $bearerToken';
    }

    super.onRequest(options, handler);
  }
}
