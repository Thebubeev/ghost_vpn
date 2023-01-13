import 'package:flutter/material.dart';

class DraggableServersWidget extends StatelessWidget {
  const DraggableServersWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DraggableScrollableSheet(
        minChildSize: 0.30,
        maxChildSize: 0.60,
        initialChildSize: 0.30,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 41, 41, 40),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(45),
                  topLeft: Radius.circular(45),
                )),
            child: ListView.builder(
              controller: scrollController,
              itemCount: 7,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 5),
                    child: Divider(
                      indent: 140,
                      endIndent: 140,
                      thickness: 5.0,
                      color: Colors.black,
                    ),
                  );
                }
                return ListTile(
                  title: const Text(
                    'Амстердам 141.0.12.142',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300),
                  ),
                  leading: Image.asset(
                    'assets/flags/net.png',
                    fit: BoxFit.cover,
                    width: 35,
                    height: 35,
                  ),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      )),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
