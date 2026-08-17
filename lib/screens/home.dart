import 'package:flutter/material.dart';
import 'package:mtqmnuns/config/global.dart';
import 'package:mtqmnuns/screens/home_main.dart';
import 'package:mtqmnuns/screens/home_voice.dart';
import 'package:mtqmnuns/viewmodel/favorites.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritesViewModel>().getAllFavorites();
    });
    super.initState();
  }

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