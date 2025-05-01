import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(16),
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
  return Expanded(
    child: Container(
    ),
  );
}


Widget homeTitle() {
  return Expanded(
    child: Container(
    ),
  );
}
