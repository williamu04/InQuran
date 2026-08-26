import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:inquran/routes/route.dart';
import 'package:inquran/routes/route_model.dart';
import 'package:inquran/common/app_color.dart';

class BottomNavicon {
  IconData icon;
  AppRoute route;
  BottomNavicon({required this.icon, required this.route});
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final navigations = [
      BottomNavicon(icon: LucideIcons.bookOpen, route: AppRoutes.surahList),
      BottomNavicon(icon: LucideIcons.search, route: AppRoutes.search),
      BottomNavicon(icon: LucideIcons.house, route: AppRoutes.home),
      BottomNavicon(icon: LucideIcons.handHeart, route: AppRoutes.doaList),
      BottomNavicon(icon: LucideIcons.heart, route: AppRoutes.favorites),
    ];

    return AnimatedBuilder(
      animation: GoRouter.of(context).routerDelegate,
      builder: (context, _) {
        final currentPath = GoRouter.of(context).state.uri.toString();
        final currentIndex = navigations.indexWhere(
          (nav) => nav.route.path == currentPath,
        );

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
                color: AppColors.background,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:
                      navigations.asMap().entries.map((entry) {
                        final index = entry.key;
                        final nav = entry.value;
                        final isSelected = index == currentIndex;

                        return IconButton(
                          icon: Icon(
                            nav.icon,
                            color:
                                isSelected
                                    ? AppColors.deepPurple
                                    : Colors.grey,
                          ),
                          onPressed: () {
                            if (!isSelected) {
                              context.push(nav.route.path);
                            }
                          },
                        );
                      }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}