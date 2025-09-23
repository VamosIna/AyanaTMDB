import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class LoggingInterceptor extends PrettyDioLogger {
  LoggingInterceptor()
      : super(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          compact: true,
          maxWidth: 120,
        );
}
