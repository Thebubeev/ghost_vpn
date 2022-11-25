import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ghost_vpn/config/router.dart';
import 'package:ghost_vpn/services/firebase_auth.dart';
import 'package:ghost_vpn/widgets/widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Auth auth = Auth();
  final _firebaseAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  String _warning;
  bool _isLoading;

  @override
  void initState() {
    _isLoading = false;
    super.initState();
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
                          _formKey, _submitForm, 'Войти', Colors.white, false),
                      SizedBox(
                        height: 10,
                      ),
                      enterButton(_formKey, () async {
                        try {
                          await auth.signInWithGoogle().then((value) {
                            if (value.user.uid != null) {
                              Navigator.pushNamed(
                                  context, RoutesGenerator.VPN_MAIN_SCREEN);
                            }
                          });
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      }, 'Войти с помощью Google', Colors.white, true),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgot');
                          },
                          child: Container(
                            child: Text(
                              'Забыли пароль?',
                              style: TextStyle(color: Colors.white),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  void _submitForm() async {
    try {
      setState(() => _isLoading = true);
      await auth
          .signInWithEmailAndPassword(
              _emailController.text.trim(), _passController.text.trim())
          .then((_) async => _firebaseAuth.currentUser.emailVerified
              ? Navigator.pushReplacementNamed(context, '/home')
              : {
                  Fluttertoast.showToast(
                      msg: 'Пожалуйста, проверьте ваш email!',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 15,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 15.0),
                  await auth.sendVerificationEmail(),
                  setState(() {
                    _isLoading = false;
                  })
                });
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
      switch (error.toString()) {
        case "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.":
          setState(() {
            _warning = "Такого пользователя не существует!";
          });
          break;
        case "[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.":
          setState(() {
            _warning = "Слишком много запросов. Попробуйте позже!";
          });
          break;
        case "[firebase_auth/invalid-email] The email address is badly formatted.":
          setState(() {
            _warning = _firebaseAuth.currentUser.emailVerified
                ? "Почта не доступна."
                : 'Пожалуйста, подтвердите вашу почту.';
          });
          _firebaseAuth.currentUser.emailVerified
              ? null
              : await auth.sendVerificationEmail();
          break;
        case "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.":
          setState(() {
            _warning = "Логин или пароль неверный.";
          });
          break;
        case "[firebase_auth/unknown] Given String is empty or null":
          setState(() {});
          break;
      }
    }
  }
}
