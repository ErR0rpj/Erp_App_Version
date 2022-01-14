import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class AlertsState extends Equatable {
  const AlertsState();

  @override
  List<Object> get props => [];
}

class AlertsInitial extends AlertsState {}

class AlertMessage extends AlertsState {
  final String message;
  final int id;

  AlertMessage({required this.message, required this.id});

  @override
  List<Object> get props => [message, id];
}
