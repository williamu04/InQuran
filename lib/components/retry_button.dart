import 'package:flutter/material.dart';

/// Reusable retry widget with message and button
class RetryWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const RetryWidget({
    super.key,
    this.message = "Error loading data",
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 16),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.purple),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: onRetry,
          child: const Text(
            "Coba Lagi",
            style: TextStyle(color: Colors.purple),
          ),
        ),
      ],
    );
  }
}