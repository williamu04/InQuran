import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/common/top_bar_utils.dart';
import 'package:mtqmnuns/components/rounded_card.dart';
import 'package:mtqmnuns/config/global.dart';
import 'package:mtqmnuns/routes/guard_navigation.dart';
import 'package:mtqmnuns/routes/route.dart';
import 'package:mtqmnuns/state/user.dart';
import 'package:mtqmnuns/viewmodel/user.dart';
import 'package:provider/provider.dart';

class HomeMenuItem {
  String title;
  IconData icon;
  Color buttonColor;
  Function() action;

  HomeMenuItem({
    required this.title,
    required this.icon,
    required this.buttonColor,
    required this.action,
  });
}

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    HomeMenuItem topItem = HomeMenuItem(
      title: "Baca Al Qur'an",
      icon: LucideIcons.bookOpen,
      buttonColor: const Color(0xFF672CBC),
      action: () => context.push(AppRoutes.surahList.path),
    );

    List<HomeMenuItem> menuItems = [
      HomeMenuItem(
        title: "Koleksi Doa-Doa",
        icon: LucideIcons.handHeart,
        buttonColor: const Color(0xFF3B1D77),
        action: () => context.push(AppRoutes.duasList.path),
      ),
      HomeMenuItem(
        title: "Waktu Salat",
        icon: LucideIcons.hourglass,
        buttonColor: const Color(0xFF3B1D77),
        action: () => context.push(AppRoutes.prayer.path),
      ),
      HomeMenuItem(
        title: "Arah Kiblat",
        icon: LucideIcons.compass,
        buttonColor: const Color(0xFF672CBC),
        action: () => context.push(AppRoutes.qibla.path),
      ),
      HomeMenuItem(
        title: "Favorit",
        icon: LucideIcons.bookMarked,
        buttonColor: const Color(0xFF672CBC),
        action: () => context.authPush(AppRoutes.favorites.path),
      ),
      HomeMenuItem(
        title: "Jelajahi",
        icon: LucideIcons.search,
        buttonColor: const Color(0xFF3B1D77),
        action: () => context.push(AppRoutes.search.path),
      ),
      HomeMenuItem(
        title: "Mode Voice Command",
        icon: LucideIcons.audioLines,
        buttonColor: const Color(0xFF3B1D77),
        action: () => GlobalConfig().setVoiceMode(true),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 85),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Expanded(flex: 1, child: _homeTitle(context)),
            Expanded(
              flex: 1,
              child: _homeMenu(
                context: context,
                topItem: topItem,
                menuItems: menuItems,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _homeTitle(BuildContext context) {
    return roundedCard(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TopBarUtility.buildDefaultTopBar(context: context, title: "InQuran"),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/img/logo.png', height: 40),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Assalamu'alaikum",
                            style: TextStyle(
                              color: Colors.white70,
                              fontFamily: 'Plus Jakarta',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Consumer<UserViewModel>(
                            builder: (context, vm, child) {
                              final state = vm.state;
                              Text usernameWidget(String username){
                                return Text(
                                  username,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Plus Jakarta',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                );

                              } 
                              switch (state) {
                                case UserLoadLoading():
                                  return usernameWidget("Loading..");
                                case UserLoadUnauthenticated():
                                  return usernameWidget("Sebelas Maret");
                                case UserLoaded(:final user):
                                  return usernameWidget(user.fullName ?? user.username);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.white38,
                ),
                const SizedBox(height: 20),
                const Center(
                  child: AutoSizeText(
                    'إِنَّ الَّذِينَ آمَنُوا وَعَمِلُوا '
                    'الصَّالِحَاتِ سَيَجْعَلُ لَهُمُ الرَّحْمَٰنُ وُدًّا',
                    textAlign: TextAlign.center,
                    maxFontSize: 22,
                    minFontSize: 18,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: AutoSizeText(
                    '“Sesungguhnya bagi orang-orang yang beriman dan beramal saleh, (Allah) Yang Maha Pengasih akan menanamkan rasa cinta (dalam hati) mereka.”',
                    textAlign: TextAlign.center,
                    maxFontSize: 10,
                    minFontSize: 9,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta',
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF994EF8),
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Maryam : 96',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta',
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF994EF8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _homeMenu({
    required BuildContext context,
    required HomeMenuItem topItem,
    required List<HomeMenuItem> menuItems,
    double gap = 8.0,
  }) {
    return Container(
      padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 15),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalHeight = constraints.maxHeight;

          int rows = 1;
          rows += (menuItems.length / 2).ceil();
          final totalGap = gap * (rows - 1);
          final buttonHeight = (totalHeight - totalGap) / rows;
          List<Widget> children = [];

          children.add(
            SizedBox(
              height: buttonHeight,
              width: double.infinity,
              child: _buildMenuButton(
                item: topItem,
                alignment: MainAxisAlignment.center,
              ),
            ),
          );

          for (int i = 0; i < menuItems.length; i += 2) {
            children.add(SizedBox(height: gap));

            if (i + 1 < menuItems.length) {
              children.add(
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: buttonHeight,
                        child: _buildMenuButton(item: menuItems[i]),
                      ),
                    ),
                    SizedBox(width: gap),
                    Expanded(
                      child: SizedBox(
                        height: buttonHeight,
                        child: _buildMenuButton(item: menuItems[i + 1]),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              children.add(
                SizedBox(
                  height: buttonHeight,
                  width: double.infinity,
                  child: _buildMenuButton(
                    item: menuItems[i],
                    alignment: MainAxisAlignment.center,
                  ),
                ),
              );
            }
          }
          return Column(children: children);
        },
      ),
    );
  }

  Widget _buildMenuButton({
    required HomeMenuItem item,
    MainAxisAlignment alignment = MainAxisAlignment.start,
  }) {
    return ElevatedButton(
      onPressed: item.action,
      style: ElevatedButton.styleFrom(
        backgroundColor: item.buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: EdgeInsets.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: alignment,
          children: [
            Icon(item.icon, color: Colors.white),
            const SizedBox(width: 10.0),
            Flexible(
              child: AutoSizeText(
                item.title,
                maxLines: 2,
                minFontSize: 10,
                maxFontSize: 14,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Plus Jakarta',
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
