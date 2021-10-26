part of 'app_settings_bloc.dart';

enum AppSettingsStateType {
  initial,
  loading,
  loadingSuccess,
  loadingFailure,
  data,
  saving,
  savingSuccess,
  savingFailure,
}

class AppSettingsState extends Equatable {
  const AppSettingsState({
    this.protocol = const Protocol(http),
    this.hostname = const Hostname(''),
    this.port = const Port(''),
    this.type = AppSettingsStateType.initial,
  });

  bool get valid => protocol.valid && hostname.valid && port.valid;
  bool get invalid => !valid;

  bool get isInitial => type == AppSettingsStateType.initial;
  bool get isloading => type == AppSettingsStateType.loading;
  bool get isLoadingSuccess => type == AppSettingsStateType.loadingSuccess;
  bool get isLoadingFailure => type == AppSettingsStateType.loadingFailure;
  bool get isData => type == AppSettingsStateType.data;
  bool get isSaving => type == AppSettingsStateType.saving;
  bool get isSavingSuccess => type == AppSettingsStateType.savingSuccess;
  bool get isSavingFailure => type == AppSettingsStateType.savingFailure;

  bool get isInProgress => isInitial || isloading || isSaving;
  bool get isSuccess => isLoadingSuccess || isSavingSuccess;
  bool get isError => isLoadingFailure || isSavingFailure;

  final Protocol protocol;
  final Hostname hostname;
  final Port port;
  final AppSettingsStateType type;

  AppSettingsState copyWith({
    Protocol? protocol,
    Hostname? hostname,
    Port? port,
    AppSettingsStateType? type,
  }) {
    return AppSettingsState(
      protocol: protocol ?? this.protocol,
      hostname: hostname ?? this.hostname,
      port: port ?? this.port,
      type: type ?? this.type,
    );
  }

  @override
  List<Object> get props => [port, hostname, protocol, type];
}
