import 'package:flutter/material.dart';

enum SurahViewMode {
  surah, juz
}
class BookScreen extends StatelessWidget {
  const BookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child : Column(
        children: [
          searchBox(),
          SurahWidget()
        ],

      ),
    );
  }
}

Widget searchBox() {
  return Container(

  );

}

class SurahWidget extends StatefulWidget {
  const SurahWidget({super.key});

  @override
  _SurahWidgetState createState() => _SurahWidgetState();
}

class _SurahWidgetState extends State<SurahWidget> {

  SurahViewMode currentMode = SurahViewMode.surah;  // Surah as Default

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
    return Column(
      children: [
        surahNavContainer(),
        surahContainer()
      ],
    );
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
    return Column(
      children: [
        Text('Surah View'),
      ],
    );
  }

  Widget juzViewMode() {
    return Column(
      children: [
        Text('Juz View'),
      ],
    );
  }
}

