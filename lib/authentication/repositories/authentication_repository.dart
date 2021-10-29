import 'dart:async';

import 'package:dio/dio.dart';

import 'package:my_flutter_bloc_starter_project/app_settings/app_settings.dart';
import 'package:my_flutter_bloc_starter_project/constants.dart' as constants;
import 'package:my_flutter_bloc_starter_project/login/login.dart';
import 'package:my_flutter_bloc_starter_project/registration/registration.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  AuthenticationRepository({
    required this.dio,
    required this.appSettingsRepository,
  });

  final AppSettingsRepository appSettingsRepository;
  final Dio dio;

  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<String> registrate({
    required Username username,
    required Password password,
    required Email email,
  }) async {
    Uri? serverUri = await appSettingsRepository.serverUri;
    if (serverUri == null) {
      throw Exception('app settings server uri not configured');
    }
    serverUri = serverUri.replace(path: constants.apiPathAuthRegistration);
    final response = await dio.postUri(serverUri, data: {
      'username': username.value,
      'password': password.value,
      'email': email.value,
    });
    return response.data['detail'];
  }

  Future<void> logIn({
    required Username username,
    required Password password,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 300),
      () => _controller.add(AuthenticationStatus.authenticated),
    );
  }

  Future<void> resetPassword({
    required Email email,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  void logOut() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}