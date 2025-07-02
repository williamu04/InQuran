import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mtqmnuns/routes/route.dart';


Widget bottomNavBar(BuildContext context, GoRouterState state) {
  final currentRoute = state.uri.toString();
  final bottomNavPaths = AppRoutes.bottomNav.map((r) => r.path).toList();
  final isBottomNavRoute = bottomNavPaths.contains(currentRoute);
  final currentIndex = isBottomNavRoute
      ? bottomNavPaths.indexOf(currentRoute)
      : -1;

  return Padding(
    padding: const EdgeInsets.only(bottom: 24, right: 36, left: 36),
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: AppRoutes.bottomNav.asMap().entries.map((entry) {
              final index = entry.key;
              final route = entry.value;
              final isSelected = currentIndex == index;
              
              return IconButton(
                icon: Icon(
                  route.icon,
                  color: isSelected ? const Color(0xFF3B1D77) : Colors.grey,
                ),
                onPressed: () {
                  context.push(route.path);
                },
              );
            }).toList(),
          ),
        ),
      ),
    ),
  );
}