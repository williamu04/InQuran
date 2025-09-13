
import 'package:flutter/material.dart';
import 'package:mtqmnuns/components/rounded_card.dart';
import 'package:mtqmnuns/dto/surah.dart';
import 'package:mtqmnuns/state/surah.dart';
import 'package:mtqmnuns/viewmodel/surah.dart';
import 'package:provider/provider.dart';

class MushafSurahScreen extends StatelessWidget {
  const MushafSurahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SurahDetailViewModel>(
      builder: (context, vm, child) {
        final state = vm.state;

        switch (state) {
          case SurahLoading():
            return Center(child: CircularProgressIndicator());
          case SurahError(:var message):
            return Center(child: Text("Error: $message")); 
          case SurahSuccess(:var ayahs):
            return _buildSurah(ayahs);
        }
      }
    );
  }

  Widget _buildSurah(List<AyahWithSurahDto> s) {
    return Padding(
      padding: EdgeInsetsGeometry.only(
        left: 20,
        right: 20,
        bottom: 107,
      ),
      child: Column(
        children: [
          _buildHeader(s[0]),
          Expanded(child:_buildMushaf())
        ],
      ),
    );
  }

  Widget _buildHeader(AyahWithSurahDto s) {
    return roundedCard(
      allRounded: true,
      padding: EdgeInsetsGeometry.symmetric(horizontal: 30, vertical: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Juz ${s.juzNumber}",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                decoration: BoxDecoration(
                  color: Color(0xFF994EF8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text(
                      "Page ",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w100,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "001",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(color: Color(0xFF994EF8), thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '${s.nameLatin} | ',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    s.nameIndo,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
              Text(
                s.surahName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Al Jazeera',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMushaf() {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 10, right: 10),
      child: LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;

        debugPrint("Mushaf size → width: $width, height: $height");

        return Container(
          color: Colors.blue,
          width: width,
          height: height,
        );
      },
    ),
    );
  }
  // Size measureTextSize(String text, TextStyle style, double maxWidth) {
  //   final TextPainter textPainter = TextPainter(
  //     text: TextSpan(text: text, style: style),
  //     maxLines: null, 
  //     textDirection: TextDirection.ltr,
  //   )..layout(maxWidth: maxWidth);

  //   return textPainter.size; // gives width and height
  // }


  
}