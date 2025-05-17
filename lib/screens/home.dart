import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

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
  // List of menu items
  final List<String> menuItems = [
    'The Holy Quran',
    'Duas Collection',
    'Prayer Times',
    'Prayer Qibla',
    'Favourites',
    'Etc',
    'Etc',
  ];

  return Container(
    padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 55.0, bottom: 38.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Full-width button for the first item
        ElevatedButton(
          onPressed: () {
            print('${menuItems[0]} pressed');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF672CBC),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: EdgeInsets.zero, // Important: to control padding
          ),
          child: Container(
            height: 60.0,
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // padding kiri-kanan
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    LucideIcons.bookOpen,
                    color: Colors.white,
                    size: 24.0,
                  ),
                  const SizedBox(width: 10.0),
                  Flexible(
                    child: Text(
                      menuItems[0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Plus Jakarta',
                      ),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        // Grid for the remaining items
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 2.5,
          ),
          itemCount: menuItems.length - 1,
          itemBuilder: (context, index) {
            // Calculate row index (0-based) for the grid items
            int rowIndex = index ~/ 2 + 1;
            Color buttonColor = rowIndex % 2 == 0
                ? const Color(0xFF672CBC)
                : const Color(0xFF3B1D77);

            return ElevatedButton(
            onPressed: () {
              print('${menuItems[index + 1]} pressed');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: EdgeInsets.zero, // penting agar kita kontrol penuh padding
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14.0), // padding luar
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center, // untuk vertikal center
                children: [
                  const Icon(
                    LucideIcons.bookOpen,
                    color: Colors.white,
                    size: 24.0,
                  ),
                  const SizedBox(width: 10.0), // jarak dari icon ke teks
                  Expanded(
                    child: Text(
                      menuItems[index + 1],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Plus Jakarta',
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible, // atau hilangkan sama sekali
                      maxLines: 2, // opsional, batasi maksimal 2 baris
                    ),
                  ),
                  const SizedBox(width: 10.0), // jarak dari teks ke ujung kanan
                ],
              ),
            ),
            );
          },
        ),
      ],
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
