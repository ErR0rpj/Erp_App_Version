import 'dart:async';
import 'package:inventory_app/utils/consts.dart';
import 'package:inventory_app/utils/networking/RestWrapper.dart';
import 'package:inventory_app/models/models.dart';

abstract class AuthenticationService {
  Future<User> login(String email, String password);
  void setToken(String token);
  Future<void> logOut();
  Future<String> getToken();
}

class AuthenticationRepository extends AuthenticationService {
  RestWrapper _provider = RestWrapper();

  @override
  Future<User> login(String email, String password) async {
    final Map<String, dynamic> response = await _provider
        .post(USER_LOGIN_URL, {'email': email, 'password': password});
    return User.fromJson(response);
  }

  @override
  Future<void> setToken(String token) async {
    await _provider.setToken(token);
    return;
  }

  @override
  Future<String> getToken() async {
    final token = await _provider.jwtOrEmpty();
    if (token != null && token != "") {
      await setToken(token);
    }
    return token;
  }

  @override
  Future<void> logOut() async {
    return null;
  }
}
