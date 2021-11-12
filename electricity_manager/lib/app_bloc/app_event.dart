import 'package:electricity_manager/models/user.dart';
import 'package:equatable/equatable.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AppEvent {}

class LoggedIn extends AppEvent {
  final User user;

  const LoggedIn({required this.user});

  @override
  // TODO: implement props
  List<Object> get props => [this.user];
}

class LogOuted extends AppEvent {}
