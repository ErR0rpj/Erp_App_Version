import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:inventory_app/blocs/store/store_bloc.dart';
import 'package:inventory_app/presentation/elements/Alert.dart';
import 'package:inventory_app/repos/repos.dart';
import 'blocs.dart';

class BlocProviders {
  //ignore: close_sinks
  static final AlertsBloc _alertsBloc = AlertsBloc();

  //ignore: close_sinks
  static final AuthenticationBloc _authBloc =
      AuthenticationBloc(AuthenticationRepository(), _alertsBloc)
        ..add(AppLoaded());
  //ignore: close_sinks
  static final LoginBloc _loginBloc =
      LoginBloc(_authBloc, _storeBloc, AuthenticationRepository());

  //ignore: close_sinks
  static final StoreBloc _storeBloc = StoreBloc(StoreRepository());

  final _authBlocProvider = BlocProvider<AuthenticationBloc>(
      create: (BuildContext context) => _authBloc);

  final _alertsBlocProvider =
      BlocProvider<AlertsBloc>(create: (BuildContext context) => _alertsBloc);

  final _loginBlocProvicer = BlocProvider<LoginBloc>.value(value: _loginBloc);

  final _storeBlocProvider = BlocProvider<StoreBloc>.value(value: _storeBloc);

  List<BlocProvider> getMainProviders() {
    return [_authBlocProvider, _alertsBlocProvider, _storeBlocProvider];
  }

  List<BlocProvider> getLoginProviders() {
    return [_loginBlocProvicer];
  }

  BlocListener alertListner(BuildContext context) {
    return BlocListener<AlertsBloc, AlertsState>(listener: (context, state) {
      if (state is AlertMessage) {
        ScaffoldMessenger.of(context)
            .showSnackBar(snackBar(message: state.message));
      }
    }, listenWhen: (_, __) {
      var route = ModalRoute.of(context);
      return route!.isCurrent;
    });
  }

  void disposeBlocs() {
    _authBloc.close();
    _loginBloc.close();
    _alertsBloc.close();
    _storeBloc.close();
  }
}
