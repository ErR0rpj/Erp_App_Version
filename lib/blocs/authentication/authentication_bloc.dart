import 'package:bloc/bloc.dart';
import 'package:inventory_app/blocs/alerts/alerts.dart';
import 'package:inventory_app/blocs/authentication/authentication.dart';

import 'authentication_event.dart';
import 'authentication_state.dart';
import '../../repos/repos.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationService;
  final AlertsBloc _alertsBloc;

  AuthenticationBloc(
      AuthenticationRepository authenticationService, AlertsBloc alertsBloc)
      : assert(authenticationService != null),
        _authenticationService = authenticationService,
        _alertsBloc = alertsBloc,
        super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppLoaded) {
      yield* _mapAppLoadedToState(event);
    } else if (event is UserLoggedIn) {
      yield* _mapUserLoggedInToState(event);
    } else if (event is UserLoggedOut) {
      yield* _mapUserLoggedOutToState(event);
    } else if (event is AuthFailed) {
      yield* _mapAuthFailedToState(event);
    }
  }

  Stream<AuthenticationState> _mapAppLoadedToState(AppLoaded event) async* {
    yield AuthenticationLoading();
    try {
      // TODO: Add load user with token!
      //await _authenticationService.getToken();
      // final currentUser = await _authenticationService.loadUser();
      // if (currentUser != null) {
      //   yield AuthenticationUserLoaded(user: currentUser);
      // } else {
      yield AuthenticationNotAuthenticated();
    } catch (e) {
      print(e);
      yield AuthenticationNotAuthenticated();
    }
  }

  Stream<AuthenticationState> _mapUserLoggedInToState(
      UserLoggedIn event) async* {
    try {
      final currentUser = event.registerData;
      if (currentUser != null) {
        print(currentUser);
        yield AuthenticationUserLoaded(user: currentUser);
      } else {
        yield AuthenticationNotAuthenticated();
      }
    } catch (e) {
      yield AuthenticationNotAuthenticated();
    }
  }

  Stream<AuthenticationState> _mapUserLoggedOutToState(
      UserLoggedOut event) async* {
    await _authenticationService.logOut();
    yield AuthenticationNotAuthenticated();
  }

  Stream<AuthenticationState> _mapAuthFailedToState(AuthFailed event) async* {
    _alertsBloc.add(AddAlert(message: 'Authentication Error!'));
    yield AuthenticationFailure(message: event.message);
  }
}
