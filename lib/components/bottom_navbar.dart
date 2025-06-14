import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mtqmnuns/config/route.dart';


Widget bottomNavBar(BuildContext context, GoRouterState state) {
  final currentRoute = state.uri.toString();
  final bottomNavPaths = AppRoutes.bottomNav.map((r) => r.path).toList();

  // Check if current route is part of bottomNav
  final isBottomNavRoute = bottomNavPaths.contains(currentRoute);
  final currentIndex = isBottomNavRoute
      ? bottomNavPaths.indexOf(currentRoute)
      : null;

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
          child: isBottomNavRoute
              ? BottomNavigationBar(
                  elevation: 0,
                  mouseCursor: SystemMouseCursors.basic,
                  type: BottomNavigationBarType.fixed,
                  currentIndex: currentIndex!,
                  backgroundColor: Colors.transparent,
                  selectedItemColor: const Color(0xFF3B1D77),
                  unselectedItemColor: Colors.grey,
                  selectedFontSize: 0,
                  unselectedFontSize: 0,
                  onTap: (index) {
                    context.go(AppRoutes.bottomNav[index].path);
                  },
                  items: AppRoutes.bottomNav.map((route) {
                    return BottomNavigationBarItem(
                      icon: Icon(route.icon),
                      label: '',
                    );
                  }).toList(),
                )
              : Row( 
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: AppRoutes.bottomNav.map((route) {
                    return IconButton(
                      icon: Icon(route.icon, color: Colors.grey),
                      onPressed: () {
                        context.go(route.path);
                      },
                    );
                  }).toList(),
                ),
        ),
      ),
    ),
  );
}
