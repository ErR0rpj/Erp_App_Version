import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_app/blocs/bloc_providers.dart';
import 'package:inventory_app/presentation/layouts/AddEditBatch.dart';
import 'package:inventory_app/presentation/layouts/AddEditItem.dart';
import 'package:inventory_app/utils/consts.dart';
import 'package:inventory_app/presentation/layouts/HomePage.dart';
import 'package:inventory_app/presentation/layouts/SplashPage.dart';
import 'package:inventory_app/presentation/authLayouts/LoginPage.dart';

class Routes {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SPLASH_PATH:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                providers: BlocProviders().getLoginProviders(),
                child: SplashPage()),
            settings: settings);
      case LOGIN_PATH:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                providers: BlocProviders().getLoginProviders(),
                child: LoginPage()),
            settings: settings);
      case HOME_PATH:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                providers: BlocProviders().getMainProviders(),
                child: HomePage()),
            settings: settings);
      case ITEM_ADDEDIT_PATH:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                providers: BlocProviders().getMainProviders(),
                child: AddEditItem()),
            settings: settings);
      case BATCH_ADDEDIT_PATH:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                providers: BlocProviders().getMainProviders(),
                child: AddEditBatch()),
            settings: settings);
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Text(
                      'Please check route definition for ${settings.name}'),
                ));
    }
  }

  void disposeBlocs() {
    BlocProviders().disposeBlocs();
  }
}
