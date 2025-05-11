import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child : Column(
        children: [
          homeTitle(),
          homeMenu()
        ],

      ),
    );
  }
}

Widget homeMenu() {
  return Flexible(
    child: Container(
    ),
  );
}


Widget homeTitle() {
  return Flexible(
    child: Container(
      padding: const EdgeInsets.all(48),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF863ED5), Color(0xFF240F4F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/logo.png',
                height: 50,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Assalamu’alaikum',
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
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Garis horizontal
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.white38,
          ),

          const SizedBox(height: 48),

          // Ayat dan terjemahan
          const Center(
          child: Text(
            'إِنَّ الَّذِينَ آمَنُوا وَعَمِلُوا '
            'الصَّالِحَاتِ سَيَجْعَلُ لَهُمُ الرَّحْمَٰنُ وُدًّا',
            textAlign: TextAlign.center,
            style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            ),
          ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              '“Indeed, those who have believed and done righteous deeds - '
              'the Most Merciful will appoint for them affection.”',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plus Jakarta',
                fontSize: 14,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400,
                color: Color(0xFF994EF8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Thaha : 96',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plus Jakarta',
                fontSize: 10,
                fontStyle: FontStyle.italic,
                color: Color(0xFF994EF8),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
