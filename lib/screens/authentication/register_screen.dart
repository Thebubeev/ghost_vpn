import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_vpn/bloc/VPN_AUTH/vpn_auth_bloc.dart';
import 'package:ghost_vpn/services/firebase_auth.dart';
import 'package:ghost_vpn/widgets/loader_widget.dart';
import 'package:ghost_vpn/widgets/widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final Auth auth = Auth();
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  String? _warning;
  bool _isLoading = false;

  @override
  void dispose() {
    if (!mounted) return;
    _emailController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    _warning = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VpnAuthBloc, VpnAuthState>(
      listener: (context, state) async {
        if (state is VpnAuthRegisterToastState) {
          setState(() {
            _isLoading = false;
            _warning = 'Пожалуйста, подтвердите вашу почту.';
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
                          'Регистрация',
                          style: TextStyle(
                              fontSize: 45,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormEmailField(emailController: _emailController),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormPassField(passController: _passController),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormConfirmPassField(
                            passController: _passController,
                            confirmPassController: _confirmPassController),
                        SizedBox(
                          height: 45,
                        ),
                        enterButton(
                          _formKey,
                          _submitForm,
                          'Зарегистрироваться',
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
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
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
                                ),
                              )),
                            )),
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
    BlocProvider.of<VpnAuthBloc>(context).add(VpnRegisterEvent(
        login: _emailController.text.trim(),
        password: _passController.text.trim()));
  }
}
