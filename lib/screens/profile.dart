import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Profile",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              context.go('/signup');
            },
            child: const Text('Go to Signup'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.go('/login');
            },
            child: const Text('Go to Login'),
          ),
        ],
      ),
    );
  }
}
