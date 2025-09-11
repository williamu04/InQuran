import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mtqmnuns/components/rounded_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          roundedCard(
            child: Text('test')
          ),
          const Text(
            "Profile",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              context.push('/signup');
            },
            child: const Text('Go to Signup'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.push('/login');
            },
            child: const Text('Go to Login'),
          ),
        ],
      ),
    );
  }
}
