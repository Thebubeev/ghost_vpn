import 'package:flutter/material.dart';

class SubscriptionCardBuyWidget extends StatelessWidget {
  final String label;
  final String imagePath;
  final String text;
  final String textButton;
  final bool isBackButton;
  const SubscriptionCardBuyWidget({
    this.label,
    this.imagePath,
    this.text,
    this.textButton,
    this.isBackButton,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isBackButton
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        label,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 19),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.white,
                            size: 26,
                          )),
                    ],
                  )
                : Text(
                    label,
                    style: const TextStyle(color: Colors.white, fontSize: 19),
                  ),
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              height: 200,
              width: 200,
            ),
            Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(primary: Colors.white),
                onPressed: () {},
                icon: const Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Colors.black,
                ),
                label: Text(
                  textButton,
                  style: TextStyle(color: Colors.black),
                ))
          ],
        ),
      ),
    );
  }
}
