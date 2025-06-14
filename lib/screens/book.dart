import 'package:flutter/material.dart';
import 'package:mtqmnuns/components/search_box.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';

enum SurahViewMode { surah, juz }

class BookScreen extends StatelessWidget {
  const BookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 36),
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
    return ListView(children: [surahNavContainer(), surahContainer()]);
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
    // return Column(children: [Text('Surah View')]);

    // Fetch Surah data from database using correct method name
    Future<List<SurahData>> fetchSurahData() async {
      return AppDatabase().surahDao.getAllSurahs();
    }

    // Function to get verse count for each surah using AyahDao
    Future<int> getVerseCount(int surahId) async {
      final ayahs = await AppDatabase().ayahDao.getAyahsBySurahId(surahId);
      return ayahs.length;
    }

    return FutureBuilder<List<SurahData>>(
      future: fetchSurahData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF672CBC)),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
              style: TextStyle(color: Colors.red[600]),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "No Surah data available",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        final surahList = snapshot.data!;

        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: 330),
            itemCount: surahList.length,
            itemBuilder: (context, index) {
              final surah = surahList[index];

              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      // Navigate to Surah detail page
                      // You can implement navigation here
                      print(
                        'PINDAH KE DETAIL AYAT ${surah.nameLatin} (ID: ${surah.id})',
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ), // Adjust padding as needed
                      child: Row(
                        children: [
                          // Number Circle with Star Background
                          SizedBox(
                            width: 45,
                            height: 45,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/img/star.png',
                                  width: 45,
                                  height: 45,
                                  fit: BoxFit.cover,
                                  color: Color(
                                    0xFF672CBC,
                                  ),
                                ),
                                Text(
                                  '${surah.id}',
                                  style: TextStyle(
                                    color:
                                        Color(0xFF3B1D77),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),

                          // Surah Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  surah.nameLatin,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF3B1D77),
                                  ),
                                ),
                                SizedBox(height: 4),
                                FutureBuilder<int>(
                                  future: getVerseCount(surah.id),
                                  builder: (context, verseSnapshot) {
                                    if (verseSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      // Show loading or use fallback data
                                      return Row(
                                        children: [
                                          Text(
                                            surah.place,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF7C8BA0),
                                            ),
                                          ),
                                          Text(
                                            ' • ',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF7C8BA0),
                                            ),
                                          ),
                                          Text(
                                            'Loading...', // Indicate loading for verse count
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF7C8BA0),
                                            ),
                                          ),
                                        ],
                                      );
                                    }

                                    final verseCount =
                                        verseSnapshot.data ?? surah.totalAyah;
                                    return Row(
                                      children: [
                                        Text(
                                          surah.place,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Text(
                                          ' • ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Text(
                                          '$verseCount Verse${verseCount > 1 ? 's' : ''}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          // Arabic Name
                          Text(
                            surah.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF672CBC),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Divider to separate each Surah item
                  Divider(
                    color: Colors.grey[300],
                    height: 1, // Height of the divider
                    thickness: 1, // Thickness of the divider
                    indent: 16, // Start indent of the divider
                    endIndent: 16, // End indent of the divider
                  ),
                ],
              );
            },
          ),
        );
      },
    );
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

        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: 330),
            itemCount: juzList.length,
            itemBuilder: (context, index) {
              final juz = juzList[index];
              final startSurah = juz['startSurah'];
              final endSurah = juz['endSurah'];
              final startAyah = juz['startAyah'];
              final endAyah = juz['endAyah'];
              final sameSurah = startSurah?.nameLatin == endSurah?.nameLatin;

              return Card(
                elevation: 0,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/img/star.png',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  '${juz['juz']}',
                                  style: const TextStyle(
                                    color: Color(0xFF672CBC),
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 16.0),
                          Text(
                            'Juz ${juz['juz']}',
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),

                      // Conditional rendering
                      if (sameSurah) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${startSurah?.nameLatin}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              'Verse ${startAyah?.ayahNumber} - ${endAyah?.ayahNumber}',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Color(0xFF672CBC),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Divider(color: Colors.grey.shade300, thickness: 1.0),
                      ] else ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${startSurah?.nameLatin}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              'Verse ${startAyah?.ayahNumber} - ${startSurah?.totalAyah}',
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Color(0xFF672CBC),
                              ),
                            ),
                          ],
                        ),
                        Divider(color: Colors.grey.shade300, thickness: 0.6),
                        // const SizedBox(height: 4.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${endSurah?.nameLatin}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              'Verse 1 - ${endAyah?.ayahNumber}',
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Color(0xFF672CBC),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Divider(color: Colors.grey.shade400, thickness: 0.8),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
