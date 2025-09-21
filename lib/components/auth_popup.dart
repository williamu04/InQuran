import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/routes/route.dart';
import 'package:mtqmnuns/viewmodel/drawer.dart';
import 'package:provider/provider.dart';

class AuthRequiredPopUp extends StatelessWidget {
  const AuthRequiredPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthPopUpViewModel>(
      builder: (context, viewModel, child) {
        if (!viewModel.isOpen) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () => viewModel.close(),
          child: Container(
            color: Colors.black.withOpacity(0.4),
            child: Center(
              child: GestureDetector(
                onTap: () {},  
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black, width: 1.5),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Kamu Belum Login",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              decoration: TextDecoration.none
                            ),
                          ),
                          IconButton(
                            icon: const Icon(LucideIcons.x, color: Colors.black),
                            onPressed: () => viewModel.close(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: EdgeInsetsGeometry.only(left:8, right: 14), 
                        child: Text(
                          "Kamu harus login untuk mengakses fitur ini",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            decoration: TextDecoration.none
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            viewModel.close();
                            context.push(AppRoutes.login.path);
                            context.read<MenuSlideDrawerViewModel>().close();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF672CBC),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Log in",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
