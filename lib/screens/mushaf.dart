import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';

class MushafScreen extends StatelessWidget {
  const MushafScreen({super.key, required this.state});
  final GoRouterState state;

  @override
  Widget build(BuildContext context) {
    final surahId = int.tryParse(state.uri.queryParameters['id'] ?? '');

    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        AppDatabase().surahDao.getSurahById(surahId ?? 1),
        AppDatabase().ayahDao.getAyahsBySurahId(surahId ?? 1)
      ]),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } 

        final surah = snapshot.data![0] as SurahData;
        final ayahList = snapshot.data![1] as List<AyahData>;

        return Container(
          width: double.infinity,
          height: double.infinity,
          child : Column(
            children: [
              Center(
                child: Text("Qibla")
              )
            ],
          ),
        );
      }
    );
  }
}


