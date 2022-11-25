import 'package:flutter/material.dart';
import 'package:ghost_vpn/config/router.dart';
import 'package:ghost_vpn/services/firebase_auth.dart';
import 'package:ghost_vpn/widgets/widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final Auth auth = Auth();
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();
  final _confirmPassFocus = FocusNode();

  String _warning;
  bool _isLoading;

  @override
  void initState() {
    _isLoading = false;
    super.initState();
  }

  @override
  void dispose() {
    print('dispose method in Register Page');
    _emailController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    _confirmPassFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: Colors.black,
            body: GestureDetector(
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
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        'Регистрация',
                        style: TextStyle(
                            fontSize: 52,
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
                      enterButton(_formKey, _submitForm, 'Зарегистрироваться',
                          Colors.white, false)
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  void _submitForm() async {
    print('Email: $_emailController');
    print('Password: $_passController');
    try {
      setState(() => _isLoading = true);
      await auth.createUserWithEmailAndPassword(
        _emailController.text.trim(),
        _passController.text.trim(),
      );
      await auth.sendVerificationEmail();
      Navigator.pushNamed(context, RoutesGenerator.WRAPPER);
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
      switch (error.toString()) {
        case "[firebase_auth/invalid-email] The email address is badly formatted.":
          setState(() {
            _warning = "Ваша почта недоступна.";
          });
          break;
        case "[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.":
          setState(() {
            _warning = "Слишком много запросов. Попробуйте позже.";
          });
          break;
        case "[firebase_auth/email-already-in-use] The email address is already in use by another account.":
          setState(() {
            _warning = "Почта уже создана.";
          });
          break;
        case "[firebase_auth/unknown] Given String is empty or null":
          setState(() {});
          break;
      }
    }
  }
}
