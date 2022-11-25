import 'package:flutter/material.dart';

void _fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}

final _emailFocus = FocusNode();
final _passFocus = FocusNode();
final _confirmPassFocus = FocusNode();

bool _isPasswordVisible = false;

class TextFormEmailField extends StatefulWidget {
  final TextEditingController emailController;
  const TextFormEmailField({Key key, this.emailController}) : super(key: key);

  @override
  State<TextFormEmailField> createState() => _TextFormEmailFieldState();
}

class _TextFormEmailFieldState extends State<TextFormEmailField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Gilroy'),
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
      ),
      // autofocus: true,
      controller: widget.emailController,
      onFieldSubmitted: (_) {
        _fieldFocusChange(context, _emailFocus, _passFocus);
      },
      focusNode: _emailFocus,
      validator: (val) {
        if (val.isEmpty) {
          return 'Введите почту';
        } else if (!val.contains('@') || (!val.contains('.'))) {
          return 'Введите настоящую почту!';
        } else {
          return null;
        }
      },
      onSaved: (val) {
        setState(() {
          widget.emailController.text = val;
        });
      },
    );
  }
}

class TextFormPassField extends StatefulWidget {
  final TextEditingController passController;
  const TextFormPassField({Key key, this.passController}) : super(key: key);

  @override
  State<TextFormPassField> createState() => _TextFormPassFieldState();
}

class _TextFormPassFieldState extends State<TextFormPassField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          labelText: 'Пароль',
          labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Gilroy'),
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10)),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            icon: Icon(
              _isPasswordVisible == true
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: Colors.white,
            ),
          )),
      controller: widget.passController,
      focusNode: _passFocus,
      // autofocus: true,
      onFieldSubmitted: (_) {
        _fieldFocusChange(context, _passFocus, _confirmPassFocus);
      },
      validator: (String val) {
        if (val.isEmpty) {
          return 'Введите пароль';
        } else if (val.length < 6) {
          return 'Пароль должен содержать больше 6 символов!';
        } else {
          return null;
        }
      },
      obscureText: _isPasswordVisible ? false : true,
      onSaved: (val) {
        setState(() {
          widget.passController.text = val;
        });
      },
    );
  }
}

class TextFormConfirmPassField extends StatefulWidget {
  final TextEditingController passController, confirmPassController;
  const TextFormConfirmPassField(
      {Key key, this.passController, this.confirmPassController})
      : super(key: key);

  @override
  State<TextFormConfirmPassField> createState() =>
      _TextFormConfirmPassFieldState();
}

class _TextFormConfirmPassFieldState extends State<TextFormConfirmPassField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          labelText: 'Подтвердите пароль',
          labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Gilroy'),
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10)),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            icon: Icon(
              _isPasswordVisible == true
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: Colors.white,
            ),
          )),
      controller: widget.confirmPassController,
      // autofocus: true,
      focusNode: _confirmPassFocus,
      validator: (String val) {
        if (val.isEmpty) {
          return 'Введите пароль';
        } else if (val.length < 6) {
          return 'Пароль должен содержать больше 6 символов!';
        } else if (val.trim() != widget.passController.text.trim()) {
          return "Пароли должны быть одиноковыми";
        } else {
          return null;
        }
      },
      obscureText: _isPasswordVisible ? false : true,
      onSaved: (val) {
        setState(() {
          widget.passController.text = val;
        });
      },
    );
  }
}

class ShowAlert extends StatefulWidget {
  String warning;
  ShowAlert({Key key, @required this.warning}) : super(key: key);

  @override
  State<ShowAlert> createState() => _ShowAlertState();
}

class _ShowAlertState extends State<ShowAlert> {
  @override
  Widget build(BuildContext context) {
    if (widget.warning != null) {
      return Container(
        color: Colors.redAccent,
        child: Row(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Icon(Icons.error_outline)),
            Expanded(
              child: Text(
                widget.warning,
                style: TextStyle(
                    fontSize: 18, fontFamily: 'Gilroy', color: Colors.white),
                maxLines: 3,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    widget.warning = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(height: 0);
  }
}

Widget iconBackButton(BuildContext context) => IconButton(
    padding: EdgeInsets.only(top: 15, bottom: 15),
    alignment: Alignment.topLeft,
    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
    iconSize: 35,
    onPressed: () {
      Navigator.pop(context);
    });

Widget enterButton(GlobalKey<FormState> _formKey, Function _submitForm,
        String text, Color Color, bool isGoogle) =>
    GestureDetector(
        onTap: () async {
          if (_formKey.currentState.validate() && isGoogle == false) {
            _formKey.currentState.save();
            _submitForm();
          } else {
            _submitForm();
          }
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              color: Color),
          height: 70,
          width: 300,
          child: Center(
              child: isGoogle
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          text,
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
                    )
                  : Text(
                      text,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Gilroy',
                          fontSize: 17),
                    )),
        ));
