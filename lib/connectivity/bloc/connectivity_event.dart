part of 'connectivity_bloc.dart';

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object> get props => [];
}

class ConnectivityChanged extends ConnectivityEvent {
  const ConnectivityChanged(this.result);

  final ConnectivityResult result;

  @override
  List<Object> get props => [result];
}
