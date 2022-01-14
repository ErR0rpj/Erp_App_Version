import 'package:bloc/bloc.dart';
import 'package:inventory_app/blocs/store/store_bloc.dart';
import 'package:inventory_app/blocs/store/store_event.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'package:inventory_app/blocs/authentication/authentication.dart';
import 'package:inventory_app/repos/authentication_repo.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationBloc _authenticationBloc;
  final StoreBloc _storeBloc;
  final AuthenticationRepository _authenticationService;

  LoginBloc(AuthenticationBloc authenticationBloc, StoreBloc storeBloc,
      AuthenticationRepository authenticationService)
      : _authenticationBloc = authenticationBloc,
        _authenticationService = authenticationService,
        _storeBloc = storeBloc,
        super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is Login) {
      yield* _mapLoginToState(event);
    }
  }

  Stream<LoginState> _mapLoginToState(Login event) async* {
    yield LoginLoading();
    try {
      final registerData =
          await _authenticationService.login(event.email, event.password);
      if (registerData != null) {
        _authenticationBloc.add(UserLoggedIn(registerData: registerData));
        _storeBloc.add(GetStoreName(token: registerData.token ?? ''));
        yield LoginSuccess();
        yield LoginInitial();
      } else {
        _authenticationBloc.add(AuthFailed(message: 'Empty Data!'));
      }
    } catch (err) {
      print(err.toString());
      _authenticationBloc.add(AuthFailed(message: err.toString()));
    }
  }
}
