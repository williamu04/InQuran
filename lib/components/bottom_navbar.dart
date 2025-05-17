import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mtqmnuns/config/route.dart';


Widget bottomNavBar(BuildContext context, GoRouterState state) {
  final currentRoute = state.uri.toString();

  // Find the current index based on matching path
  final currentIndex = AppRoutes.all.indexWhere((route) => route.path == currentRoute);

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 36),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          color: const Color(0xFFF5F9FE),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BottomNavigationBar(
            elevation: 0,
            mouseCursor: SystemMouseCursors.basic,
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex == -1 ? 0 : currentIndex,
            backgroundColor: Colors.transparent,
            selectedItemColor: const Color(0xFF3B1D77),
            unselectedItemColor: Colors.grey,
            selectedFontSize: 0,
            unselectedFontSize: 0,
            onTap: (index) {
              context.go(AppRoutes.all[index].path);
            },
            items: AppRoutes.all.map((route) {
              return BottomNavigationBarItem(
                icon: Icon(route.icon),
                label: '',
              );
            }).toList(),
          ),
        ),
      ),
    ),
  );
}

