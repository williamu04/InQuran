import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Contoh Cara untuk parameter :
// context.go(
//   Uri(path: AppRoutes.surah.path, queryParameters: {
//     'id': '20',
//     'ayah': '5',
//   }).toString()
// );

class SurahScreen extends StatelessWidget {
  const SurahScreen({super.key, required this.state});

  final GoRouterState state;

  @override
  Widget build(BuildContext context) {
    final surahId = int.tryParse(state.uri.queryParameters['id'] ?? '');
    final ayah = int.tryParse(state.uri.queryParameters['ayah'] ?? '1');

    return Container(
      width: double.infinity,
      height: double.infinity,
      child : Column(
        children: [
          Center(
            child: Text(surahId.toString())
          ),
          Center(
            child: Text( ayah.toString())
          )
        ],
      ),
    );
  }
}


