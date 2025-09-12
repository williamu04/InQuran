import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/common/top_bar_utils.dart';
import 'package:mtqmnuns/components/mic_button.dart';
import 'package:mtqmnuns/components/normal_button.dart';
import 'package:mtqmnuns/components/top_bar.dart';
import 'package:mtqmnuns/components/transcription_text.dart';
import 'package:mtqmnuns/config/global.dart';
import 'package:mtqmnuns/routes/route.dart';
import 'package:provider/provider.dart';
import '../components/rounded_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalConfig>(
      builder: (context, config, _) {
        if (config.isVoiceMode) {
          return VoiceHomeScreen();
        } else {
          return MainHomeScreen();
        }
      },
    );
  }
}

class HomeMenuItem {
  String title;
  IconData icon;
  Color buttonColor;
  Function() action;

  HomeMenuItem({required this.title,required this.icon,required this.buttonColor,required this.action});
}

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HomeMenuItem topItem = HomeMenuItem(
        title: "The Holy Quran",
        icon: LucideIcons.bookOpen,
        buttonColor: const Color(0xFF672CBC),
        action: () => context.push(AppRoutes.surahList.path),
      );

    List<HomeMenuItem> menuItems = [
      HomeMenuItem(
        title: "Duas Collection",
        icon: LucideIcons.handHeart,
        buttonColor: const Color(0xFF3B1D77),
        action: () => context.push(AppRoutes.duas.path),
      ),
      HomeMenuItem(
        title: "Prayer Times",
        icon: LucideIcons.hourglass,
        buttonColor: const Color(0xFF3B1D77),
        action: () => context.push(AppRoutes.prayer.path),
      ),
      HomeMenuItem(
        title: "Prayer Qibla",
        icon: LucideIcons.compass,
        buttonColor: const Color(0xFF672CBC),
        action: () => context.push(AppRoutes.qibla.path),
      ),
      HomeMenuItem(
        title: "Favorites",
        icon: LucideIcons.bookMarked,
        buttonColor: const Color(0xFF672CBC),
        action: () => context.push(AppRoutes.favorites.path),
      ),
      HomeMenuItem(
        title: "Explore",
        icon: LucideIcons.search,
        buttonColor: const Color(0xFF3B1D77),
        action: () => context.push(AppRoutes.search.path),
      ),
      HomeMenuItem(
        title: "Voice Command Mode",
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
            Expanded(
              flex: 1, 
              child: _homeTitle(context),
            ),
            Expanded(
              flex: 1,
              child: _homeMenu(
                context: context,
                topItem: topItem,
                menuItems: menuItems,
              ),
            )
          ],
        ),
      ),
    );
  }


  Widget _homeTitle(BuildContext context) {
    return roundedCard(
        padding: EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TopBarUtility.buildDefaultTopBar(context:context, title: "InQuran" ),  
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
                          children: const [
                            Text(
                              "Assalamu'alaikum",
                              style: TextStyle(
                                color: Colors.white70,
                                fontFamily: 'Plus Jakarta',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              'Sebelas Maret',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Plus Jakarta',
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(width: double.infinity, height: 1, color: Colors.white38),
                  const SizedBox(height: 24),
                  const Center(
                    child: AutoSizeText(
                      'إِنَّ الَّذِينَ آمَنُوا وَعَمِلُوا '
                      'الصَّالِحَاتِ سَيَجْعَلُ لَهُمُ الرَّحْمَٰنُ وُدًّا',
                      textAlign: TextAlign.center,
                      maxFontSize: 16,
                      minFontSize: 10,
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
                      '“Indeed, those who have believed and done righteous deeds - '
                      'the Most Merciful will appoint for them affection.”',
                      textAlign: TextAlign.center,
                      maxFontSize: 10,
                      minFontSize: 8,
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
                      'Thaha : 96',
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
            )
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
      )
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


class VoiceHomeScreen extends StatelessWidget {
  final ValueNotifier<bool> isListening = ValueNotifier(false);
  final globalConfig = GlobalConfig();

  VoiceHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _title(height),
          SizedBox(height: height * 0.055),
          MicButton(size: height * 0.3),
          SizedBox(height: height * 0.035),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TranscriptionText(),
              SizedBox(height: height * 0.008),
              _helpingText(height),
            ],
          ),
          SizedBox(height: height * 0.03),
          NormalButton(globalConfig: globalConfig),
        ],
      ),
    );
  }

  Widget _helpingText(double height) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: height * 0.25),
      child: Text(
        "Help those who are visually impaired to press the button",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color(0xFF7C8BA0),
          fontSize: height * 0.013,
          fontFamily: "Plus Jakarta",
        ),
      ),
    );
  }

  Widget _title(double height) {
    return Column(
      children: [
        Text(
          "Voice",
          style: TextStyle(
            fontFamily: "Plus Jakarta",
            fontSize: height * 0.035,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF672CBC),
            height: 1.0,
          ),
        ),
        Text(
          "Command",
          style: TextStyle(
            fontFamily: "Plus Jakarta",
            fontSize: height * 0.035,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF672CBC),
            height: 1.0,
          ),
        ),
        Text(
          "Mode",
          style: TextStyle(
            fontFamily: "Plus Jakarta",
            fontSize: height * 0.035,
            color: const Color(0xFF672CBC),
          ),
        ),
      ],
    );
  }
}