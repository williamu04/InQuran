import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mtqmnuns/components/rounded_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return roundedCard(
      child: Column(
        children: [
          Column(
            children: [
              // Top bar
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                "Sebelas Maret",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Basic Account ",
                    style: TextStyle(color: Colors.white70),
                  ),
                  Icon(Icons.info_outline, color: Colors.white70, size: 14),
                ],
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ) 
    ); 
  }

  Widget aa(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),

        OutlinedButton(
          onPressed: () {
            context.push('/signup');
          },
          child: const Text("Go to Signup"),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {
            context.push('/login');
          },
          child: const Text("Go to Login"),
        ),
        const SizedBox(height: 16),
      ],
    );

  }
}
