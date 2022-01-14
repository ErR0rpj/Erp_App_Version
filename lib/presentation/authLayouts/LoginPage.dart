import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inventory_app/blocs/blocs.dart';
import 'package:inventory_app/presentation/elements/BigWideButton.dart';
import 'package:inventory_app/presentation/elements/TextInput.dart';
import 'package:inventory_app/presentation/elements/TextSpanLink.dart';
import 'package:inventory_app/utils/consts.dart';
import 'package:inventory_app/blocs/bloc_providers.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  late TextEditingController _emailInputController;
  late TextEditingController _pwdInputController;
  bool _isPwdObscure = true;

  @override
  initState() {
    _emailInputController = new TextEditingController();
    _pwdInputController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppConstants().calculateSize(context);
    return MultiBlocListener(
        listeners: [
          BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
            if (state is AuthenticationUserLoaded) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  HOME_PATH, (Route<dynamic> route) => false);
            }
          }),
          BlocProviders().alertListner(context)
        ],
        child: Scaffold(
            body: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              SvgPicture.asset(
                AUTH_HEADER_PATH,
                semanticsLabel: 'Header',
                fit: BoxFit.cover,
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(
                      AppConstants().width * 0.1, 0, 0, MEDIUM_PAD),
                  child: const Text(
                    'Login To your account',
                    style: TextStyle(fontFamily: 'Roboto', fontSize: 22),
                  )),
              Form(
                  key: _loginFormKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextInput(
                            fieldName: 'Email',
                            validator: emailValidator,
                            keyboardType: TextInputType.emailAddress,
                            inputController: _emailInputController),
                        const SizedBox(height: MEDIUM_PAD),
                        TextInput(
                            fieldName: 'Password',
                            icon: _isPwdObscure
                                ? Icons.remove_red_eye_rounded
                                : Icons.remove_red_eye_outlined,
                            validator: pwdValidator,
                            keyboardType: TextInputType.text,
                            inputController: _pwdInputController,
                            onPressedIcon: () {
                              setState(() {
                                _isPwdObscure = !_isPwdObscure;
                              });
                            },
                            obscureText: _isPwdObscure),
                        const SizedBox(height: MEDIUM_PAD),
                        BigWideButton(
                          text: 'Login Now',
                          onPressed: () {
                            context.read<LoginBloc>().add(Login(
                                email: _emailInputController.text,
                                password: _pwdInputController.text));
                          },
                        ),
                        const SizedBox(height: SMALL_PAD),
                      ]))
            ]))));
  }
}
