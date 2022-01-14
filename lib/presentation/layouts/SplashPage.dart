import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_app/blocs/blocs.dart';
import 'package:inventory_app/utils/consts.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
            if (state is AuthenticationUserLoaded) {
              Navigator.of(context).pushReplacementNamed(HOME_PATH);
            } else if (state is AuthenticationNotAuthenticated) {
              Navigator.of(context).pushReplacementNamed(LOGIN_PATH);
            }
          })
        ],
        child: Scaffold(
          body: Center(
            child: Text('Loading'),
          ),
        ));
  }
}
