import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final String text;

  const GoogleSignInButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Color(0xFFF5F9FE),
          side: const BorderSide(color: Color(0xFFF5F9FE), width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator(strokeWidth: 2),)
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildGoogleIcon(),
                  SizedBox(width: 10,),
                  Text(
                    text,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "Google",
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildGoogleIcon() {
    return SizedBox(
      width: 30,  
      height: 30,
      child: Image.asset(
        'assets/img/google-logo.png',
        fit: BoxFit.contain,
      ),
    );
  }

}