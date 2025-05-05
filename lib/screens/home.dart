import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child : Column(
        children: [
          homeTitle(),
          homeMenu()
        ],

      ),
    );
  }
}

Widget homeMenu() {
  return Flexible(
    child: Container(
    ),
  );
}


Widget homeTitle() {
  return Flexible(
    child: Container(
    ),
  );
}
