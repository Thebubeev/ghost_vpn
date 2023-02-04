import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_vpn/bloc/VPN_AUTH/vpn_auth_bloc.dart';
import 'package:ghost_vpn/services/firebase_auth.dart';
import 'package:ghost_vpn/widgets/loader_widget.dart';
import 'package:ghost_vpn/widgets/widget.dart';

class ForgetScreen extends StatefulWidget {
  @override
  _ForgetScreenState createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  final Auth auth = Auth();
  TextEditingController _emailController = TextEditingController();

  String? _warning;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    if (!mounted) return;
    _emailController.dispose();
    _warning = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VpnAuthBloc, VpnAuthState>(
      listener: (context, state) async {
        if (state is VpnAuthRecoveryPasswordState) {
          setState(() {
            _isLoading = false;
            _warning = 'Отправили ссылку на вашу почту';
            _emailController.text = '';
          });
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
        resizeToAvoidBottomInset: false,
        body: _isLoading
            ? LoaderWidget()
            : GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Form(
                  key: _formKey,
                  child: SafeArea(
                    child: ListView(padding: EdgeInsets.all(30), children: [
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
                        'Восстановить пароль',
                        style: TextStyle(fontSize: 39, color: Colors.white),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormEmailField(
                              emailController: _emailController,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            enterButton(
                              _formKey,
                              _submitForm,
                              'Восстановить пароль',
                            )
                          ],
                        ),
                      )
                    ]),
                  ),
                ),
              ),
      ),
    );
  }

  void _submitForm() async {
    setState(() {
      _isLoading = true;
    });
    BlocProvider.of<VpnAuthBloc>(context).add(VpnForgotPasswordEvent(
      login: _emailController.text.trim(),
    ));
  }
}
