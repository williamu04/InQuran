import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/config/route.dart';
import 'package:mtqmnuns/routes/route.dart';
import 'package:mtqmnuns/viewmodel/drawer.dart';
import 'package:provider/provider.dart';

Widget topBar(BuildContext context, GoRouterState state) {
  String currentPath = state.uri.toString();
  AppRoute currentRoute = AppRoutes.getRouteByPath(currentPath);
  SettingSlideDrawerViewModel settingDrawerVm = context.read<SettingSlideDrawerViewModel>();
  MenuSlideDrawerViewModel menuDrawerVm = context.read<MenuSlideDrawerViewModel>();

  Color backgroundColor = Colors.transparent;
  Color iconColor;
  Color titleColor;
  MainAxisAlignment titleAlignment;
  String title; 

  title = currentRoute.title;

  if (currentRoute.isHasPurpleBanner) {
    iconColor = Colors.white;
    titleColor = Colors.white;
  } else {
    iconColor = const Color(0xFF7C8BA0);
    titleColor = const Color(0xFF672CBC);
  }

  final List<String> centerTitle = [
            AppRoutes.surahList.path, 
            AppRoutes.search.path, 
            AppRoutes.duas.path, 
            AppRoutes.profile.path,
            AppRoutes.voice.path
            ];

  final bool shouldCenterTitle = centerTitle.contains(state.uri.toString());
  if (shouldCenterTitle) {
    titleAlignment = MainAxisAlignment.center;
  } else {
    titleAlignment = MainAxisAlignment.start;
  }


  return PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: Container(
      padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
      color: backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                LucideIcons.alignLeft,
                color: iconColor,
              ),
              onPressed:() => menuDrawerVm.open() ,
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: titleAlignment,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: "Plus Jakarta",
                      color: titleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              LucideIcons.settings,
              color: iconColor,
            ),
            onPressed: () => settingDrawerVm.open(),
          ),
        ],
      ),
    ),
  );
}

