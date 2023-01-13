import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_vpn/bloc/VPN_AUTH/vpn_auth_bloc.dart';
import 'package:ghost_vpn/config/router.dart';
import 'package:ghost_vpn/screens/authentication/forget_screen.dart';
import 'package:ghost_vpn/services/firebase_auth.dart';
import 'package:ghost_vpn/widgets/loader_widget.dart';
import 'package:ghost_vpn/widgets/widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Auth auth = Auth();
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  String? _warning;
  bool _isLoading = false;

  @override
  void dispose() {
    if (!mounted) return;
    _emailController.dispose();
    _passController.dispose();
    _warning = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VpnAuthBloc, VpnAuthState>(
      listener: (context, state) async {
        if (state is VpnAuthNavigatorState) {
          setState(() {
            _isLoading = false;
          });
          Navigator.pushNamed(context, state.route);
        }

        if (state is VpnAuthLoginToastState) {
          setState(() {
            _isLoading = false;
            _warning = 'Пожалуйста, подтвердите вашу почту.';
            _emailController.text = '';
            _passController.text = '';
          });
          await auth.sendVerificationEmail();
        }

        if (state is VpnAuthErrorState) {
          if (state.warning ==
              '[firebase_auth/unknown] Given String is empty or null') {
            setState(() {
              _isLoading = false;
            });
          } else {
            setState(() {
              _isLoading = false;
              _warning = state.warning;
            _emailController.text = '';
            _passController.text = '';
            });
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _isLoading
            ? LoaderWidget()
            : GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Form(
                  key: _formKey,
                  child: SafeArea(
                    child: ListView(
                      padding: EdgeInsets.all(30),
                      children: [
                        iconBackButton(context),
                        ShowAlert(
                          warning: _warning,
                          function: () {
                            setState(() {
                              _warning = null;
                            });
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          'Войти',
                          style: TextStyle(
                              fontSize: 70,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        TextFormEmailField(emailController: _emailController),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormPassField(passController: _passController),
                        SizedBox(
                          height: 30,
                        ),
                        enterButton(
                          _formKey,
                          _submitForm,
                          'Войти',
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                _isLoading = true;
                              });
                              BlocProvider.of<VpnAuthBloc>(context)
                                  .add(VpnLoginWithGoogleEvent());
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  color: Colors.white),
                              height: 70,
                              width: 300,
                              child: Center(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Войти с помощью Google',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Gilroy',
                                        fontSize: 17),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Image.asset(
                                    'assets/google.png',
                                    fit: BoxFit.cover,
                                    height: 30,
                                    width: 30,
                                  )
                                ],
                              )),
                            )),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ForgetScreen()));
                            },
                            child: Container(
                              child: Text(
                                'Восстановить пароль',
                                style: TextStyle(color: Colors.white),
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  void _submitForm() async {
    setState(() => _isLoading = true);
    BlocProvider.of<VpnAuthBloc>(context).add(VpnLoginEvent(
        login: _emailController.text.trim(),
        password: _passController.text.trim()));
  }
}
