import 'package:flutter/material.dart';
import 'package:mtqmnuns/components/search_box.dart';
import 'package:mtqmnuns/data/local/dao/surah_dao.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';

enum SurahViewMode { surah, juz }

class BookScreen extends StatelessWidget {
  const BookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24),
      height: double.infinity,
      child: Column(children: [searchBox(), Expanded(child: SurahWidget())]),
    );
  }
}

class SurahWidget extends StatefulWidget {
  const SurahWidget({super.key});

  @override
  _SurahWidgetState createState() => _SurahWidgetState();
}

class _SurahWidgetState extends State<SurahWidget> {
  SurahViewMode currentMode = SurahViewMode.surah; // Surah as Default

  void _switchToSurahMode() {
    setState(() {
      currentMode = SurahViewMode.surah;
    });
  }

  void _switchToJuzMode() {
    setState(() {
      currentMode = SurahViewMode.juz;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [surahNavContainer(), surahContainer()]);
  }

  Widget surahNavContainer() {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () {
              _switchToSurahMode();
            },
            child: Text('Surah'),
          ),
        ),
        Expanded(
          child: TextButton(
            onPressed: () {
              _switchToJuzMode();
            },
            child: Text('Juz'),
          ),
        ),
      ],
    );
  }

  Widget surahContainer() {
    if (currentMode == SurahViewMode.surah) {
      return surahViewMode();
    } else {
      return juzViewMode();
    }
  }

  Widget surahViewMode() {
    return Column(children: [Text('Surah View')]);
  }

  Widget juzViewMode() {
    Future<List<Map<String, dynamic>>> fetchJuzInfo() async {
      return AppDatabase().juzDao.getJuzInfo(AppDatabase().surahDao);
    }
    
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchJuzInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No data available"));
        }

        final juzList = snapshot.data!;

        return ListView.builder(
          itemCount: juzList.length,
          itemBuilder: (context, index) {
            final juz = juzList[index];
            return ListTile(
              title: Text('Juz ${juz['juz']}'),
              subtitle: Text(
                'Start: ${juz['startSurah']?.name} Ayah ${juz['startAyah']?.ayahNumber} '
                '→ End: ${juz['endSurah']?.name} Ayah ${juz['endAyah']?.ayahNumber}',
              ),
            );
          },
        );
      },
    );
  }
}
