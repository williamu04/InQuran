
import 'package:flutter/material.dart';

class BookScreen extends StatelessWidget {
  const BookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child : Column(
        children: [
          Center(
            child: Text("Book")
          )
        ],

      ),
    );
  }
}

