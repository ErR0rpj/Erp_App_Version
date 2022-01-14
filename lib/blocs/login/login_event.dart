import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Login extends LoginEvent {
  final String email;
  final String password;

  Login({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
