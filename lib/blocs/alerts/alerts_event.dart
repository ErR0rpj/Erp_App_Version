import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class AlertsEvent extends Equatable {
  const AlertsEvent();

  @override
  List<Object> get props => [];
}

class AddAlert extends AlertsEvent {
  final String message;
  AddAlert({required this.message});

  @override
  List<Object> get props => [message];
}
