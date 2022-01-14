import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_app/models/models.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppLoaded extends AuthenticationEvent {}

class UserLoggedIn extends AuthenticationEvent {
  final User registerData;
  UserLoggedIn({required this.registerData});

  @override
  List<Object> get props => [registerData];
}

class AuthFailed extends AuthenticationEvent {
  final String message;
  AuthFailed({required this.message});

  @override
  List<Object> get props => [message];
}

class UserLoggedOut extends AuthenticationEvent {}
