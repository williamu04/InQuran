import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child : Column(
        children: [
          Center(
            child: Text("Search")
          )
        ],
      ),
    );
  }
}


