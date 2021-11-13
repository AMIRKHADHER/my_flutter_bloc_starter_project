import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'package:my_flutter_bloc_starter_project/authentication/authentication.dart';
import 'package:my_flutter_bloc_starter_project/constants.dart' as constants;

Dio buildUnAuthenticatedDio() {
  final _dio = Dio();
  _dio.options.connectTimeout = constants.connectionTimeout;
  _dio.options.receiveTimeout = constants.receiveTimeout;
  _dio.options.contentType = constants.contentType;
  _dio.interceptors.addAll([
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ),
  ]);
  return _dio;
}

Dio buildAuthenticatedDio({
  required AuthenticationTokenRepository authenticationTokenRepository,
}) {
  final _dio = buildUnAuthenticatedDio();
  _dio.interceptors.addAll([
    AddAccessTokenInterceptor(
      authenticationTokenRepository: authenticationTokenRepository,
    ),
  ]);
  return _dio;
}
