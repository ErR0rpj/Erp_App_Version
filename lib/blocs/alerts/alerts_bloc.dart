import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';

import 'alerts_event.dart';
import 'alerts_state.dart';

class AlertsBloc extends Bloc<AlertsEvent, AlertsState> {
  AlertsBloc() : super(AlertsInitial());

  @override
  Stream<AlertsState> mapEventToState(
    AlertsEvent event,
  ) async* {
    if (event is AddAlert) {
      yield* _mapAlertToState(event);
    }
  }

  Stream<AlertsState> _mapAlertToState(AddAlert event) async* {
    int id = new Random().nextInt(200);
    yield AlertMessage(message: event.message, id: id);
  }
}
