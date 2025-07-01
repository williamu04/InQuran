import 'package:flutter/material.dart';
import 'package:mtqmnuns/components/rounded_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child : Column(
        children: [
          RoundedCard(
            child: Text('test')
          ),
          Center(
            child: Text("Search")
          )
        ],
      ),
    );
  }
}


