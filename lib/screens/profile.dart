import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Bagian header profil
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF240F4F), Color(0xFF863ED5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.only(
                top: 24,
                left: 16,
                right: 16,
                bottom: 24,
              ),
              child: Column(
                children: [
                  // Top bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(Icons.menu, color: Colors.white),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Account ',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'Profile',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.settings, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Avatar (kotak putih)
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  const SizedBox(height: 12),

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
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Menu dan tombol dalam Expanded agar tombol di bawah
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _buildMenuItem("Notes"),
                    _buildMenuItem("Favourites", trailing: "2 Items"),
                    _buildMenuItem("Points"),
                    _buildMenuItem("Settings"),
                    _buildMenuItem("Help & Support"),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),

                    // Tombol paling bawah
                    Column(
                      children: [
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
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, {String? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          Row(
            children: [
              if (trailing != null)
                Text(trailing, style: const TextStyle(color: Colors.grey)),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right),
            ],
          ),
        ],
      ),
    );
  }
}
