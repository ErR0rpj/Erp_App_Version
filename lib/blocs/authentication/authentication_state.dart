import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import '../../models/models.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationNotAuthenticated extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {
  final User registerData;

  AuthenticationAuthenticated({required this.registerData});

  @override
  List<Object> get props => [registerData];
}

class AuthenticationUserLoaded extends AuthenticationState {
  final User user;

  AuthenticationUserLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthenticationFailure extends AuthenticationState {
  final String message;

  AuthenticationFailure({required this.message});

  @override
  List<Object> get props => [message];
}
