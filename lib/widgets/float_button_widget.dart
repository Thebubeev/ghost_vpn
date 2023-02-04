import 'package:flutter/material.dart';

class MyFloatButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  MyFloatButton({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.fromLTRB(30, 0, 0, 30),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.white,
          heroTag: null,
          onPressed: onPressed,
          label: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
        ),
      ),
    );
  }
}
