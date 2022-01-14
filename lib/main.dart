//--no-sound-null-safety
// @dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_app/presentation/routes.dart';
import 'package:inventory_app/utils/consts.dart';
import 'package:inventory_app/blocs/bloc_providers.dart';
import 'package:flutter/services.dart';
import 'package:inventory_app/blocs/blocs.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Routes _routes = Routes();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiBlocProvider(
      providers: BlocProviders().getMainProviders(),
      child: Builder(
        builder: (context) {
          final authState = context.watch<AuthenticationBloc>().state;
          return MaterialApp(
              title: APP_TITLE,
              theme: ThemeData(
                primarySwatch: THEME_COLOR,
              ),
              onGenerateRoute: _routes.generateRoute,
              initialRoute: authState is AuthenticationUserLoaded
                  ? HOME_PATH
                  : SPLASH_PATH);
        },
      ),
    );
  }

  @override
  void dispose() {
    _routes.disposeBlocs();
    super.dispose();
  }
}
