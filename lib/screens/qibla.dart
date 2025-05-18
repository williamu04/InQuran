import 'package:flutter/material.dart';

class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child : Column(
        children: [
          Center(
            child: Text("Qibla")
          )
        ],
      ),
    );
  }
}


