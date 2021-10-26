import 'package:flutter/widgets.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:my_flutter_bloc_starter_project/app_settings/app_settings.dart';
import 'package:my_flutter_bloc_starter_project/constants.dart';

part 'app_settings_event.dart';
part 'app_settings_state.dart';

class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  AppSettingsBloc({required this.appSettingsRepository})
      : super(const AppSettingsState()) {
    on<AppSettingsInitialized>(_onInitialized);
    on<AppSettingsProtocolUpdated>(_onProtocolChanged);
    on<AppSettingsHostnameUpdated>(_onHostnameChanged);
    on<AppSettingsPortUpdated>(_onPortChanged);
    on<AppSettingsFormSubmitted>(_onFormSubmitted);
  }

  final AppSettingsRepository appSettingsRepository;

  @override
  void onTransition(Transition<AppSettingsEvent, AppSettingsState> transition) {
    debugPrint(transition.toString());
    super.onTransition(transition);
  }

  _onInitialized(
    AppSettingsInitialized event,
    Emitter<AppSettingsState> emit,
  ) async {
    emit(state.copyWith(
      type: AppSettingsStateType.loading,
    ));
    try {
      final protocol = await appSettingsRepository.protocol;
      final hostname = await appSettingsRepository.hostname;
      final port = await appSettingsRepository.port;
      emit(state.copyWith(type: AppSettingsStateType.loadingSuccess));
      emit(state.copyWith(
        type: AppSettingsStateType.data,
        protocol: protocol,
        hostname: hostname,
        port: port,
      ));
    } catch (_) {
      emit(state.copyWith(
        type: AppSettingsStateType.loadingError,
      ));
    }
  }

  _onHostnameChanged(
    AppSettingsHostnameUpdated event,
    Emitter<AppSettingsState> emit,
  ) {
    emit(state.copyWith(
      type: AppSettingsStateType.data,
      hostname: Hostname(event.hostname),
    ));
  }

  _onProtocolChanged(
    AppSettingsProtocolUpdated event,
    Emitter<AppSettingsState> emit,
  ) {
    emit(state.copyWith(
      type: AppSettingsStateType.data,
      protocol: Protocol(event.protocol),
    ));
  }

  _onPortChanged(
    AppSettingsPortUpdated event,
    Emitter<AppSettingsState> emit,
  ) {
    emit(state.copyWith(
      type: AppSettingsStateType.data,
      port: Port(event.port),
    ));
  }

  _onFormSubmitted(
    AppSettingsFormSubmitted event,
    Emitter<AppSettingsState> emit,
  ) async {
    emit(state.copyWith(type: AppSettingsStateType.saving));
    try {
      await appSettingsRepository.write(
        hostname: state.hostname,
        protocol: state.protocol,
        port: state.port,
      );
      emit(state.copyWith(type: AppSettingsStateType.savingSuccess));
    } catch (_) {
      emit(state.copyWith(type: AppSettingsStateType.savingError));
    }
  }
}
